import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_text_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Create account')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Text(
              'Let’s get started',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a demo profile to explore Taskly.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 28),
            AppTextField(
              label: 'Full name',
              hint: 'Your name',
              controller: name,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 18),
            AppTextField(
              label: 'Email address',
              hint: 'you@example.com',
              controller: email,
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 18),
            AppTextField(
              label: 'Password',
              hint: 'At least 6 characters',
              controller: password,
              icon: Icons.lock_outline,
              obscure: true,
            ),
            const SizedBox(height: 24),
            Obx(
              () => AppButton(
                label: 'Create account',
                loading: controller.isLoading.value,
                onPressed: () =>
                    controller.demoSignup(name.text, email.text, password.text),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
