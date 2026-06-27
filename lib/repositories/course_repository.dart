// ============================================================
// repositories/course_repository.dart
//
// Repository layer — sits between the Provider and the data sources.
// Decision logic:
//   fetchCourses -> try API first, cache on success;
//                   on failure load from local cache (offline mode)
//   createCourse / updateCourse / deleteCourse -> always hit API
//     (JSONPlaceholder is fake, so no local persistence needed
//      for write operations — the Provider handles the UI overlay)
// ============================================================

import '../models/course.dart';
import '../services/course_service.dart';
import '../local/course_local_data_source.dart';

/// The result of a fetch operation, including whether it came from cache.
class FetchResult {
  final List<Course> courses;
  final bool isOffline;
  final DateTime? cachedAt;

  const FetchResult({
    required this.courses,
    required this.isOffline,
    this.cachedAt,
  });
}

class CourseRepository {
  final CourseService _service;
  final CourseLocalDataSource _local;

  CourseRepository({
    required CourseService service,
    required CourseLocalDataSource local,
  })  : _service = service,
        _local = local;

  // ----------------------------------------------------------
  // READ — try live API, fall back to local cache
  // ----------------------------------------------------------
  Future<FetchResult> fetchCourses() async {
    try {
      final courses = await _service.fetchCourses();
      // Persist fresh data for offline use
      await _local.saveCourses(courses);
      return FetchResult(courses: courses, isOffline: false);
    } catch (_) {
      // Network unreachable — load cached data
      final cached = await _local.loadCourses();
      final ts = await _local.lastCachedAt();
      return FetchResult(
        courses: cached,
        isOffline: true,
        cachedAt: ts,
      );
    }
  }

  // ----------------------------------------------------------
  // CREATE — POST to API
  // ----------------------------------------------------------
  Future<Course> createCourse({
    required String title,
    required String body,
    int userId = 1,
  }) {
    return _service.createCourse(title: title, body: body, userId: userId);
  }

  // ----------------------------------------------------------
  // UPDATE — PUT to API
  // ----------------------------------------------------------
  Future<Course> updateCourse(Course course) {
    return _service.updateCourse(course);
  }

  // ----------------------------------------------------------
  // DELETE — DELETE to API
  // ----------------------------------------------------------
  Future<void> deleteCourse(int id) {
    return _service.deleteCourse(id);
  }
}
