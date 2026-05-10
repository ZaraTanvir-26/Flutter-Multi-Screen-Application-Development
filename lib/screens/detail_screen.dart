// ============================================================
// screens/detail_screen.dart
//
// Screen 4 — Subject Detail
// Shows: subject name, banner, description, schedule
// ============================================================

import 'package:flutter/material.dart';
import '../models/subject.dart';

class DetailScreen extends StatelessWidget {
  // The subject data is passed in from the Dashboard
  final Subject subject;

  const DetailScreen({super.key, required this.subject});

  // Parse the hex color string into a Flutter Color
  Color get _bannerColor {
    final hex = subject.bannerColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // AppBar with back button (automatically added by Flutter)
      appBar: AppBar(
        title: const Text('Subject Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Banner image placeholder ─────────────────────
            // In a real app this would be an Image.network or Image.asset
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: _bannerColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, color: Colors.white, size: 60),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      subject.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Subject header ───────────────────────────
                  Text(
                    subject.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Description card ─────────────────────────
                  _InfoCard(
                    icon: Icons.description_outlined,
                    title: 'About This Course',
                    content: subject.description,
                    color: _bannerColor,
                  ),
                  const SizedBox(height: 14),

                  // ── Schedule card ────────────────────────────
                  _InfoCard(
                    icon: Icons.schedule,
                    title: 'Schedule',
                    content: subject.schedule,
                    color: _bannerColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// Reusable info card shown on the Detail screen
// ------------------------------------------------------------------
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header (icon + title)
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: color,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          // Card content
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
