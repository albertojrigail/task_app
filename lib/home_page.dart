import 'package:flutter/material.dart';
import 'package:to_do_app/task.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks;

  TextEditingController _taskDescriptionController;
  TextEditingController _taskTagsController;

  void initState() { 
    super.initState();
    tasks = [];
    _taskDescriptionController = TextEditingController();
    _taskTagsController = TextEditingController();
    // tasks = new List<Task>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task List"),
        actions: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.orange[200],
              onPressed: () {
                addTask();
              },
              icon: Icon(Icons.add_box),
              label: Text('add'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: ListTile(
                  leading: const Icon(Icons.note),
                  title: Text('${tasks[index].text}'),
                  onTap: () {editTask(tasks[index]);}
                ),
              );
            },
          )
        ),
      ),
    );
  }

  Future<void> addTask() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add a new task?'),
        content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Description'),
                TextField(controller: _taskDescriptionController, maxLines: null,),
                SizedBox(height: 40.0,),
                Text('Category'),
                TextField(controller: _taskTagsController, maxLines: null,),
              ],
            ),
          ),
        actions: <Widget>[
          FlatButton(
            child: Text('Accept', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              final text = _taskDescriptionController.text;
              if(text.isNotEmpty) {
                Navigator.of(context).pop();
                Task task = new Task(text: text, dateCreated: DateTime.now());
                _taskDescriptionController.text = '';
                _taskTagsController.text = '';
                this.setState(() {
                  tasks.add(task);
                });
              }
            },
            
          ),
          FlatButton(
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
              _taskDescriptionController.text = '';
              _taskTagsController.text = '';
            },
          ),
        ]
      );
    },
  );
}

Future<void> editTask(Task task) async {
  _taskDescriptionController.text = task.text;
  _taskTagsController.text = '';
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Task?'),
        content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Description'),
                TextField(controller: _taskDescriptionController, maxLines: null,),
                SizedBox(height: 40.0,),
                Text('Category'),
                TextField(controller: _taskTagsController, maxLines: null,),
              ],
            ),
          ),
        actions: <Widget>[
          FlatButton(
            child: Text('Save', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              final text = _taskDescriptionController.text;
              if(text.isNotEmpty) {
                Navigator.of(context).pop();
                this.setState(() {
                  task.text = _taskDescriptionController.text;
                });
                _taskDescriptionController.text = '';
                _taskTagsController.text = '';
              }
            },
            
          ),
          FlatButton(
            child: Text('Cancel', style: TextStyle(color: Colors.orange)),
            onPressed: () {
              Navigator.of(context).pop();
              _taskDescriptionController.text = '';
              _taskTagsController.text = '';
            },
          ),
          FlatButton(
            child: Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
              _taskDescriptionController.text = '';
              _taskTagsController.text = '';
              this.setState(() { 
                tasks.remove(task);
              });
            },
          ),
        ]
      );
    },
  );
}


  void dispose() {
    _taskDescriptionController.dispose();
    _taskTagsController.dispose();
    super.dispose();
  }
}