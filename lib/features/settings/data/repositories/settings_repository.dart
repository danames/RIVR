// lib/features/settings/data/repositories/settings_repository.dart

import 'package:rivr/core/models/user_settings.dart';
import 'package:rivr/core/services/i_user_settings_service.dart';
import '../../domain/repositories/i_settings_repository.dart';

/// Thin wrapper around [IUserSettingsService] that satisfies the
/// [ISettingsRepository] contract.
class SettingsRepository implements ISettingsRepository {
  final IUserSettingsService _settingsService;

  const SettingsRepository({required IUserSettingsService settingsService})
      : _settingsService = settingsService;

  @override
  Future<UserSettings?> getUserSettings(String userId) =>
      _settingsService.getUserSettings(userId);

  @override
  Future<UserSettings?> updateFlowUnit(String userId, FlowUnit flowUnit) =>
      _settingsService.updateFlowUnit(userId, flowUnit);

  @override
  Future<UserSettings?> updateNotifications(String userId, bool enableNotifications) =>
      _settingsService.updateNotifications(userId, enableNotifications);

  @override
  Future<UserSettings?> updateNotificationFrequency(String userId, int frequency) =>
      _settingsService.updateNotificationFrequency(userId, frequency);

  @override
  Future<UserSettings?> syncAfterLogin(String userId) =>
      _settingsService.syncAfterLogin(userId);
}
