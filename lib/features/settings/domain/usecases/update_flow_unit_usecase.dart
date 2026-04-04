// lib/features/settings/domain/usecases/update_flow_unit_usecase.dart

import 'package:rivr/core/models/user_settings.dart';
import '../repositories/i_settings_repository.dart';

class UpdateFlowUnitUseCase {
  final ISettingsRepository _repository;
  const UpdateFlowUnitUseCase(this._repository);

  Future<UserSettings?> call(String userId, FlowUnit flowUnit) =>
      _repository.updateFlowUnit(userId, flowUnit);
}
