// lib/features/forecast/domain/repositories/i_forecast_repository.dart

import 'package:rivr/core/models/reach_data.dart';
import 'package:rivr/core/services/i_forecast_service.dart';
import 'package:rivr/core/services/service_result.dart';

/// Repository contract for forecast data operations.
abstract class IForecastRepository {
  Future<ServiceResult<ForecastResponse>> loadOverview(String reachId);
  Future<ServiceResult<ForecastResponse>> loadSupplementary(
    String reachId,
    ForecastResponse existingData,
  );
  Future<ServiceResult<ForecastResponse>> loadComplete(String reachId);
  Future<ServiceResult<ForecastResponse>> loadSpecificForecast(
    String reachId,
    String forecastType,
  );
  Future<ServiceResult<ForecastResponse>> refresh(String reachId);
  Future<ServiceResult<ReachDetailsData>> getReachDetails(String reachId);
}
