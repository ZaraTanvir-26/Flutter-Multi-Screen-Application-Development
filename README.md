# Flutter Multi-Screen App

**Student Name:** Zara Tanvir  
**Roll No:** SE221035 (8B)

---

# 📱 Screenshots

<table>
<tr>
<th>Registration Screen</th>
<th>Login Screen</th>
<th>Dashboard</th>
</tr>

<tr>
<td><img src="https://github.com/user-attachments/assets/9ed95cf8-9085-47c4-b6e1-adee99719c6e" width="250"/></td>

<td><img src="https://github.com/user-attachments/assets/164d487d-0d72-4c91-aca8-01b34b789269" width="250"/></td>
<td><img src="https://github.com/user-attachments/assets/ab720324-9ecd-4582-9086-c8f06e6d1ff2" width="250"/></td>
</tr>
</table>

---

<table>
<tr>
<th>Course Details</th>
<th>Add Course</th>
<th>Edit Course</th>
</tr>

<tr>
<td><img src="https://github.com/user-attachments/assets/4f0dfa90-2595-4d16-be58-e131d2be84f1" width="250"/></td>
<td><img src="https://github.com/user-attachments/assets/aba9fe24-2115-4ecd-b22d-0fa43a4b4f46" width="420"/></td>
<td><img width="617" height="906" alt="image" src="https://github.com/user-attachments/assets/39bdee01-c571-466c-97de-b9c3b61cf4ec" /></td>

</tr>
</table>

---

<table>
<tr>
<th>Delete Course</th>
</tr>

<tr>
<td><img src="https://github.com/user-attachments/assets/93f72a01-d346-4586-92b4-941d952765db" width="420"/></td>
</tr>
</table>

---

<table>
<tr>
<th>Search / Filter</th>
</tr>

<tr>
<td><img width="628" height="903" alt="image" src="https://github.com/user-attachments/assets/991f61b9-d3b9-43cc-8348-62e0a20cc8a3" />
</td>
</tr>
</table>


---

<table>
<tr>
<th>Offline banner (Hive cache)</th>
</tr>

<tr>
<td align="center">
<img src="https://github.com/user-attachments/assets/f05d81cc-fcaf-464c-b3bf-5ce364940aaa" width="420"/>
</td>
</tr>
</table>

---

# 📂 Project Structure

```text
lib/
├── main.dart
├── models/
│   ├── gender.dart
│   ├── subject.dart
│   └── user.dart
├── controllers/
│   └── auth_controller.dart
├── validators/
│   └── app_validator.dart
├── widgets/
│   └── custom_text_field.dart
└── screens/
    ├── registration_screen.dart
    ├── login_screen.dart
    ├── dashboard_screen.dart
    └── detail_screen.dart
```

---

# 🚀 How to Run

```bash
flutter pub get
flutter run
```

---

# 🔄 App Flow

```text
Registration Screen
        │
        ▼
 Login Screen
        │
        ▼
 Dashboard
        │
        ▼
 Course Detail
        │
        ▼
 Dashboard
        │
        ▼
 Logout
        │
        ▼
 Login Screen
```

---

# Assignment Requirements Checklist

| Requirement | Status |
|-------------|:------:|
| Registration Form | done |
| Email Validation | done |
| Password Validation | done |
| Confirm Password | done |
| Gender Enum | done |
| Login Screen | done |
| Show/Hide Password | done |
| Remember Me | done|
| Dashboard | done |
| Subject List | done |
| Detail Screen | done |
| Logout | done |
| Custom Validator | done |
| MVC Structure | done |

---

# 🛠 Technologies Used

- Flutter
- Dart
- Material Design
- Stateful & Stateless Widgets
- Navigator
- TextEditingController
- GlobalKey<FormState>
- Custom Validators
- Enum
- MVC Architecture

---

# 📚 Key Concepts

- StatefulWidget & StatelessWidget
- Form Validation
- GlobalKey<FormState>
- TextEditingController
- Navigator.pushReplacement()
- Navigator.pushAndRemoveUntil()
- Enum
- Separation of Concerns (UI, Logic & Validation)

---

## 👩‍💻 Developed By

**Zara Tanvir**  
**SE221035 (8B)**
