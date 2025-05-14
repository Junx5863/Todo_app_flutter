import 'package:dash_todo_app/core/base/base_page.dart';
import 'package:dash_todo_app/features/login_view/presentation/bloc/social_auth_bloc.dart';
import 'package:dash_todo_app/injection_container.dart';
import 'package:flutter/material.dart';

class LoginPage extends BasePage<SocialAuthState, SocialAuthBloc> {
  const LoginPage({super.key});

  @override
  SocialAuthBloc createBloc(BuildContext context) => sl<SocialAuthBloc>();

  @override
  Widget buildPage(
    BuildContext context,
    SocialAuthState state,
    SocialAuthBloc bloc,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
