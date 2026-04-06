// lib/features/forecast/domain/usecases/load_forecast_overview_usecase.dart

import 'package:rivr/core/models/reach_data.dart';
import 'package:rivr/core/services/service_result.dart';
import '../repositories/i_forecast_repository.dart';

class LoadForecastOverviewUseCase {
  final IForecastRepository _repository;
  const LoadForecastOverviewUseCase(this._repository);

  Future<ServiceResult<ForecastResponse>> call(String reachId) =>
      _repository.loadOverview(reachId);
}
