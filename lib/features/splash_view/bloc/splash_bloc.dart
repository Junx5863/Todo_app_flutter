import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState.initial());

  Future init() async {
    await Future.delayed(const Duration(seconds: 6));
    if (FirebaseAuth.instance.currentUser != null) {
      emit(state.copyWith(status: SplashStatus.success));
    } else {
      emit(state.copyWith(status: SplashStatus.noAuth));
    }
  }
}
