class SignUp {
  final String username;
  final String email;
  final String role;
  SignUp({
    required this.username,
    required this.email,
    required this.role,
  });
  factory SignUp.fromJson(Map<String, dynamic> json) {
    return SignUp(
      username: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'role': role,
    };
  }
}
