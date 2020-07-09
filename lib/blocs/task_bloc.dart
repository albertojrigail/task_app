import 'dart:async';
import 'package:to_do_app/models/task.dart';

class TaskBloc {
  List<Task> tasks = [];
  
  // creates a Singleton
  factory TaskBloc() => _taskBloc;
  static final TaskBloc _taskBloc = TaskBloc._internal();
  TaskBloc._internal();
  
  // Stream Controller objects
  final _controllerTaskList = StreamController<List<Task>>();

  // get functions
  Stream<List<Task>> get stream => _controllerTaskList.stream;
  
  // functions to manipulate the list tasks
  addTask(Task task) {
    tasks.add(task);
    _controllerTaskList.sink.add(this.tasks);
  }
  removeTask(Task task) {
    tasks.remove(task);
    _controllerTaskList.sink.add(this.tasks);
  }
  updateTask(Task task, String text, String category) {
    task.text = text;
    task.category = category;
    _controllerTaskList.sink.add(this.tasks);
  }
}