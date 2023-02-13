import 'package:flutter/material.dart';
import 'package:flutter_state_management/todo_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Management Methods',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoView(),
    );
  }
}
