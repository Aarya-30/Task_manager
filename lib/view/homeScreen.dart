import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/controller/colours.dart';
import 'package:task_manager/controller/task_controller.dart';
import 'package:task_manager/view/task.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TaskController>(context, listen: false)
            .fetchTasks());
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TaskController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Task Manager",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<FilterType>(
            onSelected: controller.setFilter,
            itemBuilder: (_) => const [
              PopupMenuItem(
                  value: FilterType.all, child: Text("All")),
              PopupMenuItem(
                  value: FilterType.completed,
                  child: Text("Completed")),
              PopupMenuItem(
                  value: FilterType.pending,
                  child: Text("Pending")),
            ],
          )
        ],
      ),

      /// BODY
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.error != null
              ? Center(child: Text(controller.error!))
              : RefreshIndicator(
                  onRefresh: controller.fetchTasks,
                  child: ListView.builder(
                    itemCount: controller.tasks.length,
                    itemBuilder: (_, index) =>
                        TaskTile(task: controller.tasks[index]),
                  ),
                ),

      /// FLOATING ADD BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add),
        onPressed: () {
          TextEditingController titleController =
              TextEditingController();
          TextEditingController descController =
              TextEditingController();

          DateTime selectedDate = DateTime.now();

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Add New Task",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// TITLE FIELD
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Task Title",
                        hintText: "Enter task title",
                        prefixIcon: const Icon(Icons.task),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    

                    /// DUE DATE PICKER BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(
                                  vertical: 14),
                          backgroundColor:
                              AppColors.primary,
                        ),
                        onPressed: () async {
                          DateTime? picked =
                              await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now(),
                            firstDate:
                                DateTime(2023),
                            lastDate:
                                DateTime(2030),
                          );

                          if (picked != null) {
                            selectedDate = picked;
                          }
                        },
                        icon: const Icon(
                            Icons.calendar_today,
                            color: Colors.white),
                        label: const Text(
                          "Select Due Date",
                          style: TextStyle(
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// ACTION BUTTONS
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.accent,
                  ),
                  onPressed: () {
                    if (titleController
                        .text.isNotEmpty) {
                      controller.addTask(
                        titleController.text,
                        selectedDate,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Add Task",
                    style:
                        TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}