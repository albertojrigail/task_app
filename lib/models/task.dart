class Task {
  String text;
  String category;
  String iconUrl;
  DateTime dateCreated = DateTime.now();
  bool isDone = false;

  // constructor
  Task({this.text, this.category});
}