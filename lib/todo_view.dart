import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_state_management/utility/project_logger.dart';
import 'package:flutter_state_management/repository/todo_repository.dart';

class TodoView extends StatelessWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProjectLogger().logger.i("TodoView build run");
    return Scaffold(
      appBar: buildAppBar(),
      body: const CategoryBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(title: const Text("My Todo List - Riverpod"));
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

class CategoryTitleWidget extends ConsumerWidget {
  const CategoryTitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ProjectLogger().logger.i("CategoryTitle build run");

    final todoRepository = ref.watch(todoRepositoryProvider);

    return PhysicalModel(
      elevation: 20,
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text(todoRepository.category ?? ""),
        ),
      ),
    );
  }
}

class CategoryItems extends ConsumerWidget {
  const CategoryItems({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ProjectLogger().logger.i("CategoryItems build run");

    final todoRepository = ref.watch(todoRepositoryProvider);

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(todoRepository.todoItems[index] ?? ""),
          ),
        );
      },
      itemCount: todoRepository.todoItems.length ?? 0,
    );
  }
}

class CategoryInput extends ConsumerStatefulWidget {
  const CategoryInput({
    super.key,
  });

  @override
  ConsumerState<CategoryInput> createState() => _CategoryInputState();
}

class _CategoryInputState extends ConsumerState<CategoryInput> {
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
                ref.read(todoRepositoryProvider).addItem(controller.text);
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
