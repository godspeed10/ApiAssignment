class LoginResponse {
  final String error;
  final String token;

  const LoginResponse(this.error, this.token);

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        json["error"] ?? "",
        json["token"] ?? "",
      );
}
