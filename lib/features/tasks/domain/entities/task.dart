enum TaskImportance { important, notImportant }
enum TaskUrgency { urgent, notUrgent }
enum TaskStatus { todo, inProgress, completed }

class Task {
  final String uuid;
  final String id;
  final String title;
  final String description;
  final List<String> attachments;
  final TaskStatus status;
  final DateTime? schedule;
  final String userUuid;
  final TaskImportance importance;
  final TaskUrgency urgency;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.uuid,
    required this.title,
    this.description = '',
    this.attachments = const [],
    this.status = TaskStatus.todo,
    this.schedule,
    required this.userUuid,
    required this.importance,
    required this.urgency,
    this.isCompleted = false,
  });
}