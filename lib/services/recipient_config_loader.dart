
import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/birthday_config.dart';

class RecipientConfigLoader {
  static Future<BirthdayConfig> load() async {
    try {
      // Read the JSON file bundled inside the recipient APK.
      final jsonString = await rootBundle.loadString(
        'birthday_config.json',
      );

      // Convert JSON text into a Dart map.
      final Map<String, dynamic> json =
          jsonDecode(jsonString) as Map<String, dynamic>;

      // Create the BirthdayConfig object.
      return BirthdayConfig.fromPackageJson(json);
    } catch (error) {
      throw Exception(
        'Unable to load birthday configuration: $error',
      );
    }
  }
}
