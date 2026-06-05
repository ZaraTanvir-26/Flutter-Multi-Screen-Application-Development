// ============================================================
// screens/courses/course_form_screen.dart
//
// Dual-purpose form screen:
//   • course == null  → Add mode  (POST /posts)
//   • course != null  → Edit mode (PUT  /posts/:id)
//
// Pre-fills existing data in edit mode.
// Returns the saved Course object to the caller on success.
// ============================================================

import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../services/course_service.dart';

class CourseFormScreen extends StatefulWidget {
  /// Pass a course to edit it; leave null to create a new one.
  final Course? course;

  const CourseFormScreen({super.key, this.course});

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final CourseService _service = CourseService();

  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  bool _isSaving = false;

  // Convenience flag
  bool get _isEditMode => widget.course != null;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields in edit mode
    _titleController = TextEditingController(
      text: widget.course?.title ?? '',
    );
    _bodyController = TextEditingController(
      text: widget.course?.body ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // Save — POST (add) or PUT (update)
  // ----------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      Course result;

      if (_isEditMode) {
        // UPDATE existing course
        final updated = widget.course!.copyWith(
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
        );
        result = await _service.updateCourse(updated);
      } else {
        // CREATE new course
        result = await _service.createCourse(
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode
                ? 'Course updated successfully!'
                : 'Course added successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Return the saved course to the list screen
      Navigator.pop(context, result);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString().replaceFirst("Exception: ", "")}',
          ),
          backgroundColor: Colors.red,
        ),
      );
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
        title: Text(_isEditMode ? 'Edit Course' : 'Add Course'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Info card ─────────────────────────────────
              if (_isEditMode)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.indigo.shade100),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Colors.indigo, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        'Editing Course ID: ${widget.course!.id}',
                        style: const TextStyle(
                            color: Colors.indigo, fontSize: 13),
                      ),
                    ],
                  ),
                ),

              // ── Title field ───────────────────────────────
              const Text(
                'Course Title',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'e.g. Introduction to Flutter',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  if (value.trim().length < 3) {
                    return 'Title must be at least 3 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ── Description field ─────────────────────────
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bodyController,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Enter a brief course description…',
                  filled: true,
                  fillColor: Colors.white,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  if (value.trim().length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // ── Save button ───────────────────────────────
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _isEditMode ? 'Update Course' : 'Add Course',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
