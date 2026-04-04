// lib/features/auth/data/repositories/auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rivr/core/models/user_settings.dart';
import 'package:rivr/core/services/i_auth_service.dart';
import 'package:rivr/core/services/auth_service.dart';
import 'package:rivr/core/services/i_user_settings_service.dart';
import '../../domain/repositories/i_auth_repository.dart';

/// Delegates auth operations to [IAuthService] and post-login settings sync
/// to [IUserSettingsService].
class AuthRepository implements IAuthRepository {
  final IAuthService _authService;
  final IUserSettingsService _settingsService;

  const AuthRepository({
    required IAuthService authService,
    required IUserSettingsService settingsService,
  })  : _authService = authService,
        _settingsService = settingsService;

  @override
  User? get currentUser => _authService.currentUser;

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  @override
  Future<AuthResult> signIn({required String email, required String password}) =>
      _authService.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) =>
      _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

  @override
  Future<AuthResult> signOut() => _authService.signOut();

  @override
  Future<AuthResult> resetPassword({required String email}) =>
      _authService.sendPasswordResetEmail(email: email);

  @override
  Future<Stream<User?>> getAuthState() async => _authService.authStateChanges;

  @override
  Future<bool> isBiometricAvailable() => _authService.isBiometricAvailable();

  @override
  Future<bool> isBiometricEnabled() => _authService.isBiometricEnabled();

  @override
  Future<AuthResult> signInWithBiometrics() => _authService.signInWithBiometrics();

  @override
  Future<AuthResult> enableBiometric() => _authService.enableBiometricLogin();

  @override
  Future<AuthResult> disableBiometric() => _authService.disableBiometricLogin();

  @override
  Future<UserSettings?> syncSettingsAfterLogin(String userId) =>
      _settingsService.syncAfterLogin(userId);
}
