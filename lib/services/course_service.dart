// ============================================================
// services/course_service.dart
//
// Service layer for all Course API operations.
// Uses JSONPlaceholder: https://jsonplaceholder.typicode.com
// Endpoint: /posts (mapped as "courses")
//
// All UI logic is kept out of this file — it only handles
// HTTP communication, JSON parsing, and error propagation.
// ============================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseService {
  // Base URL for JSONPlaceholder API
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  // Shared http.Client — can be overridden in tests
  final http.Client _client;
  CourseService({http.Client? client}) : _client = client ?? http.Client();

  // ----------------------------------------------------------
  // READ — GET /posts
  // Returns the first 20 posts (courses) to keep the list
  // manageable; JSONPlaceholder has 100 posts total.
  // ----------------------------------------------------------
  Future<List<Course>> fetchCourses() async {
    final uri = Uri.parse('$_baseUrl/posts?_limit=20');

    final response = await _client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load courses (HTTP ${response.statusCode})',
      );
    }
  }

  // ----------------------------------------------------------
  // READ — GET /posts/:id
  // ----------------------------------------------------------
  Future<Course> fetchCourse(int id) async {
    final uri = Uri.parse('$_baseUrl/posts/$id');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      return Course.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to load course $id (HTTP ${response.statusCode})',
      );
    }
  }

  // ----------------------------------------------------------
  // CREATE — POST /posts
  // JSONPlaceholder echoes back the new resource with id = 101.
  // ----------------------------------------------------------
  Future<Course> createCourse({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    final uri = Uri.parse('$_baseUrl/posts');

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'body': body,
        'userId': userId,
      }),
    );

    // JSONPlaceholder returns 201 Created for POST
    if (response.statusCode == 201) {
      return Course.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to create course (HTTP ${response.statusCode})',
      );
    }
  }

  // ----------------------------------------------------------
  // UPDATE — PUT /posts/:id
  // Sends the full updated resource.
  // ----------------------------------------------------------
  Future<Course> updateCourse(Course course) async {
    final uri = Uri.parse('$_baseUrl/posts/${course.id}');

    final response = await _client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': course.id,
        'title': course.title,
        'body': course.body,
        'userId': course.userId,
      }),
    );

    if (response.statusCode == 200) {
      return Course.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to update course ${course.id} (HTTP ${response.statusCode})',
      );
    }
  }

  // ----------------------------------------------------------
  // DELETE — DELETE /posts/:id
  // JSONPlaceholder returns 200 with an empty body {} on success.
  // ----------------------------------------------------------
  Future<void> deleteCourse(int id) async {
    final uri = Uri.parse('$_baseUrl/posts/$id');
    final response = await _client.delete(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete course $id (HTTP ${response.statusCode})',
      );
    }
  }
}
