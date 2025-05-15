class AuthResponce {
  final String? email;
  final String token;
  final String displayName;
  final String? role;

  AuthResponce({
    required this.email,
    required this.token,
    required this.displayName,
    required this.role,
  });

  factory AuthResponce.fromJson(Map<String, dynamic> json) {
    return AuthResponce(
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      displayName: json['displayName'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
