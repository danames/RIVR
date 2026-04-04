// lib/features/auth/domain/usecases/reset_password_usecase.dart

import 'package:rivr/core/services/auth_service.dart';
import '../repositories/i_auth_repository.dart';

class ResetPasswordUseCase {
  final IAuthRepository _repository;
  const ResetPasswordUseCase(this._repository);

  Future<AuthResult> call({required String email}) =>
      _repository.resetPassword(email: email);
}
