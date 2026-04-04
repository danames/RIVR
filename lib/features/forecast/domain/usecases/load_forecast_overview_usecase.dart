// lib/features/forecast/domain/usecases/load_forecast_overview_usecase.dart

import 'package:rivr/core/models/reach_data.dart';
import '../repositories/i_forecast_repository.dart';

class LoadForecastOverviewUseCase {
  final IForecastRepository _repository;
  const LoadForecastOverviewUseCase(this._repository);

  Future<ForecastResponse> call(String reachId) => _repository.loadOverview(reachId);
}
