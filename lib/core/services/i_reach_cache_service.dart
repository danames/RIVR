// lib/core/services/i_reach_cache_service.dart

import '../models/reach_data.dart';

/// Interface for caching ReachData objects
abstract class IReachCacheService {
  Future<void> initialize();
  bool get isReady;
  Future<ReachData?> get(String reachId);
  Future<void> store(ReachData reachData);
  Future<void> clearReach(String reachId);
  Future<void> clear();
  Future<bool> isCached(String reachId);
  Future<Map<String, dynamic>> getCacheStats();
  Map<String, dynamic> getCacheEffectiveness();
  Future<void> forceRefresh(String reachId);
  Future<int> cleanupStaleEntries();
}
