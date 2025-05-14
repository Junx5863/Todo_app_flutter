import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_todo_app/features/login_view/data/datasource/social_auth_data_source.dart';
import 'package:dash_todo_app/features/login_view/data/repositories/social_auth_repository_impl.dart';
import 'package:dash_todo_app/features/login_view/domain/repositories/social_auth_repository.dart';
import 'package:dash_todo_app/features/login_view/presentation/bloc/social_auth_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerLazySingleton<FirebaseAuth>(
      () => FirebaseAuth.instance,
    )
    ..registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    )
    ..registerLazySingleton<FirebaseStorage>(
      () => FirebaseStorage.instance,
    )
    ..registerFactory<SocialAuthBloc>(
      () => SocialAuthBloc(
        signInEmailPasswordUseCase: sl(),
      ),
    )
    ..registerFactory<SocialAuthRepository>(
      () => SocialAuthRepositoryImpl(
        socialAuthDataSource: sl(),
      ),
    )
    ..registerFactory<SocialAuthDataSource>(
      () => SocialAuthDataSourceImpl(
        sharedPreferences: sl(),
        auth: sl(),
        db: sl(),
      ),
    );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}
