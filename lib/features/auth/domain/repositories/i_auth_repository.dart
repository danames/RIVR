// lib/features/auth/domain/repositories/i_auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rivr/core/models/user_settings.dart';
import 'package:rivr/core/services/auth_service.dart';

/// Repository contract for authentication operations.
/// Delegates to [IAuthService]; post-login settings sync goes via
/// [IUserSettingsService] (see [AuthRepository]).
abstract class IAuthRepository {
  User? get currentUser;
  Stream<User?> get authStateChanges;

  Future<AuthResult> signIn({required String email, required String password});
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });
  Future<AuthResult> signOut();
  Future<AuthResult> resetPassword({required String email});
  Future<Stream<User?>> getAuthState();

  Future<bool> isBiometricAvailable();
  Future<bool> isBiometricEnabled();
  Future<AuthResult> signInWithBiometrics();
  Future<AuthResult> enableBiometric();
  Future<AuthResult> disableBiometric();

  /// Sync user settings after a successful login.
  Future<UserSettings?> syncSettingsAfterLogin(String userId);
}
