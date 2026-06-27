// ============================================================
// local/course_local_data_source.dart
//
// Persists the course list locally using SharedPreferences.
// Stores all courses as a JSON array string under one key.
// Used by CourseRepository to enable offline support.
// ============================================================

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';

class CourseLocalDataSource {
  static const String _cacheKey = 'courses_cache';
  static const String _cacheTimestampKey = 'courses_cache_timestamp';

  // ----------------------------------------------------------
  // Save the full course list to local storage
  // ----------------------------------------------------------
  Future<void> saveCourses(List<Course> courses) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(courses.map((c) => c.toJson()).toList());
    await prefs.setString(_cacheKey, encoded);
    await prefs.setInt(
      _cacheTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // ----------------------------------------------------------
  // Load the cached course list from local storage.
  // Returns an empty list if no cache exists.
  // ----------------------------------------------------------
  Future<List<Course>> loadCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ----------------------------------------------------------
  // Returns true if there is any cached data
  // ----------------------------------------------------------
  Future<bool> hasCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_cacheKey);
  }

  // ----------------------------------------------------------
  // Returns when the data was last cached (null if never)
  // ----------------------------------------------------------
  Future<DateTime?> lastCachedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getInt(_cacheTimestampKey);
    if (ts == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ts);
  }

  // ----------------------------------------------------------
  // Clear the cache
  // ----------------------------------------------------------
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheTimestampKey);
  }
}
