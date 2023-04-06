import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoRepository extends ChangeNotifier{
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

final todoRepositoryProvider = ChangeNotifierProvider((ref) {
  return TodoRepository();
});