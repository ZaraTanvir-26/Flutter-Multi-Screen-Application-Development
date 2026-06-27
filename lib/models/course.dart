// ============================================================
// models/course.dart
//
// Maps to JSONPlaceholder /posts endpoint:
//   id       -> course id
//   userId   -> instructor/category id
//   title    -> course title
//   body     -> course description
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

  // ── Full JSON (includes id) — used for local storage ─────
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
      };

  // ── API payload for POST (no id) ─────────────────────────
  Map<String, dynamic> toApiJson() => {
        'userId': userId,
        'title': title,
        'body': body,
      };

  // ── CopyWith ──────────────────────────────────────────────
  Course copyWith({int? id, int? userId, String? title, String? body}) {
    return Course(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Course && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
