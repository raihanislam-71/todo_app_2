import 'package:get/get.dart';

import '../views/screens/home_screen.dart';
import '../views/widgets/common/custom_snackbar.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final userEmail = ''.obs;

  // Demo-only: no authentication endpoint is provided by the Todo fake API.
  Future<void> demoLogin(String email, String password) async {
    if (!GetUtils.isEmail(email.trim())) {
      AppSnackbar.showError(
        'Invalid email',
        'Please enter a valid email address.',
      );
      return;
    }
    if (password.trim().length < 6) {
      AppSnackbar.showError(
        'Invalid password',
        'Password must be at least 6 characters.',
      );
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 450));
    isLoading.value = false;
    userEmail.value = email.trim();
    AppSnackbar.showSuccess('Success', 'Logged in successfully!');
    Get.offAll(() => const HomeScreen());
  }

  Future<void> demoSignup(String name, String email, String password) async {
    if (name.trim().isEmpty ||
        !GetUtils.isEmail(email.trim()) ||
        password.length < 6) {
      AppSnackbar.showError(
        'Check your details',
        'Enter name, valid email and 6+ character password.',
      );
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 450));
    isLoading.value = false;
    userEmail.value = email.trim();
    AppSnackbar.showSuccess(
      'Account Created',
      'Account created successfully.',
    );
    Get.offAll(() => const HomeScreen());
  }
}
