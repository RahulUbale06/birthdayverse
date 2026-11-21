
import 'package:flutter/material.dart';

import '../../../models/birthday_config.dart';

class BirthdayCakeScreen extends StatefulWidget {
  final BirthdayConfig birthday;
  final VoidCallback onContinue;

  const BirthdayCakeScreen({
    super.key,
    required this.birthday,
    required this.onContinue,
  });

  @override
  State<BirthdayCakeScreen> createState() =>
      _BirthdayCakeScreenState();
}

class _BirthdayCakeScreenState extends State<BirthdayCakeScreen>
    with TickerProviderStateMixin {
  static const int _candleCount = 5;

  late final AnimationController _entranceController;
  late final AnimationController _flameController;
  late final AnimationController _celebrationController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _cakeScaleAnimation;

  final List<bool> _candleLit = List<bool>.filled(_candleCount, true);

  bool _celebrationStarted = false;

  int get _remainingCandles => _candleLit.where((lit) => lit).length;

  bool get _allCandlesBlownOut => _remainingCandles == 0;

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
      duration: const Duration(milliseconds: 1100),
    );

    _flameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..repeat(reverse: true);

    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeIn,
    );

    _cakeScaleAnimation = Tween<double>(
      begin: 0.65,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.elasticOut,
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _flameController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  void _blowOutCandle(int index) {
    if (!_candleLit[index]) return;

    setState(() {
      _candleLit[index] = false;
    });

    if (_allCandlesBlownOut && !_celebrationStarted) {
      _celebrationStarted = true;
      _celebrationController.forward();
    }
  }

  void _resetCandles() {
    setState(() {
      for (var i = 0; i < _candleCount; i++) {
        _candleLit[i] = true;
      }

      _celebrationStarted = false;
    });

    _celebrationController.reset();
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
          child: Stack(
            children: [
              _buildBackgroundDecorations(),

              FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      _buildHeader(),

                      const SizedBox(height: 45),

                      _buildCake(),

                      const SizedBox(height: 40),

                      _buildInstruction(),

                      const SizedBox(height: 25),

                      _buildProgress(),

                      const SizedBox(height: 35),

                      _buildWishMessage(),

                      const SizedBox(height: 25),

                      if (_allCandlesBlownOut)
                        _buildContinueButton(),
                    ],
                  ),
                ),
              ),

              if (_allCandlesBlownOut)
                _buildCelebrationOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.auto_awesome,
          color: _primaryColor,
          size: 25,
        ),
        const SizedBox(height: 15),
        const Text(
          'MAKE A WISH',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Your Special Moment',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Close your eyes, make a wish and tap every candle.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCake() {
    return ScaleTransition(
      scale: _cakeScaleAnimation,
      child: SizedBox(
        height: 260,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 210,
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _primaryColor.withValues(alpha: 0.12),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withValues(alpha: 0.15),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),

            const Positioned(
              bottom: 12,
              child: Text(
                '🎂',
                style: TextStyle(fontSize: 190),
              ),
            ),

            Positioned(
              top: 15,
              child: SizedBox(
                width: 210,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    _candleCount,
                    (index) => _buildCandle(index),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCandle(int index) {
    final colors = [
      const Color(0xFFFF72B6),
      const Color(0xFFB69CFF),
      const Color(0xFFFFC857),
      const Color(0xFF7DE2D1),
      const Color(0xFFFF9B71),
    ];

    return GestureDetector(
      onTap: () => _blowOutCandle(index),
      child: SizedBox(
        width: 30,
        height: 95,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedBuilder(
              animation: _flameController,
              builder: (context, child) {
                final flicker =
                    1 + (_flameController.value * 0.12);

                return AnimatedOpacity(
                  opacity: _candleLit[index] ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Transform.scale(
                    scale: flicker,
                    child: child,
                  ),
                );
              },
              child: const Text(
                '🔥',
                style: TextStyle(fontSize: 23),
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 42,
              width: 13,
              decoration: BoxDecoration(
                color: _candleLit[index]
                    ? colors[index]
                    : colors[index].withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(4),
                boxShadow: _candleLit[index]
                    ? [
                        BoxShadow(
                          color: colors[index].withValues(alpha: 0.35),
                          blurRadius: 8,
                        ),
                      ]
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstruction() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        _allCandlesBlownOut
            ? 'Beautiful! Your wish is on its way ✨'
            : 'Tap the candles to blow them out!',
        key: ValueKey(_allCandlesBlownOut),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _primaryColor,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Column(
      children: [
        Text(
          '$_remainingCandles candles remaining',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 13),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: (_candleCount - _remainingCandles) / _candleCount,
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildWishMessage() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Container(
        key: ValueKey(_allCandlesBlownOut),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              _allCandlesBlownOut
                  ? Icons.stars_rounded
                  : Icons.favorite_rounded,
              color: _primaryColor,
              size: 30,
            ),
            const SizedBox(height: 12),
            Text(
              _allCandlesBlownOut
                  ? 'May all your wishes come true!'
                  : 'Take a moment to think of something wonderful.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Column(
      children: [
        SizedBox(
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
                  'Reveal Your Final Surprise',
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
        ),

        const SizedBox(height: 12),

        TextButton(
          onPressed: _resetCandles,
          child: Text(
            'Make Another Wish',
            style: TextStyle(
              color: _primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCelebrationOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _celebrationController,
          builder: (context, child) {
            return Opacity(
              opacity: 1 - (_celebrationController.value * 0.4),
              child: Stack(
                children: List.generate(18, (index) {
                  final progress = _celebrationController.value;
                  final x = (index * 47.0) % 360;
                  final startY = (index * 31.0) % 250;

                  return Positioned(
                    left: x,
                    top: startY + (progress * 300),
                    child: Transform.rotate(
                      angle: progress * 6.28 * (index.isEven ? 1 : -1),
                      child: Text(
                        index.isEven ? '✨' : '🎉',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return const Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: 100,
              left: 30,
              child: _CakeStar(size: 18),
            ),
            Positioned(
              top: 220,
              right: 25,
              child: _CakeStar(size: 14),
            ),
            Positioned(
              bottom: 150,
              left: 35,
              child: _CakeStar(size: 20),
            ),
            Positioned(
              bottom: 90,
              right: 40,
              child: _CakeStar(size: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class _CakeStar extends StatelessWidget {
  final double size;

  const _CakeStar({
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.auto_awesome,
      color: Colors.white.withValues(alpha: 0.35),
      size: size,
    );
  }
}
