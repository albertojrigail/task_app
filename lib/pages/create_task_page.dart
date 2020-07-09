import 'package:flutter/material.dart';
import 'package:to_do_app/blocs/task_bloc.dart';
import 'package:to_do_app/models/task.dart';

final String emptyTaskMessage = 'Emtpy Task!';

class CreateTaskPage extends StatefulWidget {
  // Task object to be created or modified
  final Task task;

  // Create vs. Edit page
  final bool isEditMode;

  CreateTaskPage({Key key, this.isEditMode, this.task}) : super(key: key);

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState(isEditMode: this.isEditMode, task: this.task);
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  // Text Editing Controllers
  TextEditingController _taskDescriptionController = TextEditingController();
  TextEditingController _taskCategoryController = TextEditingController();

  // Error Message Handling
  bool isError;
  String errorMessage;

  // Instance variables
  bool isEditMode;
  Task task;
  _CreateTaskPageState({this.isEditMode, this.task});

  initState() {
    super.initState();
    if(isEditMode == true && task != null) {
      _taskDescriptionController.text = task.text;
      _taskCategoryController.text = task.category;
    }
  } 

  // Task Bloc
  TaskBloc taskBloc = TaskBloc();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: isEditMode == true ? Text('Edit Task') : Text('Create Task'),
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
                            final description = _taskDescriptionController.text;
                            final category = _taskCategoryController.text;

                            // valid description name
                            if(description.isNotEmpty) {
                              
                              // modify existing task 
                              if(isEditMode == true) {
                                taskBloc.updateTask(task, description, category);
                              }
                              // add new task to list
                              else {
                                Task task = new Task();
                                task.text = _taskDescriptionController.text;
                                task.category = _taskCategoryController.text;
                                taskBloc.addTask(task);
                              }
                              Navigator.of(context).pop();
                              _taskDescriptionController.text = '';
                              _taskCategoryController.text = '';
                            }
                            
                            // display error message
                            else {
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
                        isEditMode == true ? FlatButton(
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