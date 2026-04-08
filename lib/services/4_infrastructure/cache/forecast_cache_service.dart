// lib/services/4_infrastructure/cache/forecast_cache_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:rivr/models/1_domain/shared/reach_data.dart';
import 'package:rivr/services/3_datasources/shared/dtos/reach_data_dto.dart';
import 'package:rivr/services/4_infrastructure/logging/app_logger.dart';
import 'package:rivr/services/1_contracts/shared/i_forecast_cache_service.dart';
import 'package:rivr/services/1_contracts/shared/i_reach_cache_service.dart';

/// File-based cache for complete [ForecastResponse] objects.
///
/// Stores one JSON file per reach under:
///   `<cacheDir>/rivr_forecast_cache/<reachId>.json`
///
/// File format: `{ "cachedAt": <epochMs>, "data": { ...ForecastResponseDto... } }`
///
/// TTL policy:
/// - Soft freshness: 30 minutes (serve as fresh, skip network)
/// - Hard expiry: 6 hours (one NWM update cycle — data is meaningfully outdated)
class ForecastCacheService implements IForecastCacheService {
  ForecastCacheService();

  Directory? _cacheDir;

  int _cacheHits = 0;
  int _cacheMisses = 0;

  static const Duration _hardExpiry = Duration(hours: 6);
  static const Duration _softFreshness = Duration(minutes: 30);
  static const String _cacheDirName = 'rivr_forecast_cache';

  // ── Initialisation ───────────────────────────────────────────────────────────

  @override
  Future<void> initialize() async {
    try {
      final base = await getApplicationCacheDirectory();
      _cacheDir = Directory('${base.path}/$_cacheDirName');
      if (!await _cacheDir!.exists()) {
        await _cacheDir!.create(recursive: true);
      }
      AppLogger.info(
        'FORECAST_CACHE',
        'Initialized at ${_cacheDir!.path}',
      );
    } catch (e) {
      AppLogger.error('FORECAST_CACHE', 'Error initializing', e);
    }
  }

  @override
  bool get isReady => _cacheDir != null;

  // ── Core operations ────────────────────────────────────────────────────────

  @override
  Future<CacheResult<ForecastResponse>?> getWithFreshness(
    String reachId,
  ) async {
    try {
      await _ensureInitialized();

      final file = _fileFor(reachId);
      if (!await file.exists()) {
        _cacheMisses++;
        return null;
      }

      final wrapper =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(
        wrapper['cachedAt'] as int,
      );
      final age = DateTime.now().difference(cachedAt);

      // Hard expiry — delete and treat as miss
      if (age > _hardExpiry) {
        _cacheMisses++;
        await file.delete();
        AppLogger.debug(
          'FORECAST_CACHE',
          'Hard expired for reach: $reachId (age: ${age.inMinutes}m)',
        );
        return null;
      }

      final response = ForecastResponseDto.fromJson(
        wrapper['data'] as Map<String, dynamic>,
      );
      _cacheHits++;

      final freshness =
          age <= _softFreshness ? CacheFreshness.fresh : CacheFreshness.stale;

      AppLogger.debug(
        'FORECAST_CACHE',
        'Cache ${freshness.name} hit for reach: $reachId (age: ${age.inMinutes}m)',
      );

      return CacheResult(
        data: response,
        freshness: freshness,
        cachedAt: cachedAt,
      );
    } catch (e) {
      AppLogger.error(
        'FORECAST_CACHE',
        'Error in getWithFreshness for $reachId',
        e,
      );
      return null;
    }
  }

  @override
  Future<void> store(String reachId, ForecastResponse response) async {
    try {
      await _ensureInitialized();

      final wrapper = {
        'cachedAt': DateTime.now().millisecondsSinceEpoch,
        'data': ForecastResponseDto.toJson(response),
      };
      await _fileFor(reachId).writeAsString(jsonEncode(wrapper));
      AppLogger.debug('FORECAST_CACHE', 'Stored forecast for: $reachId');
    } catch (e) {
      AppLogger.error(
        'FORECAST_CACHE',
        'Error storing forecast for $reachId',
        e,
      );
    }
  }

  @override
  Future<void> clearReach(String reachId) async {
    try {
      await _ensureInitialized();

      final file = _fileFor(reachId);
      if (await file.exists()) {
        await file.delete();
      }
      AppLogger.debug('FORECAST_CACHE', 'Cleared cache for reach: $reachId');
    } catch (e) {
      AppLogger.error(
        'FORECAST_CACHE',
        'Error clearing reach $reachId',
        e,
      );
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _ensureInitialized();

      final files = await _listCacheFiles();
      for (final file in files) {
        await file.delete();
      }
      AppLogger.info(
        'FORECAST_CACHE',
        'Cleared ${files.length} cached forecasts',
      );
    } catch (e) {
      AppLogger.error('FORECAST_CACHE', 'Error clearing all cache', e);
    }
  }

  // ── Stats ──────────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      await _ensureInitialized();

      final files = await _listCacheFiles();
      int totalBytes = 0;
      int freshCount = 0;
      int staleCount = 0;

      for (final file in files) {
        try {
          final stat = await file.stat();
          totalBytes += stat.size;

          final wrapper =
              jsonDecode(await file.readAsString()) as Map<String, dynamic>;
          final cachedAt = DateTime.fromMillisecondsSinceEpoch(
            wrapper['cachedAt'] as int,
          );
          final age = DateTime.now().difference(cachedAt);

          if (age > _hardExpiry) {
            // Expired — will be cleaned up on next access
          } else if (age <= _softFreshness) {
            freshCount++;
          } else {
            staleCount++;
          }
        } catch (_) {
          // Skip corrupt entries
        }
      }

      return {
        'totalCached': files.length,
        'freshCount': freshCount,
        'staleCount': staleCount,
        'totalBytes': totalBytes,
        'hits': _cacheHits,
        'misses': _cacheMisses,
      };
    } catch (e) {
      AppLogger.error('FORECAST_CACHE', 'Error getting cache stats', e);
      return {'error': e.toString()};
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  File _fileFor(String reachId) => File('${_cacheDir!.path}/$reachId.json');

  Future<List<File>> _listCacheFiles() async {
    if (_cacheDir == null || !await _cacheDir!.exists()) return [];
    return _cacheDir!
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .toList();
  }

  Future<void> _ensureInitialized() async {
    if (_cacheDir == null) {
      await initialize();
    }
  }
}
