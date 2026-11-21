import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/todo_model.dart';
import '../common/app_button.dart';
class TodoForm extends StatefulWidget {
  final Future<bool> Function(TodoModel) onSave;
  const TodoForm({super.key, required this.onSave});
  @override
  State<TodoForm> createState() => _TodoFormState();
}
class _TodoFormState extends State<TodoForm> {
  final title = TextEditingController();
  final description = TextEditingController();
  String priority = 'Medium';
  bool loading = false;


  @override
  void dispose() { title.dispose(); description.dispose(); super.dispose(); }

  Future<void> save() async {
    if (title.text.trim().isEmpty) return;
    setState(() => loading = true);
    final ok = await widget.onSave(TodoModel(id: '', title: title.text.trim(),
      description: description.text.trim(), priority: priority));
    if (mounted) setState(() => loading = false);
    if (ok && mounted) Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) => Padding(padding: EdgeInsets.only(
    bottom: MediaQuery.of(context).viewInsets.bottom), child: SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(22, 12, 22, 24), child: Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(child: Container(width: 38, height: 4, decoration: BoxDecoration(
        color: AppColors.border, borderRadius: BorderRadius.circular(5))),),
      const SizedBox(height: 20), const Text('Create a task', style: TextStyle(
        fontSize: 22, fontWeight: FontWeight.w800)),
      const SizedBox(height: 18), const Text('Task title'), const SizedBox(height: 8),
      TextField(controller: title, autofocus: true, decoration: const InputDecoration(
        hintText: 'What do you need to do?')), const SizedBox(height: 16),
      const Text('Description'), const SizedBox(height: 8),
      TextField(controller: description, maxLines: 3, decoration: const InputDecoration(
        hintText: 'Add some details (optional)')), const SizedBox(height: 16),
      const Text('Priority'), const SizedBox(height: 8),
      DropdownButtonFormField<String>(value: priority, decoration: const InputDecoration(),
        items: ['Low', 'Medium', 'High', 'Critical'].map((e) => DropdownMenuItem(
          value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => priority = v ?? 'Medium'),
      ), const SizedBox(height: 22),
      AppButton(label: 'Create task', loading: loading, onPressed: save,
        icon: Icons.add_rounded),
    ])));
}
