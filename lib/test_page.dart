import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fraze_pocket/models/affirmation.dart';

import 'package:fraze_pocket/provider/affirmation_provider.dart';
import 'package:fraze_pocket/styles/app_theme.dart';

class AffirmationsPage extends StatefulWidget {
  const AffirmationsPage({super.key});

  @override
  State<AffirmationsPage> createState() => _AffirmationsPageState();
}

class _AffirmationsPageState extends State<AffirmationsPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildDots(int currentPage, int total) {
    List<Widget> dots = [];
    for (int i = 0; i < total; i++) {
      dots.add(Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: currentPage == i ? 12.0 : 8.0,
        height: currentPage == i ? 12.0 : 8.0,
        decoration: BoxDecoration(
          color: currentPage == i ? AppTheme.onBackground : AppTheme.surface,
          shape: BoxShape.circle,
        ),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }

  Widget _buildPage(Affirmation affirmation) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: AssetImage(affirmation.imagePath),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '«${affirmation.text}»',
              style: AppTheme.displayMedium.copyWith(color: affirmation.color),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final affirmationProvider = Provider.of<AffirmationProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: affirmationProvider.affirmations.isEmpty
              ? const Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoActivityIndicator(
                      radius: 20,
                      color: CupertinoColors.white,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Your affirmations is loading...',
                      style: TextStyle(
                        fontSize: 18,
                        color: CupertinoColors.white,
                      ),
                    )
                  ],
                ))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ... your existing code for the profile and notifications icons
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text(
                        "Read",
                        style: AppTheme.bodyLarge.copyWith(
                          color: const Color.fromARGB(78, 252, 248, 239),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "DAILY RANDOM\nAFFIRMATIONS",
                        style: AppTheme.displayLarge.copyWith(
                          color: AppTheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // PageView
                      SizedBox(
                        height: 350.0,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: affirmationProvider.affirmations.length,
                          onPageChanged: (int page) {
                            affirmationProvider.setCurrentPage(page);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return _buildPage(
                                affirmationProvider.affirmations[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      _buildDots(
                        affirmationProvider.currentPage,
                        affirmationProvider.affirmations.length,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
