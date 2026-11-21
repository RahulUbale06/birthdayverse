
import 'package:flutter/material.dart';
import '../../../models/birthday_config.dart';

class BirthdayRevealScreen extends StatefulWidget {
  final BirthdayConfig birthday;
  final VoidCallback onContinue;

  const BirthdayRevealScreen({
    super.key,
    required this.birthday,
    required this.onContinue,
  });

  @override
  State<BirthdayRevealScreen> createState() =>
      _BirthdayRevealScreenState();
}

class _BirthdayRevealScreenState extends State<BirthdayRevealScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _pulseController;
  late AnimationController _sparkleController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

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
      duration: const Duration(milliseconds: 1400),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.elasticOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
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
    _pulseController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.birthday.nickname.trim().isNotEmpty
        ? widget.birthday.nickname.trim()
        : widget.birthday.recipientName.trim();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _backgroundColor,
              _backgroundColor.withValues(alpha: 0.85),
              _primaryColor.withValues(alpha: 0.35),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            _buildDecorations(),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 30,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTopLabel(),

                          const SizedBox(height: 35),

                          _buildBirthdayCake(),

                          const SizedBox(height: 35),

                          Text(
                            'HAPPY BIRTHDAY',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: 15,
                              letterSpacing: 5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Container(
                            height: 3,
                            width: 75,
                            decoration: BoxDecoration(
                              color: _primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          const SizedBox(height: 25),

                          Text(
                            widget.birthday.birthdayMessage.trim().isEmpty
                                ? 'Wishing you a day filled with happiness, '
                                    'laughter and beautiful memories!'
                                : widget.birthday.birthdayMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 17,
                              height: 1.8,
                            ),
                          ),

                          const SizedBox(height: 35),

                          _buildContinueButton(),

                          const SizedBox(height: 22),

                          const Text(
                            'This day is all about you ❤️',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.auto_awesome,
          color: _primaryColor,
          size: 18,
        ),
        const SizedBox(width: 10),
        const Text(
          'TODAY IS YOUR SPECIAL DAY',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Icon(
          Icons.auto_awesome,
          color: _primaryColor,
          size: 18,
        ),
      ],
    );
  }

  Widget _buildBirthdayCake() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 0.96 + (_pulseController.value * 0.08);

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 190,
          width: 190,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _primaryColor.withValues(alpha: 0.12),
            border: Border.all(
              color: _primaryColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withValues(alpha: 0.2),
                blurRadius: 35,
                spreadRadius: 8,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '🎂',
              style: TextStyle(fontSize: 105),
            ),
          ),
        ),
      ),
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
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Explore Our Memories',
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

  Widget _buildDecorations() {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _sparkleController,
          builder: (context, child) {
            return Stack(
              children: [
                Positioned(
                  top: 100 + (15 * _sparkleController.value),
                  left: 35,
                  child: _Sparkle(
                    color: _primaryColor,
                    size: 22,
                  ),
                ),
                Positioned(
                  top: 190,
                  right: 35,
                  child: _Sparkle(
                    color: Colors.white70,
                    size: 16,
                  ),
                ),
                Positioned(
                  bottom: 170,
                  left: 25,
                  child: _Sparkle(
                    color: _primaryColor,
                    size: 18,
                  ),
                ),
                Positioned(
                  bottom: 100 + (12 * _sparkleController.value),
                  right: 40,
                  child: _Sparkle(
                    color: Colors.white70,
                    size: 23,
                  ),
                ),
                Positioned(
                  top: 350,
                  right: 15,
                  child: _Sparkle(
                    color: _primaryColor,
                    size: 12,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  final Color color;
  final double size;

  const _Sparkle({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.auto_awesome,
      color: color.withValues(alpha: 0.75),
      size: size,
    );
  }
}
