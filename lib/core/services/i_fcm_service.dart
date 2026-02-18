// lib/core/services/i_fcm_service.dart

/// Interface for Firebase Cloud Messaging operations
abstract class IFCMService {
  Future<bool> initialize();
  Future<bool> requestPermission();
  Future<String?> getAndSaveToken(String userId);
  Future<bool> enableNotifications(String userId);
  Future<void> disableNotifications(String userId);
  Future<bool> isEnabledForUser(String userId);
  Future<void> refreshTokenIfNeeded(String userId);
  void clearCache();
}
