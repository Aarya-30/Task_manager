import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_manager/model/model.dart';


class ApiService {
  Future<List<TaskModel>> fetchTasks() async {
    final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/todos"),
      headers: {
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((e) => TaskModel(
        id: e['id'],
        title: e['title'],          // PDF API field
        completed: e['completed'],  // PDF API field
        dueDate: DateTime.now(),    // API does not provide dueDate
      )).toList();
    } else {
      throw Exception(
          "Failed to load tasks. Status: ${response.statusCode}");
    }
  }
}