// lib/features/forecast/domain/usecases/load_complete_forecast_usecase.dart

import 'package:rivr/core/models/reach_data.dart';
import 'package:rivr/core/services/service_result.dart';
import '../repositories/i_forecast_repository.dart';

class LoadCompleteForecastUseCase {
  final IForecastRepository _repository;
  const LoadCompleteForecastUseCase(this._repository);

  Future<ServiceResult<ForecastResponse>> call(String reachId) =>
      _repository.loadComplete(reachId);
}
