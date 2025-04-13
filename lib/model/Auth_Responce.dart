class AuthResponce {
  final String? email;
  final String token;
  final String displayName;

  AuthResponce({
    required this.email,
    required this.token,
    required this.displayName,
  });

  factory AuthResponce.fromJson(Map<String, dynamic> json) {
    return AuthResponce(
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      displayName: json['displayName'] ?? '',
    );
  }
}
