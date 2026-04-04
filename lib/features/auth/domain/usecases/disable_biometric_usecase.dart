// lib/features/auth/domain/usecases/disable_biometric_usecase.dart

import 'package:rivr/core/services/auth_service.dart';
import '../repositories/i_auth_repository.dart';

class DisableBiometricUseCase {
  final IAuthRepository _repository;
  const DisableBiometricUseCase(this._repository);

  Future<AuthResult> call() => _repository.disableBiometric();
}
