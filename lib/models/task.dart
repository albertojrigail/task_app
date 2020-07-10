enum taskState {stateProgress, stateDone}
enum taskMode {modeCreate, modeEdit}

class Task {
  String text;
  String category;
  DateTime dateCreated = DateTime.now();
  taskState state = taskState.stateProgress;

  // constructor
  Task({this.text, this.category, this.state});
}