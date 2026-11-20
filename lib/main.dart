
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: BirthdayVerseApp(),
    ),
  );
}

class BirthdayVerseApp extends StatelessWidget {
  const BirthdayVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BirthdayVerse',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor:
            const Color(0xFFFFF9FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEC82AA),
          brightness: Brightness.light,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
