// ============================================================
// main.dart — App entry point
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'local/course_local_data_source.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/registration_screen.dart';
import 'services/course_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CourseProvider>(
          create: (_) => CourseProvider(
            repository: CourseRepository(
              service: CourseService(),
              local: CourseLocalDataSource(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Student App',
        debugShowCheckedModeBanner: false,
        locale: const Locale('en', 'US'),
        supportedLocales: const [Locale('en', 'US')],
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        home: const RegistrationScreen(),
      ),
    );
  }
}
