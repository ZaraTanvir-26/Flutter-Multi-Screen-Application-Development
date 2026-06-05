// ============================================================
// models/course.dart
//
// Represents a course fetched from the JSONPlaceholder API.
// Maps to the /posts endpoint:
//   id       → course id
//   userId   → instructor id (used as category colour seed)
//   title    → course title
//   body     → course description
// ============================================================

class Course {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Course({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  // ── JSON deserialization ──────────────────────────────────
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  // ── JSON serialization ────────────────────────────────────
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'title': title,
        'body': body,
      };

  // ── CopyWith (for local optimistic updates) ───────────────
  Course copyWith({int? id, int? userId, String? title, String? body}) {
    return Course(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}
