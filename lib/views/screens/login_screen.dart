import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_text_field.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final email = TextEditingController();
  final password = TextEditingController();
  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9E6FF),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.checklist_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Welcome back 👋',
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to keep your day organized.',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 32),
              AppTextField(
                label: 'Email address',
                hint: 'you@example.com',
                controller: email,
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              AppTextField(
                label: 'Password',
                hint: 'Enter password',
                controller: password,
                icon: Icons.lock_outline,
                obscure: true,
              ),
              const SizedBox(height: 25),
              Obx(
                () => AppButton(
                  label: 'Sign in',
                  loading: controller.isLoading.value,
                  onPressed: () =>
                      controller.demoLogin(email.text, password.text),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: AppColors.muted, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => SignupScreen()),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'DEMO MODE · No real account required',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.muted,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
