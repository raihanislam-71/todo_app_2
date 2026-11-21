import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
class EmptyTodo extends StatelessWidget {
  final String title;
  final String subtitle;
  const EmptyTodo({super.key, this.title = 'Nothing here yet',
    this.subtitle = 'Add a task and make today count.'});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(32),
    child: Column(children: [Container(padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: const Color(0xFFEDEBFF),
        borderRadius: BorderRadius.circular(25)),
      child: const Icon(Icons.task_alt_rounded, color: AppColors.primary, size: 44)),
      const SizedBox(height: 15), Text(title, style: const TextStyle(fontSize: 17,
        fontWeight: FontWeight.w700)), const SizedBox(height: 6),
      Text(subtitle, textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.muted)),
    ]));
}
