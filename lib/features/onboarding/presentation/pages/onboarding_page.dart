import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../memory/presentation/pages/home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final int _totalScreens = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _handleNext() async {
    if (_currentIndex < _totalScreens - 1) {
      _navigateToPage(_currentIndex + 1);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seen_onboarding', true);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          // --- Fixed Custom App Header Line ---
          Positioned(
            top: topPadding,
            left: 0,
            right: 0,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.confirmation_number,
                        color: Color(0xFF4D41DF),
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Memory Ticket',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4D41DF),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  AnimatedOpacity(
                    opacity: _currentIndex == _totalScreens - 1 ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: IgnorePointer(
                      ignoring: _currentIndex == _totalScreens - 1,
                      child: TextButton(
                        onPressed: () => _navigateToPage(_totalScreens - 1),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF464555),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Horizontal Scroll Snap Screens Layout Container ---
          Positioned.fill(
            top: topPadding + 56,
            bottom: bottomPadding + 140,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                _buildScreenOne(),
                _buildScreenTwo(),
                _buildScreenThree(),
              ],
            ),
          ),

          // --- Fixed Layout Platform Navigation Footer ---
          Positioned(
            bottom: bottomPadding + 32,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Page Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_totalScreens, (index) {
                    final bool isActive = index == _currentIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      height: 8,
                      width: isActive ? 24 : 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF4D41DF)
                            : const Color(0xFFC7C4D8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                // Footer Action Controller Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Nav Button
                    Opacity(
                      opacity: _currentIndex > 0 ? 1.0 : 0.0,
                      child: IgnorePointer(
                        ignoring: _currentIndex == 0,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE7E8EC),
                          ),
                          child: IconButton(
                            onPressed: () => _navigateToPage(_currentIndex - 1),
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Color(0xFF191C1F),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                    // Core Custom Dynamic Primary Button
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4D41DF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: const Color(
                            0xFF6C63FF,
                          ).withOpacity(0.15),
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentIndex == _totalScreens - 1
                                  ? 'Start'
                                  : 'Next',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _currentIndex == _totalScreens - 1
                                  ? Icons.celebration
                                  : Icons.arrow_forward,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Invisible structural placeholder balancing out layout alignment perfectly
                    const SizedBox(width: 48),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HTML Asset View Component 1 ---
  Widget _buildScreenOne() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(48),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Color(0xFFE3DFFF), Colors.white],
                            radius: 0.85,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuC8EIVvtBFLRXVf9r9s59wptRMPsHlhO0vWBedJewW4i4IPfgUzI9whYEJ3tM4HP6Uh5xYwpUEf-UgEVhILAMJeMWbDwhPMBWUQQaMXHMlJrMTBwwUatpMwinlCe27anoeuNeKMxdx2F6UokexDfPVw1W0FOukBImIPxLYakH0rCXnBf55u1638O_F2IxI65j-07QjxQ08zf8bWqC9Xs26HCJM1K-PIQMJ2KbD644Xm3ejl2b7VjJDN5w',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Turn your memories into beautiful tickets.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              height: 36 / 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF191C1F),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Every moment deserves a permanent place in your digital archive.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF464555),
            ),
          ),
        ],
      ),
    );
  }

  // --- HTML Asset View Component 2 (Bento Grid) ---
  Widget _buildScreenTwo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Transform.rotate(
                    angle: -2 * math.pi / 180,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3DFFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.restaurant,
                            color: Color(0xFF4D41DF),
                          ),
                          Container(
                            height: 8,
                            width: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4D41DF).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: 3 * math.pi / 180,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDDB3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.flight, color: Color(0xFF825500)),
                          Container(
                            height: 8,
                            width: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFF825500).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDK0_-csOP8prziLQAe5ypmJqwgmGYt7hDCQAchA31EybmEe6eKxHLOmtCqwZM8XwjX-623PQl0OrEzX93bsckSuPHxx2qpx2Iw4Ys9syy7Hi3FczJ4YWnLvB1eubbJvXie_TDh73GIpn3wIrygVjG4zPAMnSJuc86J1jEZxGCUpGrD10eCvgLLHkSZYjamnlAAo-DdHIeWgINLGTbLDPl9Kzh2EDHkAjydAlss5Ar7xHiQxU3LUOVcCA',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF6BFF8F),
                          ),
                          child: const Icon(
                            Icons.local_activity,
                            color: Color(0xFF006B2D),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 12,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDEEF2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 8,
                                width: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE7E8EC),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Organize moments effortlessly.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              height: 36 / 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF191C1F),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Smart categorizing keeps your timeline clean and easy to navigate.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF464555),
            ),
          ),
        ],
      ),
    );
  }

  // --- HTML Asset View Component 3 ---
  Widget _buildScreenThree() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(48),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF675DF9).withOpacity(0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(48),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBIgh2pln-Xear5r1dCf5hQ57GpGrJ80rqu278g6mchN8tQRSAbg1xVqJ8-dUD_WoK7mDKIsAZDxJBIJ1iTSPhsmKWNWB8szSXbGXlYPTEkxlOWc2yapUzHbXRrl4lUcCrRKsP4X8S-_g654uMIn-0aLVz4aVrn5y9qTRlzl0ch6UmCOh6CMtKH6qO4qs4HhQfIJM6Q2yg-U36zJHB-e5x-_uu6nYhJVctQLu16Rq4Gt7y5CwlwcDRbGA',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Relive your memories anytime.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              height: 36 / 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF191C1F),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your life\'s most precious tickets, available whenever you need a stroll down memory lane.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF464555),
            ),
          ),
        ],
      ),
    );
  }
}
