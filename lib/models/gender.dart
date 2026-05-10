// ============================================================
// models/gender.dart
// Enum for gender selection (as required by assignment)
// ============================================================

enum Gender {
  male,
  female,
  preferNotToSay;

  // Returns a readable label for each enum value
  String get label {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.preferNotToSay:
        return 'Prefer not to say';
    }
  }
}
