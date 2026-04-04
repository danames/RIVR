// lib/features/settings/domain/usecases/update_notification_frequency_usecase.dart

import 'package:rivr/core/models/user_settings.dart';
import '../repositories/i_settings_repository.dart';

class UpdateNotificationFrequencyUseCase {
  final ISettingsRepository _repository;
  const UpdateNotificationFrequencyUseCase(this._repository);

  Future<UserSettings?> call(String userId, int frequency) =>
      _repository.updateNotificationFrequency(userId, frequency);
}
