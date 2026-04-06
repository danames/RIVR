// lib/features/forecast/domain/usecases/load_specific_forecast_usecase.dart

import 'package:rivr/core/models/reach_data.dart';
import 'package:rivr/core/services/service_result.dart';
import '../repositories/i_forecast_repository.dart';

class LoadSpecificForecastUseCase {
  final IForecastRepository _repository;
  const LoadSpecificForecastUseCase(this._repository);

  Future<ServiceResult<ForecastResponse>> call(
    String reachId,
    String forecastType,
  ) =>
      _repository.loadSpecificForecast(reachId, forecastType);
}
