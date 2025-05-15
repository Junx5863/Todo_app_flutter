import 'package:dash_todo_app/core/navigation/name_router.dart';
import 'package:dash_todo_app/features/home_view/presentation/pages/home_dash_view.dart';
import 'package:dash_todo_app/features/login_view/presentation/pages/login_view.dart';
import 'package:dash_todo_app/features/splash_view/presentation/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

final appRouter = GoRouter(
  errorPageBuilder: (context, state) => const MaterialPage(
    child: Scaffold(
      body: Center(
        child: Text('Error'),
      ),
    ),
  ),
  routes: [
    GoRoute(
      path: RoutePathsName.splashView,
      builder: (context, state) {
        /* final routeArgs = state.extra as RouteArgumentsModel?; */
        return SplashView();
      },
    ),
    GoRoute(
      path: RoutePathsName.login,
      builder: (context, state) {
        /* final routeArgs = state.extra as RouteArgumentsModel?; */
        return LoginPage();
      },
    ),
    GoRoute(
      path: RoutePathsName.home,
      builder: (context, state) {
        /* final routeArgs = state.extra as RouteArgumentsModel?; */
        return HomeDashView();
      },
    ),
  ],
);
