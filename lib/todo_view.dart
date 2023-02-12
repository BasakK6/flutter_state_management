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
      //todoRepository.addItem(text); //does not work because the list requires a new reference
      todoRepository.addItemToNewList(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    ProjectLogger().logger.i("TodoView build run");
    return Scaffold(
      appBar: buildAppBar(),
      body: CategoryAncestor(
        category: todoRepository.category,
        todoItems: todoRepository.todoItems,
        addTodo: addTodo,
        child: const CategoryBody(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(title: const Text("My Todo List - InheritedModel"));
  }
}

class CategoryAncestor extends InheritedModel<String> {
  const CategoryAncestor({
    Key? key,
    required Widget child,
    required this.category,
    required this.todoItems,
    required this.addTodo,
  }) : super(key: key, child: child);

  final String category;
  final List<String> todoItems;
  final void Function(String text) addTodo;

  static CategoryAncestor of(BuildContext context) {
    final CategoryAncestor? result =
        context.dependOnInheritedWidgetOfExactType<CategoryAncestor>();
    assert(result != null, 'No CategoryAncestor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CategoryAncestor oldWidget) {
    return oldWidget.category != category ||
        oldWidget.todoItems != todoItems ||
        oldWidget.addTodo != addTodo;
  }

  @override
  bool updateShouldNotifyDependent(CategoryAncestor oldWidget, Set<String> dependencies) {
    if(dependencies.contains("todo items") && oldWidget.todoItems != todoItems){
      return true;
    }
    if(dependencies.contains("category") && oldWidget.category != category){
      return true;
    }
    if(dependencies.contains("addTodo function") && oldWidget.addTodo != addTodo){
      return true;
    }
    return false;
  }
}

class CategoryBody extends StatelessWidget {
  const CategoryBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProjectLogger().logger.i("CategoryBody build run");
    return Column(
      children: const [
        CategoryTitleWidget(),
        Expanded(
          child: CategoryItems(),
        ),
        CategoryInput(),
      ],
    );
  }
}

class CategoryTitleWidget extends StatelessWidget {
  const CategoryTitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProjectLogger().logger.i("CategoryTitle build run");
    var ancestor = InheritedModel.inheritFrom<CategoryAncestor>(context, aspect: "category");

    return PhysicalModel(
      elevation: 20,
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text(ancestor?.category ?? ""),
        ),
      ),
    );
  }
}

class CategoryItems extends StatelessWidget {
  const CategoryItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProjectLogger().logger.i("CategoryItems build run");
    var ancestor = InheritedModel.inheritFrom<CategoryAncestor>(context, aspect: "todo items");

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(ancestor?.todoItems[index] ?? ""),
          ),
        );
      },
      itemCount: ancestor?.todoItems.length ?? 0,
    );
  }
}

class CategoryInput extends StatefulWidget {
  const CategoryInput({
    super.key,
  });

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
    ProjectLogger().logger.i("CategoryInput build run");
    var ancestor = InheritedModel.inheritFrom<CategoryAncestor>(context, aspect: "addTodo function");

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
                ancestor?.addTodo(controller.text);
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
