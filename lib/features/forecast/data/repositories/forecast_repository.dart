// lib/features/forecast/data/repositories/forecast_repository.dart

import 'package:rivr/core/models/reach_data.dart';
import 'package:rivr/core/services/i_forecast_service.dart';
import '../../domain/repositories/i_forecast_repository.dart';

/// Thin wrapper around [IForecastService] that satisfies
/// [IForecastRepository] — 1:1 delegation.
class ForecastRepository implements IForecastRepository {
  final IForecastService _forecastService;

  const ForecastRepository({required IForecastService forecastService})
      : _forecastService = forecastService;

  @override
  Future<ForecastResponse> loadOverview(String reachId) =>
      _forecastService.loadOverviewData(reachId);

  @override
  Future<ForecastResponse> loadSupplementary(
    String reachId,
    ForecastResponse existingData,
  ) =>
      _forecastService.loadSupplementaryData(reachId, existingData);

  @override
  Future<ForecastResponse> loadComplete(String reachId) =>
      _forecastService.loadCompleteReachData(reachId);

  @override
  Future<ForecastResponse> refresh(String reachId) =>
      _forecastService.refreshReachData(reachId);

  @override
  Future<ReachDetailsData> getReachDetails(String reachId) =>
      _forecastService.loadReachDetailsData(reachId);
}
