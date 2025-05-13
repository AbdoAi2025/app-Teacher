

sealed class SplashEvent {}

class SplashEventLoading extends SplashEvent {}
class SplashEventGoToLogin extends SplashEvent {}
class SplashEventGoToHome extends SplashEvent {}
class SplashError extends SplashEvent {
  final String message;
  SplashError(this.message);
}