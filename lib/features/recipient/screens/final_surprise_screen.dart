
import 'package:flutter/material.dart';

import '../../../models/birthday_config.dart';

class FinalSurpriseScreen extends StatefulWidget {
  final BirthdayConfig birthday;
  final VoidCallback onFinish;

  const FinalSurpriseScreen({
    super.key,
    required this.birthday,
    required this.onFinish,
  });

  @override
  State<FinalSurpriseScreen> createState() =>
      _FinalSurpriseScreenState();
}

class _FinalSurpriseScreenState extends State<FinalSurpriseScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _heartController;
  late final AnimationController _sparkleController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _heartScaleAnimation;

  bool _messageRevealed = false;

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

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeIn,
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

    _heartScaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.12,
    ).animate(
      CurvedAnimation(
        parent: _heartController,
        curve: Curves.easeInOut,
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _heartController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  void _revealMessage() {
    if (_messageRevealed) return;

    setState(() {
      _messageRevealed = true;
    });
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
              _backgroundColor.withValues(alpha: 0.9),
              _primaryColor.withValues(alpha: 0.35),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            _buildBackgroundDecorations(),

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

                          _buildHeart(),

                          const SizedBox(height: 35),

                          const Text(
                            'One Last Thing...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 31,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Text(
                            'This little experience was created '
                            'to make your day a little more special, '
                            '$name.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.8,
                            ),
                          ),

                          const SizedBox(height: 30),

                          _buildMessageCard(),

                          const SizedBox(height: 30),

                          if (_messageRevealed)
                            _buildFinishButton()
                          else
                            _buildRevealButton(),

                          const SizedBox(height: 25),

                          const Text(
                            'Keep smiling. You deserve all the happiness ❤️',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              height: 1.6,
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
          'MADE WITH LOVE',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
            letterSpacing: 3,
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

  Widget _buildHeart() {
    return ScaleTransition(
      scale: _heartScaleAnimation,
      child: Container(
        height: 155,
        width: 155,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _primaryColor.withValues(alpha: 0.12),
          border: Border.all(
            color: _primaryColor.withValues(alpha: 0.4),
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
        child: Center(
          child: Icon(
            Icons.favorite_rounded,
            color: _primaryColor,
            size: 85,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageCard() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _primaryColor.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          children: [
            Icon(
              _messageRevealed
                  ? Icons.card_giftcard_rounded
                  : Icons.lock_rounded,
              color: _primaryColor,
              size: 30,
            ),

            const SizedBox(height: 15),

            Text(
              _messageRevealed
                  ? 'A Wish Just For You'
                  : 'A Little Message',
              style: TextStyle(
                color: _primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _messageRevealed
                    ? 'May this new year of your life bring '
                        'you new adventures, genuine happiness, '
                        'beautiful friendships and countless '
                        'reasons to smile. Never stop being '
                        'your wonderful self!'
                    : 'There is one final birthday wish waiting '
                        'for you. Tap the button below to reveal it.',
                key: ValueKey(_messageRevealed),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevealButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _revealMessage,
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
              'Reveal Your Final Message',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.auto_awesome),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onFinish,
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
              'Finish This Experience',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.favorite_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
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
                  child: _FinalStar(
                    color: _primaryColor,
                    size: 20,
                  ),
                ),
                Positioned(
                  top: 190,
                  right: 35,
                  child: _FinalStar(
                    color: Colors.white70,
                    size: 15,
                  ),
                ),
                Positioned(
                  bottom: 170,
                  left: 30,
                  child: _FinalStar(
                    color: _primaryColor,
                    size: 17,
                  ),
                ),
                Positioned(
                  bottom: 100 + (12 * _sparkleController.value),
                  right: 35,
                  child: _FinalStar(
                    color: Colors.white70,
                    size: 21,
                  ),
                ),
                Positioned(
                  top: 350,
                  right: 15,
                  child: _FinalStar(
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

class _FinalStar extends StatelessWidget {
  final Color color;
  final double size;

  const _FinalStar({
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
