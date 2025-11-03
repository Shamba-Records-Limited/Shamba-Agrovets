import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shamba_agrovets/screens/layout_screen.dart';
import 'package:shamba_agrovets/theme/app_colors.dart';
import 'package:shamba_agrovets/utils/page_router.dart';
import '../../state/authentication_provider.dart';
import '../../widgets/forms/app_text_field.dart'; 

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    try {
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        Fluttertoast.showToast(
          msg: "Login successful. Welcome back!",
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pushReplacement(context, PageRouter(const LayoutScreen()));
      } else {
        Fluttertoast.showToast(
          msg: "Invalid email or password",
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Login failed. Please try again.",
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- EMAIL FIELD ---
            AppTextField(
              label: 'Email',
              hint: 'agrovets@shambarecords.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email.';
                }
                if (!value.contains('@')) return 'Enter a valid email.';
                return null;
              },
            ),

            const SizedBox(height: 20),

            // --- PASSWORD FIELD ---
            AppTextField(
              label: 'Password',
              hint: '********',
              controller: _passwordController,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password.';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters.';
                }
                return null;
              },
            ),

            const SizedBox(height: 8),

            // --- FORGOT PASSWORD ---
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: "Forgot Password feature coming soon!",
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- LOGIN BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: authProvider.isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: authProvider.isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
