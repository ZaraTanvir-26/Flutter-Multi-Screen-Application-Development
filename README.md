# Flutter Multi-Screen App — Assignment Guide

## Project Structure

```
lib/
├── main.dart                        ← App entry point & theme
├── models/
│   ├── gender.dart                  ← Gender enum
│   ├── subject.dart                 ← Subject model + data
│   └── user.dart                    ← UserModel
├── controllers/
│   └── auth_controller.dart         ← All business logic (register/login/logout)
├── validators/
│   └── app_validator.dart           ← All form validation rules
├── widgets/
│   └── custom_text_field.dart       ← Reusable input field widget
└── screens/
    ├── registration_screen.dart     ← Screen 1
    ├── login_screen.dart            ← Screen 2
    ├── dashboard_screen.dart        ← Screen 3
    └── detail_screen.dart           ← Screen 4
```

---

## How to Run

1. Make sure Flutter is installed: https://flutter.dev/docs/get-started/install
2. Open a terminal in the project folder
3. Run:

```bash
flutter pub get          # installs dependencies
flutter run              # launches the app
```

---

## App Flow

```
Registration Screen
       ↓  (on success)
  Login Screen
       ↓  (on success)
 Dashboard Screen
       ↓  (tap subject)
  Detail Screen
       ↓  (back button)
 Dashboard Screen
       ↓  (logout)
  Login Screen
```

---

## Assignment Requirements Checklist

| Requirement | File | Status |
|---|---|---|
| Registration form (name, email, gender, password) | registration_screen.dart | ✅ |
| Email validation | app_validator.dart | ✅ |
| Password rules (6 chars, uppercase, special char) | app_validator.dart | ✅ |
| Confirm password matching | app_validator.dart | ✅ |
| Gender dropdown (enum-based) | gender.dart | ✅ |
| Login with email + password | login_screen.dart | ✅ |
| Password show/hide toggle | login_screen.dart | ✅ |
| Remember Me checkbox | login_screen.dart | ✅ |
| Dashboard with user name + avatar | dashboard_screen.dart | ✅ |
| Subject list (MAD, SRE, MIS) | subject.dart | ✅ |
| Tap gesture → Detail screen | dashboard_screen.dart | ✅ |
| Detail screen (header, banner, desc, schedule) | detail_screen.dart | ✅ |
| Logout → back to Login | dashboard_screen.dart | ✅ |
| Custom Validator class | app_validator.dart | ✅ |
| Enum implementation | gender.dart | ✅ |
| Controller layer (separate from UI) | auth_controller.dart | ✅ |

---

## Key Concepts Used (for your understanding)

- **StatefulWidget vs StatelessWidget** — Screens that change (forms) use StatefulWidget; read-only screens use StatelessWidget
- **GlobalKey<FormState>** — Validates all form fields at once with `_formKey.currentState!.validate()`
- **TextEditingController** — Reads the text from each field
- **Navigator.pushReplacement / pushAndRemoveUntil** — Controls navigation history
- **Enum** — Gender values are defined as an enum for type safety
- **Separation of concerns** — UI, logic, and validation are in separate files
