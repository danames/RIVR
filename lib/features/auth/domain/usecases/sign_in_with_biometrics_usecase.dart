// lib/features/auth/domain/usecases/sign_in_with_biometrics_usecase.dart

import 'package:rivr/core/services/auth_service.dart';
import '../repositories/i_auth_repository.dart';

class SignInWithBiometricsUseCase {
  final IAuthRepository _repository;
  const SignInWithBiometricsUseCase(this._repository);

  Future<AuthResult> call() => _repository.signInWithBiometrics();
}
