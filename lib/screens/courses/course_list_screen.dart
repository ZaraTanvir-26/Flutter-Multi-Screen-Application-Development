// ============================================================
// screens/courses/course_list_screen.dart
//
// Displays courses from JSONPlaceholder /posts.
// IMPORTANT: JSONPlaceholder is a fake API — it accepts POST/PUT/DELETE
// requests and returns valid responses, but does NOT actually save data.
// To keep the UI consistent, this screen maintains a local overlay:
//   _localAdded   — courses the user added this session
//   _deletedIds   — IDs the user deleted this session
//   _editedMap    — courses the user edited this session (id -> Course)
// These are merged with the API response on every refresh.
// ============================================================

import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../services/course_service.dart';
import 'course_form_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CourseService _service = CourseService();

  // ── API data ──────────────────────────────────────────────
  List<Course> _apiCourses = [];
  bool _isLoading = false;
  String? _errorMessage;

  // ── Local overlay (survives refreshes) ───────────────────
  final List<Course> _localAdded = [];
  final Set<int> _deletedIds = {};
  final Map<int, Course> _editedMap = {};

  // ── Merged view (what the list actually shows) ────────────
  List<Course> get _visibleCourses {
    // Start with API courses, apply edits, remove deleted
    final api = _apiCourses
        .where((c) => !_deletedIds.contains(c.id))
        .map((c) => _editedMap.containsKey(c.id) ? _editedMap[c.id]! : c)
        .toList();
    // Prepend locally-added (also filtering if somehow deleted)
    final added = _localAdded
        .where((c) => !_deletedIds.contains(c.id))
        .map((c) => _editedMap.containsKey(c.id) ? _editedMap[c.id]! : c)
        .toList();
    return [...added, ...api];
  }

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  // ----------------------------------------------------------
  // Fetch from API — only updates _apiCourses
  // Local overlay is preserved.
  // ----------------------------------------------------------
  Future<void> _loadCourses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final courses = await _service.fetchCourses();
      if (!mounted) return;
      setState(() {
        _apiCourses = courses;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  // ----------------------------------------------------------
  // Delete — removes from overlay + calls API
  // ----------------------------------------------------------
  Future<void> _deleteCourse(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text(
          'Are you sure you want to delete "${course.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Optimistic: add to deleted set immediately
    setState(() {
      _deletedIds.add(course.id);
      _localAdded.removeWhere((c) => c.id == course.id);
    });

    try {
      await _service.deleteCourse(course.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Revert on error
      if (!mounted) return;
      setState(() => _deletedIds.remove(course.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceFirst("Exception: ", "")}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ----------------------------------------------------------
  // Navigate to Add form
  // ----------------------------------------------------------
  Future<void> _navigateToAdd() async {
    final newCourse = await Navigator.push<Course>(
      context,
      MaterialPageRoute(builder: (_) => const CourseFormScreen()),
    );

    if (newCourse != null) {
      setState(() {
        // Give locally-added courses a unique negative ID to avoid
        // clashing with real API IDs (1-100)
        final localId = -(_localAdded.length + 1);
        _localAdded.insert(0, newCourse.copyWith(id: localId));
      });
    }
  }

  // ----------------------------------------------------------
  // Navigate to Edit form
  // ----------------------------------------------------------
  Future<void> _navigateToEdit(Course course) async {
    final updated = await Navigator.push<Course>(
      context,
      MaterialPageRoute(builder: (_) => CourseFormScreen(course: course)),
    );

    if (updated != null) {
      setState(() {
        if (course.id < 0) {
          // Locally-added course — update in-place
          final idx = _localAdded.indexWhere((c) => c.id == course.id);
          if (idx >= 0) _localAdded[idx] = updated.copyWith(id: course.id);
        } else {
          // API course — store in edit overlay
          _editedMap[updated.id] = updated;
        }
      });
    }
  }

  // ----------------------------------------------------------
  // Build
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh from API',
            onPressed: _isLoading ? null : _loadCourses,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAdd,
        icon: const Icon(Icons.add),
        label: const Text('Add Course'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // ── Loading (only when list is empty) ─────────────────────
    if (_isLoading && _apiCourses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading courses...'),
          ],
        ),
      );
    }

    // ── Error state ───────────────────────────────────────────
    if (_errorMessage != null && _apiCourses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text('Could not load courses',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadCourses,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final courses = _visibleCourses;

    if (courses.isEmpty) {
      return const Center(child: Text('No courses found.'));
    }

    return RefreshIndicator(
      onRefresh: _loadCourses,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return _CourseCard(
            course: course,
            onEdit: () => _navigateToEdit(course),
            onDelete: () => _deleteCourse(course),
          );
        },
      ),
    );
  }
}

// ================================================================
// _CourseCard
// ================================================================
class _CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CourseCard({
    required this.course,
    required this.onEdit,
    required this.onDelete,
  });

  Color get _accentColor {
    const colors = [
      Color(0xFF1565C0),
      Color(0xFF00695C),
      Color(0xFF6A1B9A),
      Color(0xFFE65100),
      Color(0xFF2E7D32),
      Color(0xFFC62828),
      Color(0xFF283593),
      Color(0xFF4E342E),
    ];
    return colors[course.userId.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final isLocal = course.id < 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colored left accent bar
          Container(
            width: 6,
            decoration: BoxDecoration(
              color: _accentColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isLocal
                              ? Colors.green.shade50
                              : _accentColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isLocal ? 'NEW' : 'ID ${course.id}',
                          style: TextStyle(
                            color:
                                isLocal ? Colors.green.shade700 : _accentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          course.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.body,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                        ),
                      ),
                      const SizedBox(width: 4),
                      TextButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text('Delete'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
