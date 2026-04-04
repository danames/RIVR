// lib/features/forecast/domain/usecases/get_reach_details_usecase.dart

import 'package:rivr/core/services/i_forecast_service.dart';
import '../repositories/i_forecast_repository.dart';

class GetReachDetailsUseCase {
  final IForecastRepository _repository;
  const GetReachDetailsUseCase(this._repository);

  Future<ReachDetailsData> call(String reachId) => _repository.getReachDetails(reachId);
}
