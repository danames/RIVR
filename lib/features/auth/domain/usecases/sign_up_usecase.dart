// lib/features/auth/domain/usecases/sign_up_usecase.dart

import 'package:rivr/core/services/auth_service.dart';
import '../repositories/i_auth_repository.dart';

class SignUpUseCase {
  final IAuthRepository _repository;
  const SignUpUseCase(this._repository);

  Future<AuthResult> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) =>
      _repository.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
}
