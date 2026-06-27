# Flutter Multi-Screen App
Student Name : Zara Tanvir - SE221035 (8B)

---

## Assignment 3 — Offline Support & State Management

### Branch
`feature/offline-cache-and-state-manangement`

### Packages Used

| Package | Version | Purpose |
|---|---|---|
| `provider` | ^6.1.2 | State management (ChangeNotifier) |
| `shared_preferences` | ^2.2.2 | Local cache / offline storage |
| `http` | ^1.2.0 | REST API calls |

### Architecture

```
UI Screens
    │
    ▼
CourseProvider  (ChangeNotifier — manages loading/success/error/empty states)
    │
    ▼
CourseRepository  (decides: API or local cache?)
    │
    ├──▶  CourseService          (HTTP only — GET/POST/PUT/DELETE)
    └──▶  CourseLocalDataSource  (SharedPreferences — save/load JSON)
```

### Offline Support Approach

On every `fetchCourses()` call the repository first attempts the live API. If the call succeeds, the result is written to `SharedPreferences` as a JSON string (cache). If the API call throws any exception (no network, timeout, DNS failure), the repository silently falls back to the cached JSON. The UI shows an orange offline banner with a "last cached" timestamp whenever data is served from cache.

### State Management Approach

`CourseProvider` (extends `ChangeNotifier`) owns all course state:

- **`CourseStatus`** enum: `initial → loading → success | error | empty`
- **Loading state** — spinner shown while fetching
- **Success state** — course list rendered via `Consumer<CourseProvider>`
- **Error state** — error message + Retry button
- **Empty state** — prompt to add first course
- **Optimistic updates** — deletes and edits are applied instantly to the in-memory list; the API call runs in the background; failure triggers automatic rollback + SnackBar

No `setState` is used for data logic in `CourseListScreen` — only `Consumer<CourseProvider>` and `context.read<CourseProvider>()`.

### New Features (Assignment 3)

- Offline cache with timestamp banner
- Search / filter bar (title + description)
- Pull-to-refresh
- Proper empty-state UI
- Optimistic deletes with rollback on failure
- Clean architecture: UI → Provider → Repository → Service + LocalDataSource

---

## Assignment 2 — REST API & CRUD Integration

### Branch
`feature/course-api-integration`

### API Used
**JSONPlaceholder** — `https://jsonplaceholder.typicode.com`

A free, open fake REST API for testing and prototyping. No authentication required.

### Documentation Followed
Official guide: https://jsonplaceholder.typicode.com/guide

The `/posts` endpoint is used as the **Courses** resource:

| Field | Maps to |
|---|---|
| `id` | Course ID |
| `userId` | Instructor / category ID |
| `title` | Course title |
| `body` | Course description |

### CRUD Operations Implemented

| Operation | HTTP Method | Endpoint | Screen |
|---|---|---|---|
| Fetch all courses | GET | `/posts?_limit=20` | CourseListScreen |
| Add new course | POST | `/posts` | CourseFormScreen (Add mode) |
| Update course | PUT | `/posts/:id` | CourseFormScreen (Edit mode) |
| Delete course | DELETE | `/posts/:id` | CourseListScreen (with confirmation) |

### Architecture
- `lib/services/course_service.dart` — all HTTP logic isolated in a service layer
- `lib/models/course.dart` — data model with `fromJson` / `toJson`
- `lib/screens/courses/course_list_screen.dart` — list, delete, navigate
- `lib/screens/courses/course_form_screen.dart` — dual-purpose add/edit form

### State Handling
Each API call goes through three explicit states managed via `setState`:
- **Loading** — `CircularProgressIndicator` shown
- **Success** — data rendered / success `SnackBar`
- **Error** — error message with Retry button / error `SnackBar`

---

# Screenshots (Assignment 1)

<p align="center">
  <img src="https://github.com/user-attachments/assets/9ed95cf8-9085-47c4-b6e1-adee99719c6e" width="250"/>

  <img src="https://github.com/user-attachments/assets/5e084765-d070-4af4-9118-9fbbe78eb545" width="250"/>

  <img src="https://github.com/user-attachments/assets/a6d4206a-4134-4bba-b554-9efb8ac48f32" width="250"/>

  <img src="https://github.com/user-attachments/assets/164d487d-0d72-4c91-aca8-01b34b789269" width="250"/>

  <img src="https://github.com/user-attachments/assets/ab720324-9ecd-4582-9086-c8f06e6d1ff2" width="250"/>

  <img src="https://github.com/user-attachments/assets/cfe1583b-f5f2-4ffb-b24f-f202050990ea" width="250"/>

  <img src="https://github.com/user-attachments/assets/4f0dfa90-2595-4d16-be58-e131d2be84f1" width="250"/>

  <img src="https://github.com/user-attachments/assets/d954b66c-ca62-4ccb-b51d-167df1b45edb" width="250"/>
</p>
## Project Structure

```
lib/
├── main.dart                        ← App entry point & theme
├── models/
│   ├── gender.dart                  ← Gender enum
│   ├── subject.dart                 ← Subject model + data
│   ├── user.dart                    ← UserModel
│   └── course.dart                  ← Course model (Assignment 2)
├── services/
│   └── course_service.dart          ← REST API service layer (Assignment 2)
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
    ├── detail_screen.dart           ← Screen 4
    └── courses/
        ├── course_list_screen.dart  ← Course list with CRUD (Assignment 2)
        └── course_form_screen.dart  ← Add / Edit form (Assignment 2)
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
       ↓  (tap subject)        ↓  (tap "View All Courses")
  Detail Screen            CourseListScreen  ←──────────────┐
       ↓  (back button)         ↓  (FAB / Edit button)      │
 Dashboard Screen          CourseFormScreen ────────────────┘
       ↓  (logout)
  Login Screen
```

---

## Assignment Requirements Checklist

### Assignment 1 — Authentication & Navigation

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

### Assignment 2 — REST API & CRUD

| Requirement | File | Status |
|---|---|---|
| Fetch course list (GET) with loading indicator | course_list_screen.dart | ✅ |
| Display title, ID, and description | course_list_screen.dart | ✅ |
| Error state with Retry button | course_list_screen.dart | ✅ |
| Add new course (POST) | course_form_screen.dart | ✅ |
| Update UI after successful POST | course_list_screen.dart | ✅ |
| Edit course (PUT) with pre-filled form | course_form_screen.dart | ✅ |
| Delete course (DELETE) with confirmation dialog | course_list_screen.dart | ✅ |
| Remove item from UI after deletion | course_list_screen.dart | ✅ |
| Separate service layer for API calls | course_service.dart | ✅ |
| Loading / success / error state handling | course_list_screen.dart | ✅ |

---

## Key Concepts Used (for your understanding)

- **StatefulWidget vs StatelessWidget** — Screens that change (forms) use StatefulWidget; read-only screens use StatelessWidget
- **GlobalKey<FormState>** — Validates all form fields at once with `_formKey.currentState!.validate()`
- **TextEditingController** — Reads the text from each field
- **Navigator.pushReplacement / pushAndRemoveUntil** — Controls navigation history
- **Enum** — Gender values are defined as an enum for type safety
- **Separation of concerns** — UI, logic, and validation are in separate files
