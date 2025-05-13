class LoginResult {
  final String id;
  final String name;
  final String accessToken;
  final String refreshToken;

  LoginResult(
      {required this.id,
      required this.name,
      required this.accessToken,
      required this.refreshToken});
}
