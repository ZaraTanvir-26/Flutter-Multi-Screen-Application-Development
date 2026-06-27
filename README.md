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
<td><img src="https://github.com/user-attachments/assets/5e084765-d070-4af4-9118-9fbbe78eb545" width="250"/></td>
<td><img src="https://github.com/user-attachments/assets/a6d4206a-4134-4bba-b554-9efb8ac48f32" width="250"/></td>
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
<td><img src="https://github.com/user-attachments/assets/164d487d-0d72-4c91-aca8-01b34b789269" width="250"/></td>
<td><img src="https://github.com/user-attachments/assets/ab720324-9ecd-4582-9086-c8f06e6d1ff2" width="250"/></td>
<td><img src="https://github.com/user-attachments/assets/cfe1583b-f5f2-4ffb-b24f-f202050990ea" width="250"/></td>
</tr>
</table>

---

<table>
<tr>
<th>Delete Course</th>
<th>Profile</th>
<th>Settings</th>
</tr>

<tr>
<td><img src="https://github.com/user-attachments/assets/4f0dfa90-2595-4d16-be58-e131d2be84f1" width="250"/></td>
<td><img src="https://github.com/user-attachments/assets/d954b66c-ca62-4ccb-b51d-167df1b45edb" width="250"/></td>
<td><img src="https://github.com/user-attachments/assets/403e1025-0f08-4f9c-a38f-983c0c446731" width="250"/></td>
</tr>
</table>

---

<table>
<tr>
<th>Offline Banner (Hive Cache)</th>
<th>Search / Filter</th>
</tr>

<tr>
<td><img src="https://github.com/user-attachments/assets/4abe079f-3746-471c-b7fa-83cda1784310" width="420"/></td>
<td><img src="https://github.com/user-attachments/assets/aba9fe24-2115-4ecd-b22d-0fa43a4b4f46" width="420"/></td>
</tr>
</table>

---

<table>
<tr>
<th>Dashboard (Offline Preview)</th>
<th>Courses List (CRUD + Search + Offline)</th>
</tr>

<tr>
<td><img src="https://github.com/user-attachments/assets/4c90a751-9626-493b-b24f-2b9233e7c700" width="420"/></td>
<td><img src="https://github.com/user-attachments/assets/93f72a01-d346-4586-92b4-941d952765db" width="420"/></td>
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

<table>
<tr>
<th>Search/Filter</th>
</tr>

<tr>
<td align="center">
<img src="https://github.com/user-attachments/assets/591bcefc-5b0e-4488-8a5a-9d6dc577183d" width="420"/>
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
