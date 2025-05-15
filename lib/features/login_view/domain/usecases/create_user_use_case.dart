import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/base/base_usecase.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/login_view/domain/repositories/social_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateEmailPasswordUseCase
    extends BaseUseCase<User?, CreateEmailPasswordParams> {
  CreateEmailPasswordUseCase({required this.socialAuthRepository});
  final SocialAuthRepository socialAuthRepository;

  @override
  Future<Either<Failure, User?>> call(CreateEmailPasswordParams params) {
    return socialAuthRepository.createUserWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class CreateEmailPasswordParams {
  CreateEmailPasswordParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
