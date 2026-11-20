
import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String icon;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              size: 55,
              color: Color(0xFFEC82AA),
            ),
            const SizedBox(height: 15),
            Text(
              '$title Coming Soon!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
