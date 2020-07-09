import 'package:flutter/material.dart';
import 'package:to_do_app/blocs/task_bloc.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/pages/create_task_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<List<Task>> taskStream = TaskBloc().stream;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Scaffold(
          appBar: AppBar(
            title: Text("Task List"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: StreamBuilder<List<Task>>(
                stream: taskStream,
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
                              CreateTaskPage(
                                isEditMode: true,
                                task: tasks[index]
                                ),
                              ),);
                            }
                          ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                }
                
                ),
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
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreateTaskPage(isEditMode: false,)));
                },
              ),
            ),
          ),
        ]
      ),
    );
  }
}