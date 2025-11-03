import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shamba_agrovets/screens/login_screen.dart';
import 'package:shamba_agrovets/screens/layout_screen.dart';
import 'package:shamba_agrovets/screens/onboarding_screen.dart';
import 'package:shamba_agrovets/utils/page_router.dart';
import 'package:shamba_agrovets/utils/api_client.dart';
import 'package:shamba_agrovets/theme/app_colors.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.delayed(const Duration(seconds: 1)); 

    try {
      // Get onboarding flag 
      final onboardingFlag = await _storage.read(key: 'onboarding') ?? 'false';
      final isOnboarded = onboardingFlag.toLowerCase() == 'true';

      if (!isOnboarded) {
        // User hasn’t completed onboarding
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageRouter(const OnboardingScreen()),
        );
        return;
      }

      // Check token 
      final token = await ApiClient.getToken();

      if (token != null && token.isNotEmpty) {
        // Logged in 
        if (!mounted) return;
        Navigator.pushReplacement(context, PageRouter(const LayoutScreen()));
      } else {
        // Not logged in → go to login screen
        if (!mounted) return;
        Navigator.pushReplacement(context, PageRouter(const LoginScreen()));
      }
    } catch (e) {
      // Fallback: go to login
      if (!mounted) return;
      Navigator.pushReplacement(context, PageRouter(const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: Image.asset('assets/logo/logo.png', width: 200)),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Text(
                'Powered by Shamba Records',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withAlpha(180),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
