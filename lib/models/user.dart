// ============================================================
// models/user.dart
// Holds information about the currently registered/logged-in user
// ============================================================

import 'gender.dart';

class UserModel {
  final String fullName;
  final String email;
  final Gender gender;

  const UserModel({
    required this.fullName,
    required this.email,
    required this.gender,
  });

  // Returns just the first name for a friendly greeting
  String get firstName => fullName.trim().split(' ').first;
}
