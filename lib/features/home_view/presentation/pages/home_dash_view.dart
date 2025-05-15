import 'package:dash_todo_app/core/base/base_page.dart';
import 'package:dash_todo_app/features/home_view/presentation/bloc/home_dash_bloc.dart';
import 'package:dash_todo_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeDashView extends BasePage<HomeDashState, HomeDashCubit> {
  const HomeDashView({super.key});

  @override
  HomeDashCubit createBloc(BuildContext context) => sl<HomeDashCubit>();

  @override
  Widget buildPage(
      BuildContext context, HomeDashState state, HomeDashCubit bloc) {
    return Scaffold(
      body: BlocListener<HomeDashCubit, HomeDashState>(
        listener: (context, state) {
          // Handle any state changes if necessary
        },
        child: Center(
          child: Text(
            'Home Dash View',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
