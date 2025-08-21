import 'package:flutter/material.dart';
import 'pages/task_page.dart';
import 'api/api_service.dart';

void main() {
  final apiService = ApiService(); // Single instance
  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;

  MyApp({required this.apiService}); // Receive it from main

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Task Beobachter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TaskPage(apiService: apiService),
    );
  }
}
