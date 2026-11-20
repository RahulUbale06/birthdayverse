
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color pink = Color(0xFFEC82AA);
  static const Color purple = Color(0xFFB9A6F6);
  static const Color dark = Color(0xFF292536);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20, 18, 20, 24,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),

              _buildGreeting(),
              const SizedBox(height: 22),

              _buildHeroCard(context),
              const SizedBox(height: 28),

              _buildSectionTitle(
                'Quick Actions',
                'What would you like to create?',
              ),
              const SizedBox(height: 16),

              _buildQuickActions(context),
              const SizedBox(height: 30),

              _buildSectionTitle(
                'Your Creations',
                'Your saved birthday surprises',
              ),
              const SizedBox(height: 16),

              _buildEmptyCreations(context),
              const SizedBox(height: 30),

              _buildSectionTitle(
                'Explore Themes',
                'Find the perfect birthday vibe',
              ),
              const SizedBox(height: 16),

              _buildThemes(context),
            ],
          ),
        ),
      ),

      bottomNavigationBar:
          _buildBottomNavigation(context),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE6EF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.cake_rounded,
            color: pink,
            size: 27,
          ),
        ),

        const SizedBox(width: 11),

        const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'BirthdayVerse',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),
            Text(
              'Make someone feel special',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        const Spacer(),

        CircleAvatar(
          backgroundColor: Color(0xFFF0E9FF),
          child: Icon(
            Icons.person_outline_rounded,
            color: Color(0xFF8E72D5),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hey, Creator! 👋',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
        SizedBox(height: 7),
        Text(
          'Ready to create something unforgettable?',
          style: TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF6B6CE),
            Color(0xFFC6B4FA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 30,
          ),

          const SizedBox(height: 17),

          const Text(
            'Every birthday\nhas a story.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Turn your beautiful memories into\n'
            'a personalized birthday surprise.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 22),

          ElevatedButton.icon(
            onPressed: () {
              context.push('/create');
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Birthday'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: pink,
              padding: const EdgeInsets.symmetric(
                horizontal: 19,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _actionCard(
            icon: Icons.add_circle_outline_rounded,
            title: 'New Birthday',
            subtitle: 'Start creating',
            color: pink,
            onTap: () => context.push('/create'),
          ),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: _actionCard(
            icon: Icons.palette_outlined,
            title: 'Browse Themes',
            subtitle: 'Find your style',
            color: purple,
            onTap: () => context.push('/themes'),
          ),
        ),
      ],
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: const Color(0xFFF0EAF0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 29),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCreations(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF0EAF0),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.auto_awesome_outlined,
            size: 37,
            color: purple,
          ),
          const SizedBox(height: 12),
          const Text(
            'Your canvas is waiting!',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your birthday creations will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: () => context.push('/creations'),
            child: const Text('View all creations'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemes(BuildContext context) {
    final themes = [
      {
        'name': 'Pink Dream',
        'color': const Color(0xFFF7B6CE),
        'icon': Icons.favorite_rounded,
      },
      {
        'name': 'Lavender Sky',
        'color': const Color(0xFFC5B5F7),
        'icon': Icons.cloud_rounded,
      },
      {
        'name': 'Golden Glow',
        'color': const Color(0xFFFFD58C),
        'icon': Icons.star_rounded,
      },
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: themes.length,
        separatorBuilder: (context, index) =>
    const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final theme = themes[index];

          return GestureDetector(
            onTap: () => context.push('/themes'),
            child: Container(
              width: 125,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme['color'] as Color,
                borderRadius: BorderRadius.circular(19),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    theme['icon'] as IconData,
                    color: Colors.white,
                    size: 25,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    theme['name'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigation(
    BuildContext context,
  ) {
    return NavigationBar(
      selectedIndex: 0,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFFFE6EF),
      onDestinationSelected: (index) {
        const routes = [
          '/',
          '/creations',
          '/themes',
          '/settings',
        ];

        if (index != 0) {
          context.push(routes[index]);
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.folder_outlined),
          label: 'Creations',
        ),
        NavigationDestination(
          icon: Icon(Icons.palette_outlined),
          label: 'Themes',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}
