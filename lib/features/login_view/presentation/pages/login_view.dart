import 'package:animate_do/animate_do.dart';
import 'package:dash_todo_app/core/base/base_page.dart';
import 'package:dash_todo_app/core/navigation/name_router.dart';
import 'package:dash_todo_app/core/styles/app_them.dart';
import 'package:dash_todo_app/core/utils/modals/error_page.dart';
import 'package:dash_todo_app/features/login_view/presentation/bloc/social_auth_bloc.dart';
import 'package:dash_todo_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';

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
    return BlocListener<SocialAuthBloc, SocialAuthState>(
      listener: (context, state) {
        if (state.status == SocialAuthStatus.error) {
          showErrorsModal(
            context: context,
            title: state.errorTitle,
            errorMessage: state.errorMessage,
            isError: true,
          );
        }
        if (state.status == SocialAuthStatus.success) {
          context.go(RoutePathsName.home);
        }

        if (state.status == SocialAuthStatus.successRegister) {
          showErrorsModal(
            context: context,
            title: 'Success',
            errorMessage: 'Register successful, please login',
            isError: false,
          );
        }
      },
      child: KeyboardDismissOnTap(
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
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(40)),
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
                                    ? loginSection(state, context, bloc)
                                    : registerSection(state, context, bloc)

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
      ),
    );
  }

  Widget loginSection(
      SocialAuthState state, BuildContext context, SocialAuthBloc bloc) {
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
            controller: state.emailTextEditingController,
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
                  controller: state.passwordTextEditingController,
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
        state.status == SocialAuthStatus.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Verde grisáceo
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    bloc.singInWithEmailPassword(
                      context: context,
                      email: state.emailTextEditingController.text,
                      password: state.passwordTextEditingController.text,
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
      ],
    );
  }

  Widget registerSection(
      SocialAuthState state, BuildContext context, SocialAuthBloc bloc) {
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
            controller: state.emailTextEditingControllerRegister,
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
                  controller: state.passwordTextEditingControllerRegister,
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
            onPressed: () {
              bloc.createUserWithEmailAndPassword(
                context: context,
                email: state.emailTextEditingControllerRegister.text,
                password: state.passwordTextEditingControllerRegister.text,
              );
            },
            child: const Text(
              'Register',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
      ],
    );
  }
}
