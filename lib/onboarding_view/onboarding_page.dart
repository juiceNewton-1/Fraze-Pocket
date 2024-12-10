import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hive/hive.dart';
import 'package:fraze_pocket/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:fraze_pocket/styles/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'WELCOME\nTO MOOD\nTRACKER!',
      'subtitle': 'Keep track of your\nemotions',
      'imagePath': 'assets/images/Rectangle 525.png',
    },
    {
      'title': 'EASY TO KEEP TRACK OF YOUR WELL-BEING',
      'subtitle': 'Record your feelings\nand states every day.',
      'imagePath': 'assets/images/Group 8.png',
    },
    {
      'title': 'READY TO GET STARTED?',
      'subtitle': '''Let's work together\nto improve wellness!''',
      'imagePath': 'assets/images/Group 9.png',
    },
  ];

  void _nextPage() async {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      var settingsBox = Hive.box('settings');
      await settingsBox.put('isOnboardingCompleted', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CustomNavigationBar(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final page = _pages[index];
          return Stack(
            children: [
              Container(
                color: AppTheme.background,
                width: double.infinity,
                height: double.infinity,
              ),
              Center(
                heightFactor: 1.2,
                child: Image.asset(
                  page['imagePath']!,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(0, 0, 0, 0),
                        Color.fromARGB(255, 0, 0, 0)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        page['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        page['subtitle']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 117, 117, 117),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: CupertinoButton(
                          color: _currentIndex == _pages.length - 1
                              ? const Color(0xFF5B5CFF)
                              : AppTheme.primary,
                          borderRadius: BorderRadius.circular(24),
                          onPressed: () {
                            _nextPage();
                            Gaimon.selection();
                          },
                          child: Text(
                            _currentIndex == _pages.length - 1
                                ? 'Get started'
                                : 'Next',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
