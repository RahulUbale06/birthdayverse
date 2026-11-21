
import 'package:flutter/material.dart';

import 'models/birthday_config.dart';
import 'services/recipient_config_loader.dart';
import 'features/recipient/screens/recipient_experience_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RecipientApp());
}

class RecipientApp extends StatelessWidget {
  const RecipientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BirthdayVerse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEC72A5),
        ),
      ),
      home: const RecipientHomeScreen(),
    );
  }
}

class RecipientHomeScreen extends StatefulWidget {
  const RecipientHomeScreen({super.key});

  @override
  State<RecipientHomeScreen> createState() =>
      _RecipientHomeScreenState();
}

class _RecipientHomeScreenState extends State<RecipientHomeScreen> {
  late final Future<BirthdayConfig> _birthdayFuture;

  @override
  void initState() {
    super.initState();
    _birthdayFuture = RecipientConfigLoader.load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BirthdayConfig>(
      future: _birthdayFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to load your birthday surprise.\n\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return RecipientExperienceScreen(
          birthday: snapshot.data!,
        );
      },
    );
  }
}
