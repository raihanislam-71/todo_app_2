import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

class TodoFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const TodoFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });
  static const options = ['All', 'Pending', 'Completed'];

  @override
  Widget build(BuildContext context) => Row(
    children: options.map((item) {
      final active = selected == item;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(item),
          selected: active,
          onSelected: (_) => onChanged(item),
          selectedColor: AppColors.primary,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: active ? Colors.white : AppColors.muted,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      );
    }).toList(),
  );
}
