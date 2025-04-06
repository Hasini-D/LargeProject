// lib/models/user.dart

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String login;
  final String id;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.login,
    required this.id,
  });
}