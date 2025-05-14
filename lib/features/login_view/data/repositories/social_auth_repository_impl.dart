import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/errors/exceptions.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/login_view/data/datasource/social_auth_data_source.dart';
import 'package:dash_todo_app/features/login_view/domain/repositories/social_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialAuthRepositoryImpl implements SocialAuthRepository {
  SocialAuthRepositoryImpl({required this.socialAuthDataSource});

  final SocialAuthDataSource socialAuthDataSource;

  @override
  Future<Either<Failure, bool>> resetUserPassword({
    required String email,
  }) async {
    try {
      await socialAuthDataSource.resetUserPassword(email: email);
      return const Right(true);
    } catch (e) {
      return Left(
        ResetPasswordFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, User?>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final result = await socialAuthDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(result);
    } on AccountExistsWithDifferentCredentialException catch (e) {
      return Left(
        AccountExistsWithDifferentCredentialFailure(
          message: e.toString(),
        ),
      );
    } on InvalidCredentialException catch (e) {
      return Left(
        InvalidCredentialFailure(
          message: e.toString(),
        ),
      );
    } on LoginWithEmailException catch (e) {
      return Left(
        LoginWithEmailFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
