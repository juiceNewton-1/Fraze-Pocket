import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:fraze_pocket/main_view/main_page.dart';
import 'package:fraze_pocket/mood_graphic_view/mood_graphic_page.dart';
import 'package:fraze_pocket/styles/app_theme.dart';
import 'package:fraze_pocket/test_page.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const MainPage(),
    const AffirmationsPage(),
    const MoodGraphicPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          Positioned(
            bottom: 40.0,
            left: 95.0,
            right: 95.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 70,
                      decoration: const BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _NavBarItem(
                            icon: Icons.home_filled,
                            isActive: _currentIndex == 0,
                            onTap: () => _onItemTapped(0),
                          ),
                          _NavBarItem(
                            icon: Icons.card_giftcard,
                            isActive: _currentIndex == 1,
                            onTap: () => _onItemTapped(1),
                          ),
                          _NavBarItem(
                            icon: Icons.monitor_heart_outlined,
                            isActive: _currentIndex == 2,
                            onTap: () => _onItemTapped(2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Gaimon.selection();
        onTap.call();
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 20,
          ),
          Icon(
            icon,
            color: isActive
                ? AppTheme.onSurface
                : const Color.fromARGB(123, 243, 239, 230),
            size: 28,
          ),
          const Spacer(),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              height: 4,
              width: 30,
              decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(20)),
            ),
        ],
      ),
    );
  }
}
