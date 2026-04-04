// lib/features/forecast/domain/usecases/refresh_forecast_usecase.dart

import 'package:rivr/core/models/reach_data.dart';
import '../repositories/i_forecast_repository.dart';

class RefreshForecastUseCase {
  final IForecastRepository _repository;
  const RefreshForecastUseCase(this._repository);

  Future<ForecastResponse> call(String reachId) => _repository.refresh(reachId);
}
