import 'package:flutter/material.dart';
import 'package:flutter_state_management/utility/project_logger.dart';
import 'package:flutter_state_management/repository/todo_repository.dart';

class TodoView extends StatelessWidget {
  TodoView({super.key});

  final TodoRepository todoRepositoryNotifier = TodoRepository();

  @override
  Widget build(BuildContext context) {
    ProjectLogger().logger.i("TodoView build run");
    return Scaffold(
      appBar: buildAppBar(),
      body: CategoryAncestor(
        notifier: todoRepositoryNotifier,
        child: const CategoryBody(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(title: const Text("My Todo List - InheritedNotifier"));
  }
}

class CategoryAncestor extends InheritedNotifier<TodoRepository> {
  const CategoryAncestor({
    Key? key,
    required Widget child,
    required TodoRepository notifier,
  }) : super(key: key, notifier: notifier, child: child);

  static TodoRepository? of(BuildContext context) {
    final TodoRepository? result = context
        .dependOnInheritedWidgetOfExactType<CategoryAncestor>()
        ?.notifier;
    assert(result != null, 'No CategoryAncestor found in context');
    return result;
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
    var ancestor = CategoryAncestor.of(context);

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
    var ancestor = CategoryAncestor.of(context);

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
    var ancestor = CategoryAncestor.of(context);

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
                ancestor?.addItem(controller.text);
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
