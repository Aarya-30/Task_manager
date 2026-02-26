import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/controller/colours.dart';
import 'package:task_manager/controller/task_controller.dart';
import 'package:task_manager/model/model.dart';


class TaskTile extends StatelessWidget {
  final TaskModel task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TaskController>();

    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text(
              "Due: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}"),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text(task.completed
                    ? "Completed"
                    : "Pending"),
                backgroundColor: task.completed
                    ? Colors.green.shade100
                    : AppColors.accent.withOpacity(0.3),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit,
                        color: Colors.blue),
                    onPressed: () {
                      TextEditingController editController =
                          TextEditingController(
                              text: task.title);
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Edit Task"),
                          content: TextField(
                              controller:
                                  editController),
                          actions: [
                            TextButton(
                              onPressed: () {
                                controller.editTask(
                                    task.id,
                                    editController.text,
                                    DateTime.now());
                                Navigator.pop(context);
                              },
                              child:
                                  const Text("Save"),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.red),
                    onPressed: () {
                      controller.deleteTask(task.id);
                    },
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}