import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dash_todo_app/core/base/base_page.dart';
import 'package:dash_todo_app/core/navigation/name_router.dart';
import 'package:dash_todo_app/core/styles/app_them.dart';
import 'package:dash_todo_app/features/splash_view/bloc/splash_bloc.dart';
import 'package:dash_todo_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashView extends BasePage<SplashState, SplashCubit> {
  const SplashView({super.key});

  @override
  SplashCubit createBloc(BuildContext context) => sl<SplashCubit>()..init();

  @override
  Widget buildPage(
    BuildContext context,
    SplashState state,
    SplashCubit bloc,
  ) {
    return Scaffold(
      backgroundColor: AppColors.black12,
      body: Center(
        child: BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state.status == SplashStatus.success) {
              context.go(RoutePathsName.home);
              return;
            } else if (state.status == SplashStatus.noAuth) {
              context.go(RoutePathsName.login);
              return;
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo o animación
              Lottie.asset(
                'assets/lottie/loadin_splash.json',
                width: 180,
                height: 180,
                fit: BoxFit.fill,
                repeat: true,
              ),
              const SizedBox(height: 40),
              // Texto opcional
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 25.0,
                      color: AppColors.white,
                    ),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: true,
                      repeatForever: true,
                      controller: AnimatedTextController(),
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Focus on what matters most',
                        ),
                        TypewriterAnimatedText(
                          'Check it off, achieve it all.',
                        ),
                        TypewriterAnimatedText(
                          'Plan your day, own your time',
                        ),
                        TypewriterAnimatedText(
                          'Dream it, plan it, do it.',
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
