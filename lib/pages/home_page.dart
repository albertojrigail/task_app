import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:to_do_app/blocs/task_bloc.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/pages/create_task_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final taskBloc = TaskBloc();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          DefaultTabController(
            length: 2,
            child: Scaffold(
            appBar: AppBar(
              title: Text("Task List"),
              bottom: TabBar(
                indicatorColor: Colors.black,
                tabs: <Widget>[
                  Icon(Icons.timelapse, size: 30,),
                  Icon(Icons.done, size: 30),
                ],
              ),
            ),
            body: TabBarView(
            children: <Widget>[
              taskListView(taskBloc.subjectProgress, taskState.stateProgress),
              taskListView(taskBloc.subjectDone, taskState.stateDone),
              ],
            ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                child: Text(
                  '+',
                  style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.white,
                    ),
                  ),
                backgroundColor: Colors.orange,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreateTaskPage(mode: taskMode.modeCreate)));
                },
              ),
            ),
          ),
        ]
      ),
    );
  }

  Widget taskListView(BehaviorSubject<List<Task>> stream, taskState state) {
    Icon changeStateIcon = (state == taskState.stateProgress) ? Icon(Icons.done) : Icon(Icons.delete);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<List<Task>>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.hasData) {
            List<Task> tasks = snapshot.data;
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ListTile(
                    leading: Icon(Icons.note),
                    title: Text('${tasks[index].text}'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>
                      CreateTaskPage(task: tasks[index], mode: taskMode.modeEdit),
                      ),);
                    },
                    trailing: GestureDetector(
                      child: changeStateIcon,
                      onTap: () {
                        if (state == taskState.stateProgress) {
                          taskBloc.changeTaskState(tasks[index], taskState.stateDone);
                        } else {
                          taskBloc.removeTask(tasks[index]);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        }
      ),
    );
  }
}