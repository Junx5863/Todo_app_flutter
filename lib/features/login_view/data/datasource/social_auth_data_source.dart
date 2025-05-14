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
      if (user == null) throw InvalidCredentialException();
      await _getUserFromDBAndSaveSession(id: user.uid);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw AccountExistsWithDifferentCredentialException();
      } else if (e.code == 'invalid-credential') {
        throw InvalidCredentialException();
      }
    } catch (e) {
      throw LoginWithEmailException();
    }
    return null;
  }

  Future<void> _getUserFromDBAndSaveSession({required String id}) async {
    final userData = await _getUserFromDB(id: id);
    await _saveUserDataSharedPreferences(userData: userData);
  }

  Future<void> _saveUserDataSharedPreferences({
    required UserData userData,
  }) async {
    await sharedPreferences.setString('id', userData.uuid);
    await sharedPreferences.setString('email', userData.email);
    await sharedPreferences.setString('username', userData.username);
  }

  Future<UserData> _getUserFromDB({required String id}) async {
    try {
      final result = await db.collection('users').doc(id).get();
      if (result.data() == null) {
        throw DataBaseException(message: 'ddd');
      }
      return UserData.fromJson(result.data()!);
    } catch (e) {
      throw DataBaseException(message: e.toString());
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
        throw InvalidCredentialException();
      } else {
        throw LoginWithEmailException();
      }
    } catch (e) {
      throw LoginWithEmailException();
    }
  }
}
