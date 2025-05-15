import 'package:bloc/bloc.dart';

part 'home_dash_state.dart';

class HomeDashCubit extends Cubit<HomeDashState> {
  HomeDashCubit() : super(HomeDashState.initial());
}
