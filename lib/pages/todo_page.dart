import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/data/database.dart';

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
 /* void sayHi() {
    setState(() {
      greetings = "Hello, ${userName.text}";
    });
  }*/

  ToDoDatabase db = ToDoDatabase();

  // reference the box
  final myBox = Hive.box('my_box');

  @override
  void initState() {

    if(myBox.get('TODOLIST') == null){
      db.createInitialData();
    }else{
      db.loadData();
    }

    super.initState();
  }


  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void addNewTask() {
    setState(() {
      newTask.text != ""
          ? db.toDoList.add([newTask.text, false])
          : const Text("Please add a task");
      newTask.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
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
      db.toDoList.removeAt(index);
      newTask.clear();
    });
    db.updateDataBase();
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
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return TodoTile(
              isCompleted: db.toDoList[index][1],
              onChanged: (value) {
                checkBoxChanged(value, index);
              },
              taskValue: db.toDoList[index][0],
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
