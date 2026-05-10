// ============================================================
// controllers/auth_controller.dart
//
// Controller layer — all business logic lives here.
// The UI screens just call methods on this controller;
// they never do logic themselves.
// ============================================================

import '../models/user.dart';
import '../models/gender.dart';

// Enum to represent the current auth state of the app
enum AuthState {
  unauthenticated,
  authenticated,
}

class AuthController {
  // ----------------------------------------------------------
  // In-memory "database" of registered users
  // (In a real app this would be a backend/database call)
  // ----------------------------------------------------------
  static final Map<String, _StoredUser> _registeredUsers = {};

  // The currently logged-in user (null if nobody is logged in)
  static UserModel? currentUser;

  // Current auth state
  static AuthState authState = AuthState.unauthenticated;

  // ----------------------------------------------------------
  // Register a new user
  // Returns null on success, or an error message string.
  // ----------------------------------------------------------
  static String? register({
    required String fullName,
    required String email,
    required String password,
    required Gender gender,
  }) {
    final key = email.trim().toLowerCase();

    if (_registeredUsers.containsKey(key)) {
      return 'An account with this email already exists.';
    }

    _registeredUsers[key] = _StoredUser(
      fullName: fullName.trim(),
      email: key,
      password: password, // NOTE: plain-text only for demo; hash in production!
      gender: gender,
    );

    return null; // success
  }

  // ----------------------------------------------------------
  // Login
  // Returns null on success, or an error message string.
  // ----------------------------------------------------------
  static String? login({
    required String email,
    required String password,
  }) {
    final key = email.trim().toLowerCase();
    final stored = _registeredUsers[key];

    if (stored == null) {
      return 'No account found with this email.';
    }
    if (stored.password != password) {
      return 'Incorrect password. Please try again.';
    }

    // Auth successful — set the current user
    currentUser = UserModel(
      fullName: stored.fullName,
      email: stored.email,
      gender: stored.gender,
    );
    authState = AuthState.authenticated;

    return null; // success
  }

  // ----------------------------------------------------------
  // Logout
  // ----------------------------------------------------------
  static void logout() {
    currentUser = null;
    authState = AuthState.unauthenticated;
  }
}

// Private helper class — not exposed outside this file
class _StoredUser {
  final String fullName;
  final String email;
  final String password;
  final Gender gender;

  _StoredUser({
    required this.fullName,
    required this.email,
    required this.password,
    required this.gender,
  });
}
