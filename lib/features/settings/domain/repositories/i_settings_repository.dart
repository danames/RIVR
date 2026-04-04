// lib/features/settings/domain/repositories/i_settings_repository.dart

import 'package:rivr/core/models/user_settings.dart';

/// Repository contract for user settings operations.
abstract class ISettingsRepository {
  Future<UserSettings?> getUserSettings(String userId);
  Future<UserSettings?> updateFlowUnit(String userId, FlowUnit flowUnit);
  Future<UserSettings?> updateNotifications(String userId, bool enableNotifications);
  Future<UserSettings?> updateNotificationFrequency(String userId, int frequency);
  Future<UserSettings?> syncAfterLogin(String userId);
}
