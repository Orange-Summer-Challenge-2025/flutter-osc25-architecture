class LoginSuccessResponse {
  String token;
  String id;
  bool isFirstLogin;

  LoginSuccessResponse(
      {required this.token, required this.id, required this.isFirstLogin});

  factory LoginSuccessResponse.fromJson(Map<String, dynamic> json) {
    return LoginSuccessResponse(
      token: json['token'],
      id: json['id'],
      isFirstLogin: json['isFirstLogin'],
    );
  }
}
