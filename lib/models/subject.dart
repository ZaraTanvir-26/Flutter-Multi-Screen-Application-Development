// ============================================================
// models/subject.dart
// Data model for a university subject/course
// ============================================================

class Subject {
  final String name;
  final String description;
  final String schedule;
  final String bannerColor; // hex color string used as placeholder banner

  const Subject({
    required this.name,
    required this.description,
    required this.schedule,
    required this.bannerColor,
  });
}

// ----------------------------------------------------------------
// Static list of subjects shown on the Dashboard
// (These are the exact subjects from the assignment brief)
// ----------------------------------------------------------------
const List<Subject> appSubjects = [
  Subject(
    name: 'Mobile App Development',
    description:
        'Learn to build cross-platform mobile applications using Flutter '
        'and Dart. Topics include widgets, state management, navigation, '
        'REST APIs, and publishing to app stores.',
    schedule: 'Mon & Wed  |  10:00 AM – 11:30 AM  |  Room 301',
    bannerColor: '#1565C0',
  ),
  Subject(
    name: 'Software Re-engineering',
    description:
        'Covers techniques for analyzing, restructuring, and modernising '
        'legacy software systems. Topics include reverse engineering, '
        'refactoring, migration strategies, and software quality metrics.',
    schedule: 'Tue & Thu  |  12:00 PM – 1:30 PM  |  Room 204',
    bannerColor: '#00695C',
  ),
  Subject(
    name: 'MIS',
    description:
        'Management Information Systems explores how organisations use '
        'information technology to achieve business goals. Topics include '
        'database management, ERP systems, decision support, and IT governance.',
    schedule: 'Fri  |  9:00 AM – 12:00 PM  |  Room 105',
    bannerColor: '#6A1B9A',
  ),
];
