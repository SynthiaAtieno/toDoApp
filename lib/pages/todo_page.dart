import 'package:flutter/material.dart';

import '../util/dialog_box.dart';
import '../util/todo_tile.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

TextEditingController userName = TextEditingController();
TextEditingController newTask = TextEditingController();

String greetings = "";

class _TodoPageState extends State<TodoPage> {
  void sayHi() {
    setState(() {
      greetings = "Hello, ${userName.text}";
    });
  }

  List todoList = [
    ["Make Tutorial", false],
    ["Do Exercise", false]
  ];

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      todoList[index][1] = !todoList[index][1];
    });
  }

  void addNewTask() {
    setState(() {
      newTask.text != ""
          ? todoList.add([newTask.text, false])
          : const Text("Please add a task");
      newTask.clear();
    });
    Navigator.of(context).pop();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: newTask,
          onSave: addNewTask,
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      todoList.removeAt(index);
      newTask.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ToDo"),
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            return createNewTask();
          },
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            return TodoTile(
              isCompleted: todoList[index][1],
              onChanged: (value) {
                checkBoxChanged(value, index);
              },
              taskValue: todoList[index][0],
              deleteToDo: (BuildContext) => deleteTask(index),
            );
          },
        )
        /*Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            children: [
              Text(greetings),
              TextField(
                controller: userName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Type your name..."
                ),
              ),
                ElevatedButton(onPressed: sayHi, child: const Text("Tap"))
            ],
          ),
        ),
      ),*/
        );
  }
}
