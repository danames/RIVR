// lib/features/auth/domain/usecases/enable_biometric_usecase.dart

import 'package:rivr/core/services/auth_service.dart';
import '../repositories/i_auth_repository.dart';

class EnableBiometricUseCase {
  final IAuthRepository _repository;
  const EnableBiometricUseCase(this._repository);

  Future<AuthResult> call() => _repository.enableBiometric();
}
