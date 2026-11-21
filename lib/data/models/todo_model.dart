class TodoModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final DateTime? dueDate;
  final List<String> tags;

  const TodoModel({required this.id, required this.title, this.description = '',
    this.status = 'Not Started', this.priority = 'Medium', this.dueDate,
    this.tags = const []});

  bool get isCompleted => status.toLowerCase() == 'completed';

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
    id: (json['id'] ?? '').toString(),
    title: (json['title'] ?? 'Untitled').toString(),
    description: (json['description'] ?? '').toString(),
    status: (json['status'] ?? 'Not Started').toString(),
    priority: (json['priority'] ?? 'Medium').toString(),
    dueDate: DateTime.tryParse((json['dueDate'] ?? '').toString()),
    tags: (json['tags'] as List? ?? []).map((e) => e.toString()).toList(),
  );

  Map<String, dynamic> toJson() => {
    'title': title, 'description': description,
    'status': status, 'priority': priority,
    if (dueDate != null) 'dueDate': dueDate!.toIso8601String(), 'tags': tags,
  };


  TodoModel copyWith({String? title, String? description, String? status,
      String? priority, DateTime? dueDate}) => TodoModel(
    id: id, title: title ?? this.title,
    description: description ?? this.description, status: status ?? this.status,
    priority: priority ?? this.priority, dueDate: dueDate ?? this.dueDate,
    tags: tags);
}
