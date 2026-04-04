// lib/features/auth/domain/usecases/get_auth_state_usecase.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/i_auth_repository.dart';

class GetAuthStateUseCase {
  final IAuthRepository _repository;
  const GetAuthStateUseCase(this._repository);

  Stream<User?> call() => _repository.authStateChanges;
}
