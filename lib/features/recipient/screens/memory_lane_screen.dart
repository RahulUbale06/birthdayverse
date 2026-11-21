
import 'package:flutter/material.dart';

import '../../../models/birthday_config.dart';

class MemoryLaneScreen extends StatefulWidget {
  final BirthdayConfig birthday;
  final VoidCallback onContinue;

  const MemoryLaneScreen({
    super.key,
    required this.birthday,
    required this.onContinue,
  });

  @override
  State<MemoryLaneScreen> createState() => _MemoryLaneScreenState();
}

class _MemoryLaneScreenState extends State<MemoryLaneScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _entranceController;

  int _currentPage = 0;

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

  // Prefer packaged asset paths when available.
  // Otherwise, use the photo bytes from the creator configuration.
  int get _photoCount {
    if (widget.birthday.photos.isNotEmpty) {
      return widget.birthday.photos.length;
    }

    return widget.birthday.photoBytes.length;
  }

  bool get _hasAssetPhotos =>
      widget.birthday.photos.isNotEmpty;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _goToPhoto(int index) {
    if (index < 0 || index >= _photoCount) return;

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildPhoto(int index) {
    if (_hasAssetPhotos) {
      return Image.asset(
        widget.birthday.photos[index],
        fit: BoxFit.contain,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildImageError();
        },
      );
    }

    return Image.memory(
      widget.birthday.photoBytes[index],
      fit: BoxFit.contain,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return _buildImageError();
      },
    );
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
            opacity: CurvedAnimation(
              parent: _entranceController,
              curve: Curves.easeIn,
            ),
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _photoCount == 0
                      ? _buildEmptyState()
                      : _buildPhotoExperience(),
                ),
                _buildBottomSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                color: _primaryColor,
                size: 17,
              ),
              const SizedBox(width: 9),
              const Text(
                'A COLLECTION OF MEMORIES',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          const Text(
            'Remember When...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Every picture has a story to tell.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoExperience() {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _photoCount,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: _primaryColor.withValues(alpha: 0.6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withValues(alpha: 0.18),
                        blurRadius: 25,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: _buildPhoto(index),
                  ),
                ),
              );
            },
          ),
        ),

        _buildPhotoCounter(),

        const SizedBox(height: 18),

        _buildPageIndicators(),

        const SizedBox(height: 15),

        _buildNavigationButtons(),

        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildPhotoCounter() {
    return Text(
      'MEMORY ${_currentPage + 1} OF $_photoCount',
      style: TextStyle(
        color: _primaryColor,
        fontSize: 11,
        letterSpacing: 3,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _photoCount,
        (index) {
          final isSelected = index == _currentPage;

          return GestureDetector(
            onTap: () => _goToPhoto(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isSelected ? 25 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isSelected
                    ? _primaryColor
                    : Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _currentPage > 0
                ? () => _goToPhoto(_currentPage - 1)
                : null,
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: Colors.white,
            disabledColor: Colors.white24,
          ),
          const Text(
            'Swipe to explore',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
          IconButton(
            onPressed: _currentPage < _photoCount - 1
                ? () => _goToPhoto(_currentPage + 1)
                : null,
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            color: Colors.white,
            disabledColor: Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              color: _primaryColor,
              size: 75,
            ),
            const SizedBox(height: 22),
            const Text(
              'Memories are waiting!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No photos were added to this birthday surprise, '
              'but there are still more special moments ahead.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: Colors.white.withValues(alpha: 0.08),
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Colors.white54,
          size: 55,
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
      child: SizedBox(
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
                'There Is More For You',
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
    );
  }
}
