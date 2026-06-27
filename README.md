# Flutter Multi-Screen App
Student Name : Zara Tanvir - SE221035 (8B)
# Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/9ed95cf8-9085-47c4-b6e1-adee99719c6e" width="250"/>

  <img src="https://github.com/user-attachments/assets/5e084765-d070-4af4-9118-9fbbe78eb545" width="250"/>

  <img src="https://github.com/user-attachments/assets/a6d4206a-4134-4bba-b554-9efb8ac48f32" width="250"/>

  <img src="https://github.com/user-attachments/assets/164d487d-0d72-4c91-aca8-01b34b789269" width="250"/>

  <img src="https://github.com/user-attachments/assets/ab720324-9ecd-4582-9086-c8f06e6d1ff2" width="250"/>

  <img src="https://github.com/user-attachments/assets/cfe1583b-f5f2-4ffb-b24f-f202050990ea" width="250"/>

  <img src="https://github.com/user-attachments/assets/4f0dfa90-2595-4d16-be58-e131d2be84f1" width="250"/>

  <img src="https://github.com/user-attachments/assets/d954b66c-ca62-4ccb-b51d-167df1b45edb" width="250"/>

  <img width="626" height="896" alt="8" src="https://github.com/user-attachments/assets/403e1025-0f08-4f9c-a38f-983c0c446731" />
  <img width="620" height="852" alt="9" src="https://github.com/user-attachments/assets/4abe079f-3746-471c-b7fa-83cda1784310" />
  <img width="617" height="891" alt="10" src="https://github.com/user-attachments/assets/aba9fe24-2115-4ecd-b22d-0fa43a4b4f46" />
<img width="627" height="900" alt="11" src="https://github.com/user-attachments/assets/4c90a751-9626-493b-b24f-2b9233e7c700" />
<img width="612" height="906" alt="12" src="https://github.com/user-attachments/assets/93f72a01-d346-4586-92b4-941d952765db" />
<img width="617" height="905" alt="image (1)" src="https://github.com/user-attachments/assets/f05d81cc-fcaf-464c-b3bf-5ce364940aaa" />

  <img width="622" height="903" alt="image (2)" src="https://github.com/user-attachments/assets/591bcefc-5b0e-4488-8a5a-9d6dc577183d" />


</p>
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
