import 'package:flutter/material.dart';
import 'package:todo_api/services/todo_service.dart';
import 'package:todo_api/view/work_add.dart';
import 'package:todo_api/widgets/todo_card.dart';

class TodoListpage extends StatefulWidget {
  const TodoListpage({super.key});

  @override
  State<TodoListpage> createState() => _TodoListpageState();
}

class _TodoListpageState extends State<TodoListpage> {
  @override
  void initState() {
    super.initState();
    fetchtodo();
  }

  bool isloading = true;
  List items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'todo list',
        ),
      ),
      body: Visibility(
        visible: isloading,
        child: Center(
          child: const CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchtodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Text('THERE IS NOT DATA'),
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return Todocard(
                    index: index,
                    item: item,
                    deletbyid: deletebyid,
                    navigateEdit: navigatetoeditpage,
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            navigatetoanotherpage();
          },
          label: const Text('Add Todo')),
    );
  }

  void navigatetoanotherpage() {
    final route = MaterialPageRoute(builder: (context) => const Addtodo());
    Navigator.push(context, route);
  }

  void navigatetoeditpage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => Addtodo(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchtodo();
  }

  deletebyid(String id) async {
    final isSucces = await TodoService.deletedbyid(id);
    if (isSucces) {
      final filters = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filters;
      });
    } else {}
  }

  Future<void> fetchtodo() async {
    final response = await TodoService.fetchdata();
    if (response != null) {
      setState(() {
        items = response;
      });
    }
    setState(() {
      isloading = false;
    });
  }
}
