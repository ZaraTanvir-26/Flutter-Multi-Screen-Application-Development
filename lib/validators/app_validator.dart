// ============================================================
// validators/app_validator.dart
//
// A reusable validator class that keeps ALL validation logic
// in ONE place — completely separate from the UI.
//
// Each method follows Flutter's validator signature:
//   String? validate(String? value)
// returning null when valid, or an error message when invalid.
// ============================================================

class AppValidator {
  // Private constructor — no need to instantiate this class
  AppValidator._();

  // ----------------------------------------------------------
  // Full Name
  // ----------------------------------------------------------
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null; // ✅ valid
  }

  // ----------------------------------------------------------
  // Email
  // ----------------------------------------------------------
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    // Simple but effective email regex
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // ----------------------------------------------------------
  // Password  (registration — strict rules)
  // Rules: min 6 chars, 1 uppercase, 1 special character
  // ----------------------------------------------------------
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least 1 uppercase letter';
    }
    if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least 1 special character';
    }
    return null;
  }

  // ----------------------------------------------------------
  // Confirm Password
  // ----------------------------------------------------------
  static String? validateConfirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'Please re-type your password';
    }
    if (value != original) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ----------------------------------------------------------
  // Login password — just checks it's not empty
  // (No strength rules on login; the server/stored hash decides)
  // ----------------------------------------------------------
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  // ----------------------------------------------------------
  // Gender dropdown
  // ----------------------------------------------------------
  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your gender';
    }
    return null;
  }
}
