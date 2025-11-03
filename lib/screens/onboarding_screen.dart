import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shamba_agrovets/theme/app_colors.dart';
import 'login_screen.dart';
import '../utils/page_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  int _currentIndex = 0;
  Timer? _autoSlideTimer;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/onboarding/1.png',
      'title': 'Fast & Effortless',
      'subtitle':
          'Manage your agrovets operations quickly and easily — save time, stay productive, and focus on growth instead of paperwork.',
    },
    {
      'image': 'assets/onboarding/2.png',
      'title': 'Connected & Reliable',
      'subtitle':
          'From suppliers to customers, keep every part of your agribusiness connected. Track deliveries, manage inventory, and stay in control anytime, anywhere.',
    },
    {
      'image': 'assets/onboarding/3.png',
      'title': 'Grow With Confidence',
      'subtitle':
          'Monitor sales, analyze performance, and make data-driven decisions that keep your agribusiness moving forward — stress-free.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients && mounted) {
        int nextPage = (_currentIndex + 1) % _pages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _completeOnboarding() async {
    await _storage.write(key: 'onboarding', value: 'true');
    if (!mounted) return;
    Navigator.pushReplacement(context, PageRouter(const LoginScreen()));
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTapDown: (_) => _autoSlideTimer?.cancel(),
                onTapUp: (_) => _startAutoSlide(),
                onPanDown: (_) => _autoSlideTimer?.cancel(),
                onPanEnd: (_) => _startAutoSlide(),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentIndex = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(  
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(page['image']!, width: 300),
                          const SizedBox(height: 32),
                          Text(
                            page['title']!,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                            ),
                            child: Text(
                              page['subtitle']!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // --- Indicator + Button ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppColors.primary
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentIndex == _pages.length - 1
                            ? 'FINISH'
                            : 'CONTINUE',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
