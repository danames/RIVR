// lib/core/di/service_locator.dart

import 'package:get_it/get_it.dart';
import 'package:rivr/services/1_contracts/shared/i_flow_unit_preference_service.dart';
import 'package:rivr/services/4_infrastructure/shared/flow_unit_preference_service.dart';
import 'package:rivr/services/1_contracts/shared/i_cache_service.dart';
import 'package:rivr/services/4_infrastructure/cache/cache_service.dart';
import 'package:rivr/services/1_contracts/shared/i_reach_cache_service.dart';
import 'package:rivr/services/4_infrastructure/cache/reach_cache_service.dart';
import 'package:rivr/services/1_contracts/shared/i_background_image_service.dart';
import 'package:rivr/services/4_infrastructure/media/background_image_service.dart';
import 'package:rivr/services/1_contracts/shared/i_auth_service.dart';
import 'package:rivr/services/4_infrastructure/auth/auth_service.dart';
import 'package:rivr/services/1_contracts/shared/i_noaa_api_service.dart';
import 'package:rivr/services/4_infrastructure/api/noaa_api_service.dart';
import 'package:rivr/services/1_contracts/shared/i_forecast_service.dart';
import 'package:rivr/services/4_infrastructure/forecast/forecast_service.dart';
import 'package:rivr/services/1_contracts/shared/i_favorites_service.dart';
import 'package:rivr/services/4_infrastructure/favorites/favorites_service.dart';
import 'package:rivr/services/1_contracts/shared/i_fcm_service.dart';
import 'package:rivr/services/4_infrastructure/fcm/fcm_service.dart';
import 'package:rivr/services/1_contracts/shared/i_user_settings_service.dart';
import 'package:rivr/services/4_infrastructure/settings/user_settings_service.dart';
import 'package:rivr/services/4_infrastructure/map/map_service_factory.dart';

// Repositories
import 'package:rivr/services/1_contracts/features/forecast/i_forecast_repository.dart';
import 'package:rivr/services/2_coordinators/features/forecast/forecast_repository_impl.dart';
import 'package:rivr/services/1_contracts/features/favorites/i_favorites_repository.dart';
import 'package:rivr/services/2_coordinators/features/favorites/favorites_repository_impl.dart';
import 'package:rivr/services/1_contracts/features/auth/i_auth_repository.dart';
import 'package:rivr/services/2_coordinators/features/auth/auth_repository_impl.dart';
import 'package:rivr/services/3_datasources/features/auth/auth_firebase_datasource.dart';
import 'package:rivr/services/3_datasources/features/auth/biometric_datasource.dart';
import 'package:rivr/services/1_contracts/features/settings/i_settings_repository.dart';
import 'package:rivr/services/2_coordinators/features/settings/settings_repository_impl.dart';
import 'package:rivr/services/3_datasources/features/settings/settings_firestore_datasource.dart';

// Forecast use cases
import 'package:rivr/models/2_usecases/features/forecast/load_forecast_overview_usecase.dart';
import 'package:rivr/models/2_usecases/features/forecast/load_forecast_supplementary_usecase.dart';
import 'package:rivr/models/2_usecases/features/forecast/load_complete_forecast_usecase.dart';
import 'package:rivr/models/2_usecases/features/forecast/refresh_forecast_usecase.dart';
import 'package:rivr/models/2_usecases/features/forecast/get_reach_details_usecase.dart';
import 'package:rivr/models/2_usecases/features/forecast/load_specific_forecast_usecase.dart';

// Map use cases
import 'package:rivr/models/2_usecases/features/map/get_reach_details_for_map_usecase.dart';

// Favorites use cases
import 'package:rivr/models/2_usecases/features/favorites/initialize_favorites_usecase.dart';
import 'package:rivr/models/2_usecases/features/favorites/add_favorite_usecase.dart';
import 'package:rivr/models/2_usecases/features/favorites/remove_favorite_usecase.dart';
import 'package:rivr/models/2_usecases/features/favorites/update_favorite_usecase.dart';
import 'package:rivr/models/2_usecases/features/favorites/reorder_favorites_usecase.dart';
import 'package:rivr/models/2_usecases/features/favorites/refresh_all_favorites_usecase.dart';
import 'package:rivr/models/2_usecases/features/favorites/refresh_favorite_flow_usecase.dart';

// Auth use cases
import 'package:rivr/models/2_usecases/features/auth/sign_in_usecase.dart';
import 'package:rivr/models/2_usecases/features/auth/sign_up_usecase.dart';
import 'package:rivr/models/2_usecases/features/auth/sign_out_usecase.dart';
import 'package:rivr/models/2_usecases/features/auth/reset_password_usecase.dart';
import 'package:rivr/models/2_usecases/features/auth/get_auth_state_usecase.dart';
import 'package:rivr/models/2_usecases/features/auth/sign_in_with_biometrics_usecase.dart';
import 'package:rivr/models/2_usecases/features/auth/enable_biometric_usecase.dart';
import 'package:rivr/models/2_usecases/features/auth/disable_biometric_usecase.dart';

// Settings use cases
import 'package:rivr/models/2_usecases/features/settings/get_user_settings_usecase.dart';
import 'package:rivr/models/2_usecases/features/settings/update_flow_unit_usecase.dart';
import 'package:rivr/models/2_usecases/features/settings/update_notifications_usecase.dart';
import 'package:rivr/models/2_usecases/features/settings/update_notification_frequency_usecase.dart';
import 'package:rivr/models/2_usecases/features/settings/sync_settings_after_login_usecase.dart';

final sl = GetIt.instance;

/// Register all services in dependency order.
/// Call this once in main() before runApp().
void setupServiceLocator() {
  // ── Leaf services (no inter-service dependencies) ────────────────────────
  sl.registerLazySingleton<IFlowUnitPreferenceService>(
    () => FlowUnitPreferenceService(),
  );
  sl.registerLazySingleton<ICacheService>(() => CacheService());
  sl.registerLazySingleton<IReachCacheService>(() => ReachCacheService());
  sl.registerLazySingleton<IBackgroundImageService>(
    () => BackgroundImageService(),
  );
  // ── Datasources ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<SettingsFirestoreDatasource>(
    () => SettingsFirestoreDatasource(),
  );
  sl.registerLazySingleton<AuthFirebaseDatasource>(
    () => AuthFirebaseDatasource(),
  );
  sl.registerLazySingleton<BiometricDatasource>(
    () => BiometricDatasource(),
  );

  // ── Auth service (uses datasources) ───────────────────────────────────
  sl.registerLazySingleton<IAuthService>(
    () => AuthService(
      authDatasource: sl<AuthFirebaseDatasource>(),
      biometricDatasource: sl<BiometricDatasource>(),
    ),
  );

  // ── Services with one dependency ─────────────────────────────────────────
  sl.registerLazySingleton<INoaaApiService>(
    () => NoaaApiService(unitService: sl<IFlowUnitPreferenceService>()),
  );

  // ── Services with multiple dependencies ──────────────────────────────────
  sl.registerLazySingleton<IUserSettingsService>(
    () => UserSettingsService(
      datasource: sl<SettingsFirestoreDatasource>(),
      unitService: sl<IFlowUnitPreferenceService>(),
      imageService: sl<IBackgroundImageService>(),
    ),
  );

  sl.registerLazySingleton<IFavoritesService>(
    () => FavoritesService(
      settingsService: sl<IUserSettingsService>(),
      authService: sl<IAuthService>(),
    ),
  );

  sl.registerLazySingleton<IForecastService>(
    () => ForecastService(
      apiService: sl<INoaaApiService>(),
      cacheService: sl<IReachCacheService>(),
      unitService: sl<IFlowUnitPreferenceService>(),
    ),
  );

  sl.registerLazySingleton<IFCMService>(
    () => FCMService(settingsService: sl<IUserSettingsService>()),
  );

  // Map service factory (produces fresh page-scoped services)
  sl.registerFactory<MapServiceFactory>(() => MapServiceFactory());

  // ── Repositories ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<IForecastRepository>(
    () => ForecastRepositoryImpl(forecastService: sl<IForecastService>()),
  );

  sl.registerLazySingleton<IFavoritesRepository>(
    () => FavoritesRepositoryImpl(
      favoritesService: sl<IFavoritesService>(),
      forecastService: sl<IForecastService>(),
      cacheService: sl<IReachCacheService>(),
      unitService: sl<IFlowUnitPreferenceService>(),
      apiService: sl<INoaaApiService>(),
    ),
  );

  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      authService: sl<IAuthService>(),
      settingsService: sl<IUserSettingsService>(),
    ),
  );

  sl.registerLazySingleton<ISettingsRepository>(
    () => SettingsRepositoryImpl(settingsService: sl<IUserSettingsService>()),
  );

  // ── Use cases (registerFactory — stateless, new instance per injection) ──

  // Forecast
  sl.registerFactory(() => LoadForecastOverviewUseCase(sl<IForecastRepository>()));
  sl.registerFactory(() => LoadForecastSupplementaryUseCase(sl<IForecastRepository>()));
  sl.registerFactory(() => LoadCompleteForecastUseCase(sl<IForecastRepository>()));
  sl.registerFactory(() => RefreshForecastUseCase(sl<IForecastRepository>()));
  sl.registerFactory(() => GetReachDetailsUseCase(sl<IForecastRepository>()));
  sl.registerFactory(() => LoadSpecificForecastUseCase(sl<IForecastRepository>()));

  // Map
  sl.registerFactory(() => GetReachDetailsForMapUseCase(sl<IForecastRepository>()));

  // Favorites
  sl.registerFactory(() => InitializeFavoritesUseCase(sl<IFavoritesRepository>()));
  sl.registerFactory(() => AddFavoriteUseCase(sl<IFavoritesRepository>()));
  sl.registerFactory(() => RemoveFavoriteUseCase(sl<IFavoritesRepository>()));
  sl.registerFactory(() => UpdateFavoriteUseCase(sl<IFavoritesRepository>()));
  sl.registerFactory(() => ReorderFavoritesUseCase(sl<IFavoritesRepository>()));
  sl.registerFactory(() => RefreshAllFavoritesUseCase(sl<IFavoritesRepository>()));
  sl.registerFactory(() => RefreshFavoriteFlowUseCase(sl<IFavoritesRepository>()));

  // Auth
  sl.registerFactory(() => SignInUseCase(sl<IAuthRepository>()));
  sl.registerFactory(() => SignUpUseCase(sl<IAuthRepository>()));
  sl.registerFactory(() => SignOutUseCase(sl<IAuthRepository>()));
  sl.registerFactory(() => ResetPasswordUseCase(sl<IAuthRepository>()));
  sl.registerFactory(() => GetAuthStateUseCase(sl<IAuthRepository>()));
  sl.registerFactory(() => SignInWithBiometricsUseCase(sl<IAuthRepository>()));
  sl.registerFactory(() => EnableBiometricUseCase(sl<IAuthRepository>()));
  sl.registerFactory(() => DisableBiometricUseCase(sl<IAuthRepository>()));

  // Settings
  sl.registerFactory(() => GetUserSettingsUseCase(sl<ISettingsRepository>()));
  sl.registerFactory(() => UpdateFlowUnitUseCase(sl<ISettingsRepository>()));
  sl.registerFactory(() => UpdateNotificationsUseCase(sl<ISettingsRepository>()));
  sl.registerFactory(() => UpdateNotificationFrequencyUseCase(sl<ISettingsRepository>()));
  sl.registerFactory(() => SyncSettingsAfterLoginUseCase(sl<ISettingsRepository>()));
}
