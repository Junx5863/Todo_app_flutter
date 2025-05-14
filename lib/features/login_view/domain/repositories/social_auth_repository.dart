import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class SocialAuthRepository {
  Future<Either<Failure, User?>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, bool>> resetUserPassword({
    required String email,
  });
}
