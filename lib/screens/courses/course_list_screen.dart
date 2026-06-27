// ============================================================
// screens/courses/course_list_screen.dart
//
// Consumes CourseProvider via Consumer<CourseProvider>.
// No setState — all state lives in the Provider.
//
// Features:
//   - Loading / success / error / empty states
//   - Offline banner with last-cached timestamp
//   - Search bar (filters by title or description)
//   - Pull-to-refresh
//   - Optimistic delete with undo snackbar on failure
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../providers/course_provider.dart';
import 'course_form_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load courses when screen opens (only if not already loaded)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CourseProvider>();
      if (provider.status == CourseStatus.initial) {
        provider.fetchCourses();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // Delete with optimistic UI + rollback SnackBar
  // ----------------------------------------------------------
  Future<void> _deleteCourse(BuildContext context, Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text('Delete "${course.title}"?'),
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

    if (confirmed != true || !context.mounted) return;

    final ok = await context.read<CourseProvider>().deleteCourse(course);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Course deleted.' : 'Delete failed — changes reverted.',
        ),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  // ----------------------------------------------------------
  // Navigate to Add form
  // ----------------------------------------------------------
  void _navigateToAdd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CourseFormScreen()),
    );
  }

  // ----------------------------------------------------------
  // Navigate to Edit form
  // ----------------------------------------------------------
  void _navigateToEdit(BuildContext context, Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CourseFormScreen(course: course)),
    );
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
          Consumer<CourseProvider>(
            builder: (_, provider, __) => IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh from API',
              onPressed: provider.status == CourseStatus.loading
                  ? null
                  : () => provider.fetchCourses(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAdd(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Course'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Offline banner
          Consumer<CourseProvider>(
            builder: (_, provider, __) {
              if (!provider.isOffline) return const SizedBox.shrink();
              final ts = provider.cachedAt;
              final timeStr = ts == null
                  ? ''
                  : ' (cached ${_formatTime(ts)})';
              return Container(
                width: double.infinity,
                color: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You are offline — showing cached data$timeStr',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Consumer<CourseProvider>(
                  builder: (_, provider, __) =>
                      provider.searchQuery.isEmpty
                          ? const SizedBox.shrink()
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                provider.clearSearch();
                              },
                            ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.grey.shade200),
                ),
              ),
              onChanged: (val) =>
                  context.read<CourseProvider>().setSearchQuery(val),
            ),
          ),

          // Main content
          Expanded(
            child: Consumer<CourseProvider>(
              builder: (context, provider, _) {
                return _buildContent(context, provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // Content switcher based on CourseStatus
  // ----------------------------------------------------------
  Widget _buildContent(BuildContext context, CourseProvider provider) {
    switch (provider.status) {
      case CourseStatus.initial:
      case CourseStatus.loading:
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

      case CourseStatus.error:
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
                  provider.errorMessage ?? 'Unknown error',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => provider.fetchCourses(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        );

      case CourseStatus.empty:
        if (provider.searchQuery.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.search_off, size: 56, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  'No courses match "${provider.searchQuery}"',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.library_books_outlined,
                  size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('No courses yet.'),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _navigateToAdd(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Course'),
              ),
            ],
          ),
        );

      case CourseStatus.success:
        final courses = provider.courses;
        if (courses.isEmpty && provider.searchQuery.isNotEmpty) {
          return Center(
            child: Text(
              'No courses match "${provider.searchQuery}"',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => provider.fetchCourses(),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return _CourseCard(
                course: course,
                onEdit: () => _navigateToEdit(context, course),
                onDelete: () => _deleteCourse(context, course),
              );
            },
          ),
        );
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
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
                          isLocal ? 'NEW' : 'ID ' + course.id.toString(),
                          style: TextStyle(
                            color: isLocal
                                ? Colors.green.shade700
                                : _accentColor,
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
