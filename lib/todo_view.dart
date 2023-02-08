import 'package:flutter/material.dart';
import 'package:flutter_state_management/utility/project_logger.dart';
import 'package:flutter_state_management/repository/todo_repository.dart';

class TodoView extends StatefulWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  late TodoRepository todoRepository;

  @override
  void initState() {
    super.initState();
    todoRepository = TodoRepository();
  }

  void addTodo(String text) {
    setState(() {
      todoRepository.addItem(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    //print("TodoView build run");
    ProjectLogger().logger.i("TodoView build run");
    return Scaffold(
      appBar: buildAppBar(),
      body: CategoryBody(
        category: todoRepository.category,
        todoItems: todoRepository.todoItems,
        addTodo: addTodo,
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(title: const Text("My Todo List - Vanilla"));
  }
}

class CategoryBody extends StatelessWidget {
  const CategoryBody({
    super.key,
    required this.category,
    required this.todoItems,
    required this.addTodo,
  });

  final String category;
  final List<String> todoItems;
  final void Function(String text) addTodo;

  @override
  Widget build(BuildContext context) {
    //print("CategoryBody build run");
    ProjectLogger().logger.i("CategoryBody build run");
    return Column(
      children: [
        CategoryTitleWidget(category: category),
        Expanded(
          child: CategoryItems(todoItems: todoItems),
        ),
        CategoryInput(addTodo: addTodo),
      ],
    );
  }
}

class CategoryTitleWidget extends StatelessWidget {
  const CategoryTitleWidget({
    super.key,
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    //print("CategoryTitle build run");
    ProjectLogger().logger.i("CategoryTitle build run");
    return PhysicalModel(
      elevation: 20,
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text(category),
        ),
      ),
    );
  }
}

class CategoryItems extends StatelessWidget {
  const CategoryItems({
    super.key,
    required this.todoItems,
  });

  final List<String> todoItems;

  @override
  Widget build(BuildContext context) {
    // print("CategoryItems build run");
    ProjectLogger().logger.i("CategoryItems build run");
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(todoItems[index]),
          ),
        );
      },
      itemCount: todoItems.length,
    );
  }
}

class CategoryInput extends StatefulWidget {
  const CategoryInput({
    super.key,
    required this.addTodo,
  });

  final void Function(String text) addTodo;

  @override
  State<CategoryInput> createState() => _CategoryInputState();
}

class _CategoryInputState extends State<CategoryInput> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print("CategoryInput build run");
    ProjectLogger().logger.i("CategoryInput build run");
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all()),
      child: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () {
                widget.addTodo(controller.text);
                controller.clear();
              },
              child: const Text("Add"),
            ),
          )
        ],
      ),
    );
  }
}
