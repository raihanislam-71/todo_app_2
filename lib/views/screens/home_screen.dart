import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/todo_controller.dart';
import '../widgets/todo/todo_card.dart';
import '../widgets/todo/todo_filter.dart';
import '../widgets/todo/todo_form.dart';
import '../widgets/todo/empty_todo.dart';
import '../widgets/common/loading_widget.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  TodoController get controller => Get.find<TodoController>();
  AuthController get authController => Get.find<AuthController>();

  void showAddTask() => Get.bottomSheet(
    TodoForm(onSave: controller.addTodo),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    floatingActionButton: FloatingActionButton.extended(
      onPressed: showAddTask,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: const Text('New task'),
    ),
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.loadTodos,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildWelcomeCard(),
            const SizedBox(height: 20),
            _buildStats(),
            const SizedBox(height: 26),
            _buildListHeader(),
            const SizedBox(height: 12),
            _buildFilters(),
            const SizedBox(height: 14),
            _buildTodoList(),
          ],
        ),
      ),
    ),
  );

  Widget _buildHeader() => Row(
    children: [
      Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: const Color(0xFFE9E6FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.checklist_rounded, color: AppColors.primary),
      ),
      const SizedBox(width: 10),
      const Text(
        'Taskly',
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w900,
          color: AppColors.text,
        ),
      ),
      const Spacer(),
      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.notifications_none_rounded,
          color: AppColors.text,
        ),
      ),
      const SizedBox(width: 12),
      GestureDetector(
        onTap: _showProfileMenu,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.person_outline,
            color: AppColors.text,
          ),
        ),
      ),
    ],
  );

  Widget _buildWelcomeCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF6558E8), Color(0xFF8C7CF7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'YOUR DAILY SPACE',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Make today\ncount. ✨',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            height: 1.15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Text(
            '${controller.pendingCount} tasks left to focus on',
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        const SizedBox(height: 18),
        Obx(
          () => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 7,
              backgroundColor: Colors.white30,
              color: Colors.white,
              value: controller.todos.isEmpty
                  ? 0
                  : controller.completedCount / controller.todos.length,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildStats() => Obx(
    () => Row(
      children: [
        Expanded(
          child: _statCard(
            'Total tasks',
            controller.todos.length.toString(),
            Icons.grid_view_rounded,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            'Completed',
            controller.completedCount.toString(),
            Icons.check_circle_outline,
            AppColors.green,
          ),
        ),
      ],
    ),
  );

  Widget _statCard(String label, String count, IconData icon, Color color) =>
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(
              count,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ],
        ),
      );

  Widget _buildListHeader() => Row(
    children: [
      const Text(
        'My tasks',
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
      ),
      const Spacer(),
      Obx(
        () => Text(
          '${controller.filteredTodos.length} items',
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
      ),
    ],
  );

  Widget _buildFilters() => Obx(
    () => TodoFilter(
      selected: controller.selectedFilter.value,
      onChanged: controller.changeFilter,
    ),
  );

  Widget _buildTodoList() => Obx(() {
    if (controller.isLoading.value) {
      return const SizedBox(height: 180, child: LoadingWidget());
    }

    if (controller.errorMessage.value.isNotEmpty && controller.todos.isEmpty) {
      return _errorState();
    }

    if (controller.filteredTodos.isEmpty) {
      return const EmptyTodo();
    }

    return Column(
      children: controller.filteredTodos
          .map(
            (todo) => TodoCard(
              todo: todo,
              onToggle: () => controller.toggleTodo(todo),
              onDelete: () => controller.removeTodo(todo),
            ),
          )
          .toList(),
    );
  });

  Widget _errorState() => Padding(
    padding: const EdgeInsets.all(22),
    child: Column(
      children: [
        const Icon(Icons.cloud_off_rounded, size: 38, color: AppColors.muted),
        const SizedBox(height: 8),
        const Text('Could not load tasks'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: controller.loadTodos,
          child: const Text('Try again'),
        ),
      ],
    ),
  );

  void _showProfileMenu() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE9E6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text('User Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              authController.userEmail.value.isNotEmpty
                  ? authController.userEmail.value
                  : 'taskly@demo.com',
              style: TextStyle(fontSize: 14, color: AppColors.muted),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.text),
              title: const Text('Settings'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Get.back(),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text('Logout', style: TextStyle(color: AppColors.error)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.error),
              onTap: () {
                Get.back();
                _showLogoutDialog();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No', style: TextStyle(color: AppColors.muted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Get.back();
              authController.userEmail.value = '';
              Get.offAll(() => LoginScreen());
            },
            child: const Text('Yes', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
