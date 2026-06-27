// ============================================================
// providers/course_provider.dart
//
// State management layer using Provider (ChangeNotifier).
//
// States:
//   CourseStatus.initial   — not yet loaded
//   CourseStatus.loading   — fetching from API or cache
//   CourseStatus.success   — data available
//   CourseStatus.error     — failed with no cached fallback
//   CourseStatus.empty     — loaded successfully but no courses
//
// Optimistic UI:
//   Deletes and edits are applied to the UI immediately.
//   If the API call fails the change is rolled back.
//
// Architecture:
//   CourseListScreen / CourseFormScreen
//       -> CourseProvider (this file)
//       -> CourseRepository
//       -> CourseService (HTTP) + CourseLocalDataSource (cache)
// ============================================================

import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

enum CourseStatus { initial, loading, success, error, empty }

class CourseProvider extends ChangeNotifier {
  final CourseRepository _repository;

  // ── State ─────────────────────────────────────────────────
  CourseStatus _status = CourseStatus.initial;
  String? _errorMessage;
  bool _isOffline = false;
  DateTime? _cachedAt;
  String _searchQuery = '';

  // ── Base data from API / cache ────────────────────────────
  List<Course> _apiCourses = [];

  // ── Local overlay for optimistic UI updates ───────────────
  // Survives refreshes so the UI stays consistent with user actions.
  final List<Course> _localAdded = [];    // courses added this session
  final Set<int> _deletedIds = {};         // IDs deleted this session
  final Map<int, Course> _editedMap = {}; // id -> edited course

  // ── Constructor ───────────────────────────────────────────
  CourseProvider({required CourseRepository repository})
      : _repository = repository;

  // ── Getters ───────────────────────────────────────────────
  CourseStatus get status => _status;
  bool get isOffline => _isOffline;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  DateTime? get cachedAt => _cachedAt;

  /// Merged, filtered list shown in the UI.
  List<Course> get courses {
    final merged = _merged;
    if (_searchQuery.isEmpty) return merged;
    final q = _searchQuery.toLowerCase();
    return merged
        .where((c) =>
            c.title.toLowerCase().contains(q) ||
            c.body.toLowerCase().contains(q))
        .toList();
  }

  /// Raw merged list (before search filtering).
  List<Course> get _merged {
    final api = _apiCourses
        .where((c) => !_deletedIds.contains(c.id))
        .map((c) => _editedMap.containsKey(c.id) ? _editedMap[c.id]! : c)
        .toList();
    final added = _localAdded
        .where((c) => !_deletedIds.contains(c.id))
        .map((c) => _editedMap.containsKey(c.id) ? _editedMap[c.id]! : c)
        .toList();
    return [...added, ...api];
  }

  // ----------------------------------------------------------
  // FETCH — loads from API (caches result); falls back offline
  // ----------------------------------------------------------
  Future<void> fetchCourses() async {
    _status = CourseStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.fetchCourses();
      _apiCourses = result.courses;
      _isOffline = result.isOffline;
      _cachedAt = result.cachedAt;

      final visible = _merged;
      _status = visible.isEmpty ? CourseStatus.empty : CourseStatus.success;
    } catch (e) {
      _status = CourseStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    notifyListeners();
  }

  // ----------------------------------------------------------
  // ADD — POST to API, then prepend to local overlay
  // Returns true on success, false on failure.
  // ----------------------------------------------------------
  Future<bool> addCourse({
    required String title,
    required String body,
  }) async {
    try {
      final created = await _repository.createCourse(
        title: title,
        body: body,
      );
      // Assign a unique negative ID so it never clashes with API IDs (1-100)
      final localId = -(_localAdded.length + 1);
      _localAdded.insert(0, created.copyWith(id: localId));
      if (_status == CourseStatus.empty) {
        _status = CourseStatus.success;
      }
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ----------------------------------------------------------
  // UPDATE — optimistic edit, rollback on API failure
  // Returns true on success, false on failure.
  // ----------------------------------------------------------
  Future<bool> updateCourse(Course updated) async {
    final oldEdit = _editedMap[updated.id];
    final localIdx = _localAdded.indexWhere((c) => c.id == updated.id);

    // Optimistic update
    if (localIdx >= 0) {
      _localAdded[localIdx] = updated;
    } else {
      _editedMap[updated.id] = updated;
    }
    notifyListeners();

    // Local-only courses (negative ID) don't need an API call
    if (updated.id < 0) return true;

    try {
      await _repository.updateCourse(updated);
      return true;
    } catch (_) {
      // Rollback
      if (localIdx >= 0) {
        _localAdded[localIdx] = updated; // revert to previous
      } else if (oldEdit != null) {
        _editedMap[updated.id] = oldEdit;
      } else {
        _editedMap.remove(updated.id);
      }
      notifyListeners();
      return false;
    }
  }

  // ----------------------------------------------------------
  // DELETE — optimistic removal, rollback on API failure
  // Returns true on success, false on failure.
  // ----------------------------------------------------------
  Future<bool> deleteCourse(Course course) async {
    // Optimistic: remove from UI immediately
    _deletedIds.add(course.id);
    _localAdded.removeWhere((c) => c.id == course.id);
    final hadEdit = _editedMap.remove(course.id);

    final all = _merged;
    if (all.isEmpty) _status = CourseStatus.empty;
    notifyListeners();

    // Local-only courses don't need an API call
    if (course.id < 0) return true;

    try {
      await _repository.deleteCourse(course.id);
      return true;
    } catch (_) {
      // Rollback
      _deletedIds.remove(course.id);
      if (hadEdit != null) _editedMap[course.id] = hadEdit;
      if (_status == CourseStatus.empty) _status = CourseStatus.success;
      notifyListeners();
      return false;
    }
  }

  // ----------------------------------------------------------
  // SEARCH
  // ----------------------------------------------------------
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}
