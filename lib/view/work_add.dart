import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/view/todo_list.dart';

class Addtodo extends StatefulWidget {
  final Map? todo;
  const Addtodo({super.key, this.todo});

  @override
  State<Addtodo> createState() => _AddtodoState();
}

class _AddtodoState extends State<Addtodo> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final describtion = todo['description'];
      titlecontroller.text = title;
      descriptioncontroller.text = describtion;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: titlecontroller,
            decoration:
                const InputDecoration(hintText: 'title add for the work'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptioncontroller,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              isEdit ? editedData() : submitData();
              navigatetohomepage(context);
            },
            child: Text(isEdit ? 'update' : 'Submit'),
          )
        ],
      ),
    );
  }

  editedData() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo['_id'];
    final title = titlecontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      showSuccessMessage('Updation Success');
    } else {
      showerrorMessage('updation Failed');
    }
  }

  submitData() async {
    final title = titlecontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      titlecontroller.text = '';
      descriptioncontroller.text = '';
      showSuccessMessage('Creation Success');
    } else {
      showerrorMessage('its not adding successfully');
    }
  }

  void navigatetohomepage(BuildContext context) async {
    final route = MaterialPageRoute(builder: (context) => const TodoListpage());
    await Navigator.pushAndRemoveUntil(
      context,
      route,
      (route) => false,
    );
  }

  showSuccessMessage(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: const TextStyle(color: Colors.green),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showerrorMessage(String message) {
    final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
