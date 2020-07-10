import 'package:flutter/material.dart';
import 'package:to_do_app/blocs/task_bloc.dart';
import 'package:to_do_app/models/task.dart';

final String emptyTaskMessage = 'Emtpy Task!';

class CreateTaskPage extends StatefulWidget {
  final Task task; // task to be created or modified
  final taskMode mode; // edit vs create mode

  CreateTaskPage({Key key, this.mode, this.task}) : super(key: key);

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState(mode: this.mode, task: this.task);
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  // text editing controllers
  TextEditingController _taskDescriptionController = TextEditingController();
  TextEditingController _taskCategoryController = TextEditingController();

  Task task; // task to be created or modified
  TaskBloc taskBloc = TaskBloc(); // singleton TaskBloc
  taskMode mode; /// edit vs create mode

  bool isError; // handles error messages
  String errorMessage; // displayed on error

  _CreateTaskPageState({this.mode, this.task});

  initState() {
    super.initState();
    if (task == null) task = new Task(text:'', category: '', state: taskState.stateProgress);
    _taskDescriptionController.text = task.text;
    _taskCategoryController.text = task.category;
  } 

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: mode == taskMode.modeCreate ?
              Text('Create Task') : Text('Edit Task'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(50.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text('Task Description'),
                    TextField(controller: _taskDescriptionController, maxLines: null,),
                    SizedBox(height: 40.0,),
                    Text('Category'),
                    TextField(controller: _taskCategoryController, maxLines: null,),
                    Row(
                      children: <Widget>[
                        // accept button
                        FlatButton(
                          child: Text('Accept', style: TextStyle(color: Colors.blue)),
                          onPressed: () {
                            final text = _taskDescriptionController.text;
                            final category = _taskCategoryController.text;

                            // non-empty description
                            if(text.isNotEmpty) {
                              task.text = text;
                              task.category = category;

                              // create new task
                              if(mode == taskMode.modeCreate) taskBloc.addTask(task);
                              
                              // update task
                              else taskBloc.updateTask(task);

                              // pop and clean
                              Navigator.of(context).pop();
                              _taskDescriptionController.text = '';
                              _taskCategoryController.text = '';
                            } else {
                              // display error message
                              setState(() {
                                isError = true;
                                errorMessage = emptyTaskMessage;
                              });
                            }
                          },
                        ),
                        // cancel button          
                        FlatButton(
                          child: Text('Cancel', style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _taskDescriptionController.text = '';
                            _taskCategoryController.text = '';
                          },
                        ),
                        // remove button
                        mode == taskMode.modeEdit ? FlatButton(
                          child: Text('Remove', style: TextStyle(color: Colors.orange)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            // remove task from list
                            taskBloc.removeTask(task);
                          },
                        ) : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // window for error messages
          // displays errorMessage when isError is true
          isError == true? GestureDetector(
            onTap: () {
              setState(() {
                isError = false;
              });
            },
            child: Container(
              color: Colors.black38,
              child: AlertDialog(
                content: Text(
                  errorMessage,
                  textAlign: TextAlign.center
                  ),
                ),
              ),
          ) : Container(),
        ]
      ),
    );
  }

  void dispose() {
    _taskDescriptionController.dispose();
    _taskCategoryController.dispose();
    super.dispose();
  }
}