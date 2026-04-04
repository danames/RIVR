// lib/features/forecast/domain/usecases/load_forecast_supplementary_usecase.dart

import 'package:rivr/core/models/reach_data.dart';
import '../repositories/i_forecast_repository.dart';

class LoadForecastSupplementaryUseCase {
  final IForecastRepository _repository;
  const LoadForecastSupplementaryUseCase(this._repository);

  Future<ForecastResponse> call(String reachId, ForecastResponse existingData) =>
      _repository.loadSupplementary(reachId, existingData);
}
