import 'package:dash_todo_app/features/login_view/presentation/pages/login_view.dart';
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
      //
      GoRoute(
        path: '/',
        builder: (context, state) {
          /* final routeArgs = state.extra as RouteArgumentsModel?; */
          return LoginPage();
        },
      ),
    ]);
