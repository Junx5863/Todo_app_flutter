import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_todo_app/core/errors/exceptions.dart';
import 'package:dash_todo_app/features/login_view/domain/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SocialAuthDataSource {
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> resetUserPassword({required String email});
}

class SocialAuthDataSourceImpl implements SocialAuthDataSource {
  SocialAuthDataSourceImpl({
    required this.sharedPreferences,
    required this.db,
    required this.auth,
  });
  final SharedPreferences sharedPreferences;
  final FirebaseFirestore db;
  final FirebaseAuth auth;

  @override
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw AccountExistsWithDifferentCredentialException();
      } else if (e.code == 'invalid-credential') {
        throw InvalidCredentialException();
      } else {
        throw LoginWithEmailException();
      }
    } catch (e) {
      throw LoginWithEmailException();
    }
  }

  @override
  Future<void> resetUserPassword({required String email}) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeekPasswordException(message: e.message ?? '');
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException(message: e.message ?? '');
      } else if (e.code == 'invalid-email') {
        throw InvalidEmialException(
          message: e.message ?? '',
        );
      } else {
        throw LoginWithEmailException();
      }
    } catch (e) {
      throw LoginWithEmailException();
    }
  }
}
