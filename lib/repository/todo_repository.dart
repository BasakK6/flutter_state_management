import 'package:flutter/material.dart';

class TodoRepository extends ChangeNotifier {
  List<String> todoItems = [
    "Change the sheets",
    "Do laundry",
    "Sweep the floor",
  ];

  String category = "House Chores";

  void addItem(String text) {
    todoItems.add(text);
    notifyListeners();
  }
}
