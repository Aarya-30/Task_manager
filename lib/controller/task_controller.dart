import 'package:flutter/material.dart';
import 'package:task_manager/controller/api.dart';
import 'package:task_manager/model/model.dart';


enum FilterType { all, completed, pending }

class TaskController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<TaskModel> _tasks = [];
  bool isLoading = false;
  String? error;
  FilterType currentFilter = FilterType.all;

  List<TaskModel> get tasks {
    switch (currentFilter) {
      case FilterType.completed:
        return _tasks.where((t) => t.completed).toList();
      case FilterType.pending:
        return _tasks.where((t) => !t.completed).toList();
      default:
        return _tasks;
    }
  }

  Future<void> fetchTasks() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      _tasks = await _apiService.fetchTasks();
    } catch (e) {
      error = "Something went wrong!";
    }

    isLoading = false;
    notifyListeners();
  }

  void setFilter(FilterType filter) {
    currentFilter = filter;
    notifyListeners();
  }

  void addTask(String title, DateTime dueDate) {
    _tasks.insert(
      0,
      TaskModel(
        id: _tasks.length + 1,
        title: title,
        completed: false,
        dueDate: dueDate,
      ),
    );
    notifyListeners();
  }

  void deleteTask(int id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void editTask(int id, String newTitle, DateTime newDate) {
    int index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = TaskModel(
        id: id,
        title: newTitle,
        completed: _tasks[index].completed,
        dueDate: newDate,
      );
      notifyListeners();
    }
  }
}