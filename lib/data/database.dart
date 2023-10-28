import 'package:hive_flutter/adapters.dart';

class ToDoDatabase{
  List toDoList = [];
  final myBox = Hive.box('my_box');

// if the user opens the app for the first time
  void createInitialData(){
    toDoList = [
      ["Make Tutorial", false],
      ["Code an App", false],
    ];
  }

  void loadData(){
    toDoList = myBox.get('TODOLIST');

  }
  void updateDataBase(){
    myBox.put('TODOLIST', toDoList);

  }
}