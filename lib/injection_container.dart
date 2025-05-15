import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_todo_app/features/home_view/presentation/bloc/home_dash_bloc.dart';
import 'package:dash_todo_app/features/login_view/data/datasource/social_auth_data_source.dart';
import 'package:dash_todo_app/features/login_view/data/repositories/social_auth_repository_impl.dart';
import 'package:dash_todo_app/features/login_view/domain/repositories/social_auth_repository.dart';
import 'package:dash_todo_app/features/login_view/domain/usecases/create_user_use_case.dart';
import 'package:dash_todo_app/features/login_view/domain/usecases/sign_in_email_password_use_case.dart';
import 'package:dash_todo_app/features/login_view/presentation/bloc/social_auth_bloc.dart';
import 'package:dash_todo_app/features/splash_view/bloc/splash_bloc.dart';
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

    /*-- Social Auth --*/
    ..registerFactory<SocialAuthBloc>(
      () => SocialAuthBloc(
        signInEmailPasswordUseCase: sl(),
        createEmailPasswordUseCase: sl(),
      ),
    )
    ..registerFactory<CreateEmailPasswordUseCase>(
      () => CreateEmailPasswordUseCase(
        socialAuthRepository: sl(),
      ),
    )
    ..registerFactory<SignInEmailPasswordUseCase>(
      () => SignInEmailPasswordUseCase(
        socialAuthRepository: sl(),
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
    )
    /*----------------*/

    /*-- Splash Screen --*/
    ..registerFactory<SplashCubit>(
      () => SplashCubit(),
    )
    /*----------------*/

    /*-- Home Dash Screen --*/
    ..registerFactory<HomeDashCubit>(
      () => HomeDashCubit(),
    );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}
