import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/controller/colours.dart';
import 'package:task_manager/controller/task_controller.dart';
import 'package:task_manager/view/login.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}