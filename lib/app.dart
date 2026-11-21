import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config/app_theme.dart';
import 'views/screens/login_screen.dart';
import 'controllers/todo_controller.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});
  @override
  Widget build(BuildContext context) => GetMaterialApp(
    title: 'Taskly Todo',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    initialBinding: BindingsBuilder(() {
      Get.put(TodoController(), permanent: true);
    }),
    home: LoginScreen(),
  );
}
