part of 'splash_bloc.dart';

enum SplashStatus {
  initial,
  loading,
  success,
  error,
  noAuth,
}

class SplashState {
  const SplashState({
    required this.status,
  });

  factory SplashState.initial() => const SplashState(
        status: SplashStatus.initial,
      );

  final SplashStatus status;

  SplashState copyWith({
    SplashStatus? status,
  }) {
    return SplashState(
      status: status ?? this.status,
    );
  }
}
