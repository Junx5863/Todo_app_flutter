import 'package:animate_do/animate_do.dart';
import 'package:dash_todo_app/core/base/base_page.dart';
import 'package:dash_todo_app/core/styles/app_them.dart';
import 'package:dash_todo_app/features/login_view/presentation/bloc/social_auth_bloc.dart';
import 'package:dash_todo_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class LoginPage extends BasePage<SocialAuthState, SocialAuthBloc> {
  LoginPage({super.key});

  @override
  SocialAuthBloc createBloc(BuildContext context) => sl<SocialAuthBloc>();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isLoginSelected = ValueNotifier<bool>(true);
  @override
  Widget buildPage(
    BuildContext context,
    SocialAuthState state,
    SocialAuthBloc bloc,
  ) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Título
                        Text(
                          'Go ahead and set up\nyour account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Subtítulo
                        Text(
                          'Sign in to stay organized and productive',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.10,
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: ValueListenableBuilder<bool>(
                      valueListenable: isLoginSelected,
                      builder: (context, isLogin, child) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.60,
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(40)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tabs Login / Register
                              Container(
                                height: 60,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.grey200,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    // Login Button
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          isLoginSelected.value = true;
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isLogin
                                                ? AppColors.white
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isLogin
                                                  ? AppColors.background
                                                  : AppColors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Register Button
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          isLoginSelected.value = false;
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isLogin
                                                ? Colors.transparent
                                                : AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Register',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isLogin
                                                  ? AppColors.grey
                                                  : AppColors.background,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              isLogin
                                  ? loginSection(state, context)
                                  : registerSection()

                              // Campo Email
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginSection(SocialAuthState state, BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12), // Bordes redondeados
            boxShadow: [
              BoxShadow(
                color: AppColors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: TextField(
            controller: state.emailLoginTextEditingController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.white,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.email_outlined, color: AppColors.green700),
              ),
              labelText: 'Email Address',
              labelStyle: TextStyle(color: AppColors.grey600),
            ),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),

        // Campo Password
        ValueListenableBuilder<bool>(
            valueListenable: _obscurePassword,
            builder: (context, obscure, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: TextField(
                  controller: state.passwordLoginTextEditingController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.green700,
                      ),
                      onPressed: () {
                        _obscurePassword.value = !obscure;
                      },
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(
                        Icons.lock_outline,
                        color: AppColors.green700,
                      ),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: AppColors.grey600),
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  obscureText: obscure,
                  keyboardType: TextInputType.visiblePassword,
                ),
              );
            }),

        const SizedBox(height: 12),

        // Remember me & Forgot password

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),

        // Botón Login
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, // Verde grisáceo
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Login',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),

        // Divider con texto
        Row(
          children: const [
            Expanded(
              child: Divider(
                color: AppColors.black12,
                thickness: 1,
                endIndent: 12,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('Or login with'),
            ),
            Expanded(
                child: Divider(
              color: AppColors.black12,
              thickness: 1,
              endIndent: 12,
            )),
          ],
        ),

        SizedBox(height: MediaQuery.of(context).size.height * 0.03),

        // Botones Google y Facebook
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => {},
              child: Row(
                children: [
                  Image.asset('assets/images/google.png',
                      height: 24, width: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Google',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget registerSection() {
    return Container();
  }
}
