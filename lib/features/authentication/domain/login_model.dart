class LoginModel {
  final String userId;
  final String token;
  final bool isFirstLogin;

  LoginModel({
    required this.userId,
    required this.token,
    required this.isFirstLogin,
  });
}
