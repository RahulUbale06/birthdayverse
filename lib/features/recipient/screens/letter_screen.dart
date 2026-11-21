
import 'package:flutter/material.dart';

import '../../../models/birthday_config.dart';

class LetterScreen extends StatefulWidget {
  final BirthdayConfig birthday;
  final VoidCallback onContinue;

  const LetterScreen({
    super.key,
    required this.birthday,
    required this.onContinue,
  });

  @override
  State<LetterScreen> createState() => _LetterScreenState();
}

class _LetterScreenState extends State<LetterScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _letterController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _letterScaleAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLetterOpened = false;

  Color get _primaryColor {
    switch (widget.birthday.themeId) {
      case 'lavender_sky':
        return const Color(0xFFB69CFF);
      case 'golden_glow':
        return const Color(0xFFFFC857);
      case 'pink_dream':
      default:
        return const Color(0xFFFF72B6);
    }
  }

  Color get _backgroundColor {
    switch (widget.birthday.themeId) {
      case 'lavender_sky':
        return const Color(0xFF211A3D);
      case 'golden_glow':
        return const Color(0xFF30200F);
      case 'pink_dream':
      default:
        return const Color(0xFF2B102B);
    }
  }

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _letterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeIn,
    );

    _letterScaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _letterController,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _letterController.dispose();
    super.dispose();
  }

  void _openLetter() {
    if (_isLetterOpened) return;

    setState(() {
      _isLetterOpened = true;
    });

    _letterController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _backgroundColor,
              _backgroundColor.withValues(alpha: 0.9),
              _primaryColor.withValues(alpha: 0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                child: Column(
                  children: [
                    _buildHeader(),

                    const SizedBox(height: 35),

                    if (!_isLetterOpened)
                      _buildSealedEnvelope()
                    else
                      _buildOpenedLetter(),

                    const SizedBox(height: 35),

                    if (_isLetterOpened)
                      _buildContinueButton()
                    else
                      _buildHint(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.favorite,
          color: _primaryColor,
          size: 25,
        ),
        const SizedBox(height: 15),
        const Text(
          'WORDS FROM THE HEART',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'A Letter For You',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Some feelings are best expressed in words.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSealedEnvelope() {
    return GestureDetector(
      onTap: _openLetter,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 230,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE6C7),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _primaryColor,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withValues(alpha: 0.25),
                  blurRadius: 30,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: _EnvelopeFlapClipper(),
                    child: Container(
                      height: 125,
                      color: const Color(0xFFE9B98B),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      height: 62,
                      width: 62,
                      decoration: BoxDecoration(
                        color: _primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'For Someone Special',
                      style: TextStyle(
                        color: Color(0xFF593A35),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          Text(
            'You have received a personal letter!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenedLetter() {
    final letter = widget.birthday.birthdayLetter.trim();

    return ScaleTransition(
      scale: _letterScaleAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5E8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _primaryColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withValues(alpha: 0.2),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.favorite,
                color: _primaryColor,
                size: 32,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Dear,',
              style: TextStyle(
                color: Color(0xFF704C45),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              letter.isEmpty
                  ? 'On your special day, I just want to wish you '
                      'happiness, success, and countless beautiful moments. '
                      'Keep smiling and keep being wonderful!'
                  : letter,
              style: const TextStyle(
                color: Color(0xFF593A35),
                fontSize: 16,
                height: 1.9,
              ),
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                'With lots of love ❤️',
                style: TextStyle(
                  color: Color(0xFF9B526E),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHint() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.touch_app_rounded,
          color: _primaryColor,
          size: 20,
        ),
        const SizedBox(width: 10),
        const Text(
          'Tap the envelope to open your letter',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: const Color(0xFF24152B),
          padding: const EdgeInsets.symmetric(vertical: 17),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'One More Surprise Awaits',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded),
          ],
        ),
      ),
    );
  }
}

class _EnvelopeFlapClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
