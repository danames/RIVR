// lib/services/1_contracts/shared/i_forecast_cache_service.dart

import 'package:rivr/models/1_domain/shared/reach_data.dart';
import 'package:rivr/services/1_contracts/shared/i_reach_cache_service.dart';

/// Interface for disk-caching complete [ForecastResponse] objects.
///
/// Enables stale-while-revalidate: previously visited rivers show cached
/// forecast data instantly, with background refresh when stale.
abstract class IForecastCacheService {
  Future<void> initialize();
  bool get isReady;

  /// Returns null on cache miss or hard expiry.
  /// Returns [CacheFreshness.fresh] if within the soft TTL (no network needed).
  /// Returns [CacheFreshness.stale] if between soft TTL and hard expiry
  /// (serve immediately, caller should refresh in background).
  Future<CacheResult<ForecastResponse>?> getWithFreshness(String reachId);

  /// Persist a [ForecastResponse] to disk. Overwrites any existing entry.
  Future<void> store(String reachId, ForecastResponse response);

  /// Remove the cache entry for a specific reach.
  Future<void> clearReach(String reachId);

  /// Remove all forecast cache entries (used on unit change).
  Future<void> clearAll();

  Future<Map<String, dynamic>> getCacheStats();
}
