
import 'package:flutter/material.dart';

class GiftOpeningScreen extends StatefulWidget {
  final String recipientName;
  final VoidCallback onOpen;

  const GiftOpeningScreen({
    super.key,
    required this.recipientName,
    required this.onOpen,
  });

  @override
  State<GiftOpeningScreen> createState() => _GiftOpeningScreenState();
}

class _GiftOpeningScreenState extends State<GiftOpeningScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _floatController;
  late AnimationController _glowController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.65,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.elasticOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
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
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF160D2B),
              Color(0xFF38204F),
              Color(0xFF702B65),
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
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '✨  A LITTLE SURPRISE  ✨',
                            style: TextStyle(
                              color: Color(0xFFFFD98A),
                              fontSize: 12,
                              letterSpacing: 3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 35),
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: AnimatedBuilder(
                              animation: _floatController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(
                                    0,
                                    -10 * _floatController.value,
                                  ),
                                  child: child,
                                );
                              },
                              child: const Text(
                                '🎁',
                                style: TextStyle(fontSize: 125),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Hey, ${widget.recipientName}!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Someone special has prepared\n'
                            'something wonderful for you.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 17,
                              height: 1.7,
                            ),
                          ),
                          const SizedBox(height: 48),
                          AnimatedBuilder(
                            animation: _glowController,
                            builder: (context, child) {
                              final glow =
                                  12 + (_glowController.value * 14);

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF72B6)
                                          .withValues(alpha: 0.35),
                                      blurRadius: glow,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: child,
                              );
                            },
                            child: ElevatedButton(
                              onPressed: widget.onOpen,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFFF72B6),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 38,
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Open Your Surprise',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward_rounded),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          const Text(
                            'Made especially for you ❤️',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
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

  Widget _buildBackgroundDecorations() {
    return const Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: 90,
              left: 35,
              child: _Star(size: 18),
            ),
            Positioned(
              top: 180,
              right: 45,
              child: _Star(size: 12),
            ),
            Positioned(
              bottom: 170,
              left: 55,
              child: _Star(size: 14),
            ),
            Positioned(
              bottom: 100,
              right: 35,
              child: _Star(size: 20),
            ),
            Positioned(
              top: 320,
              left: 15,
              child: _Star(size: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _Star extends StatelessWidget {
  final double size;

  const _Star({required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.auto_awesome,
      color: const Color(0xFFFFD98A).withValues(alpha: 0.7),
      size: size,
    );
  }
}
