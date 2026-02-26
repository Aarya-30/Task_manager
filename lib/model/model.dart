class TaskModel {
  final int id;
  final String title;
  final bool completed;
  final DateTime dueDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.completed,
    required this.dueDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
      dueDate: DateTime.now(),
    );
  }
}