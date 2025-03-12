class AuthResponce {
  final String? email;
  final String token;

  AuthResponce({
    required this.email,
    required this.token,
  });

  factory AuthResponce.fromJson(Map<String, dynamic> json) {
    return AuthResponce(
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
