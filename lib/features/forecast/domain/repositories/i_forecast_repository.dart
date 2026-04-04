// lib/features/forecast/domain/repositories/i_forecast_repository.dart

import 'package:rivr/core/models/reach_data.dart';
import 'package:rivr/core/services/i_forecast_service.dart';

/// Repository contract for forecast data operations.
abstract class IForecastRepository {
  Future<ForecastResponse> loadOverview(String reachId);
  Future<ForecastResponse> loadSupplementary(
    String reachId,
    ForecastResponse existingData,
  );
  Future<ForecastResponse> loadComplete(String reachId);
  Future<ForecastResponse> refresh(String reachId);
  Future<ReachDetailsData> getReachDetails(String reachId);
}
