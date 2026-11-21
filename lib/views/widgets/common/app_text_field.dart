import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData? icon;
  final bool obscure;
  final TextInputType keyboardType;
  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 9),
      TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: icon == null ? null : Icon(icon, size: 20),
        ),
      ),
    ],
  );
}
