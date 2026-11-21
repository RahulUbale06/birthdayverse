
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../models/birthday_config.dart';

import 'gift_opening_screen.dart';
import 'birthday_reveal_screen.dart';
import 'memory_lane_screen.dart';
import 'letter_screen.dart';
import 'birthday_cake_screen.dart';
import 'final_surprise_screen.dart';

class RecipientExperienceScreen extends StatefulWidget {
  final BirthdayConfig birthday;

  const RecipientExperienceScreen({
    super.key,
    required this.birthday,
  });

  @override
  State<RecipientExperienceScreen> createState() =>
      _RecipientExperienceScreenState();
}

class _RecipientExperienceScreenState
    extends State<RecipientExperienceScreen> {
  int _currentStage = 0;

  final AudioPlayer _musicPlayer = AudioPlayer();

  bool _musicStarted = false;

  // Start music after the recipient opens the gift.
  Future<void> _startMusic() async {
    final musicPath = widget.birthday.musicPath;

    if (musicPath == null ||
        musicPath.isEmpty ||
        _musicStarted) {
      return;
    }

    try {
      // AssetSource expects a path relative to the assets directory.
      final assetPath = musicPath.startsWith('assets/')
          ? musicPath.substring('assets/'.length)
          : musicPath;

      await _musicPlayer.setReleaseMode(ReleaseMode.loop);

      await _musicPlayer.play(
        AssetSource(assetPath),
      );

      _musicStarted = true;
    } catch (error) {
      debugPrint('Birthday music error: $error');
    }
  }

  void _handleGiftOpen() {
    _startMusic();
    _nextStage();
  }

  void _nextStage() {
    if (_currentStage < 6) {
      setState(() {
        _currentStage++;
      });
    }
  }

  void _restartExperience() {
    setState(() {
      _currentStage = 0;
    });
  }

  Color _getThemeColor() {
    switch (widget.birthday.themeId) {
      case 'lavender_sky':
        return const Color(0xFF9B8CEB);

      case 'golden_glow':
        return const Color(0xFFE5A93D);

      case 'pink_dream':
      default:
        return const Color(0xFFEC72A5);
    }
  }

  Widget _buildCurrentScreen() {
    final birthday = widget.birthday;

    switch (_currentStage) {
      case 0:
        return GiftOpeningScreen(
          recipientName: birthday.nickname.isNotEmpty
              ? birthday.nickname
              : birthday.recipientName,
          onOpen: _handleGiftOpen,
        );

      case 1:
        return BirthdayRevealScreen(
          birthday: birthday,
          onContinue: _nextStage,
        );

      case 2:
        return MemoryLaneScreen(
          birthday: birthday,
          onContinue: _nextStage,
        );

      case 3:
        return LetterScreen(
          birthday: birthday,
          onContinue: _nextStage,
        );

      case 4:
        return BirthdayCakeScreen(
          birthday: birthday,
          onContinue: _nextStage,
        );

      case 5:
        return FinalSurpriseScreen(
          birthday: birthday,
          onFinish: _nextStage,
        );

      case 6:
        return _buildCompletionScreen();

      default:
        return _buildCompletionScreen();
    }
  }

  Widget _buildCompletionScreen() {
    final themeColor = _getThemeColor();

    final recipientName = widget.birthday.nickname.isNotEmpty
        ? widget.birthday.nickname
        : widget.birthday.recipientName;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeColor.withValues(alpha: 0.85),
              const Color(0xFF241B35),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '💖',
                  style: TextStyle(fontSize: 90),
                ),
                const SizedBox(height: 28),
                const Text(
                  'The End...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'But the memories stay forever, $recipientName!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Thank you for being wonderful. '
                  'May your life always be filled with happiness, '
                  'love and beautiful surprises.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 45),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _restartExperience,
                    icon: const Icon(Icons.replay),
                    label: const Text('Experience Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: themeColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 17,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _musicPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStage == 0,
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey<int>(_currentStage),
            child: _buildCurrentScreen(),
          ),
        ),
      ),
    );
  }
}
