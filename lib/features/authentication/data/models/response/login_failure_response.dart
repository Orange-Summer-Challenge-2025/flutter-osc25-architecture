class LoginFailureResponse {
  String message;

  LoginFailureResponse({required this.message});

  factory LoginFailureResponse.fromJson(Map<String, dynamic> json) {
    return LoginFailureResponse(message: json['message']);
  }
}
