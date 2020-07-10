import 'package:to_do_app/models/task.dart';
import 'package:rxdart/rxdart.dart';

class TaskBloc {
  
  List<Task> tasksProgress = [];
  List<Task> tasksDone = [];

  // controller
  BehaviorSubject<List<Task>> _subjectProgressTaskList = new BehaviorSubject<List<Task>>.seeded([]);
  BehaviorSubject<List<Task>> _subjectDoneTaskList = new BehaviorSubject<List<Task>>.seeded([]);

 // get methods
  BehaviorSubject<List<Task>> get subjectProgress => _subjectProgressTaskList.stream;
  BehaviorSubject<List<Task>> get subjectDone => _subjectDoneTaskList.stream;

  // singleton for class TaskBloc
  factory TaskBloc() => _taskBloc;
  static final TaskBloc _taskBloc = TaskBloc._internal();
  TaskBloc._internal();

  
  // adds task to the in progress task list
  // adds the updated list to the _subjectProgressTaskList
  addTask(Task task) {
    tasksProgress.add(task);
    _subjectProgressTaskList.add(this.tasksProgress);
  }

  // removes task from the corresponding list, depending on its state
  // adds the updated list to the corresponding subject
  removeTask(Task task) {
    if(task.state == taskState.stateDone) {
      tasksDone.remove(task);
      _subjectDoneTaskList.add(this.tasksDone);
    } else {
      tasksProgress.remove(task);
      _subjectProgressTaskList.add(this.tasksProgress);
    }
  }

  // updates task on the corresponding list, depending on its state
  // adds the updated list to the corresponding subject
  updateTask(Task task) {
    if(task.state == taskState.stateDone) {
      _subjectProgressTaskList.add(this.tasksDone);
    } else {
      _subjectDoneTaskList.add(this.tasksProgress);
    }
  }

  // moves a task from one list to another list, depending on newState
  // adds both updated lists to their corresponding subjects
  changeTaskState(Task task, taskState newState) {
    if(newState == taskState.stateDone) {
      tasksProgress.remove(task);
      task.state = taskState.stateDone;
      tasksDone.add(task);
    } else {
      tasksDone.remove(task);
      task.state = taskState.stateProgress;
      tasksProgress.add(task);
    }
    _subjectDoneTaskList.add(this.tasksDone);
    _subjectProgressTaskList.add(this.tasksProgress);
  }

  // closes the BehaviorSubject objects
  void dispose() {
    _subjectProgressTaskList.close();
    _subjectDoneTaskList.close();
  }
}