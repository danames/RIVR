// lib/features/auth/domain/usecases/sign_in_usecase.dart

import 'package:rivr/core/services/auth_service.dart';
import '../repositories/i_auth_repository.dart';

class SignInUseCase {
  final IAuthRepository _repository;
  const SignInUseCase(this._repository);

  Future<AuthResult> call({required String email, required String password}) =>
      _repository.signIn(email: email, password: password);
}
