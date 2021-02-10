import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/util/firebaseHelper.dart';

FirebaseHelper firebaseHelper = FirebaseHelper();

final List<String> choices = const <String>['Save', 'Delete', 'Back'];

const mnuSave = 'Save';
const mnuDelete = 'Delete';
const mnuBack = 'Back';

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State<TodoDetail> {
  Todo todo;
  TodoDetailState(this.todo);
  final _priorities = ["High", "Medium", "Low"];
  String _priority = "Low";

  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleEditingController.text = todo.title;
    descriptionEditingController.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(todo.title),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: select,
              itemBuilder: (BuildContext context) {
                return choices.map((String value) {
                  return PopupMenuItem(value: value, child: Text(value));
                }).toList();
              })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
        child: ListView(children: [
          Column(
            children: <Widget>[
              TextField(
                controller: titleEditingController,
                style: textStyle,
                onChanged: (value) => this.updateTitle(),
                decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionEditingController,
                  style: textStyle,
                  onChanged: (value) => this.updateDescription(),
                  decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              ListTile(
                title: DropdownButton<String>(
                  items: _priorities.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  style: textStyle,
                  value: retrievePriority(todo.priority),
                  onChanged: (String value) {
                    updatePriority(value);
                  },
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  void select(String value) async {
    int result;
    switch (value) {
      case mnuSave:
        showLoaderDialog(context);
        await save();
        Navigator.pop(context, true); // removing the loader
        Navigator.pop(context, true); // going back
        break;
      case mnuDelete:
        showLoaderDialog(context);
        if (todo.id == null) {
          return;
        }
        result = await firebaseHelper.deleteTodo(todo.id);
        Navigator.pop(context, true); // removing the loader
        Navigator.pop(context, true); // going back
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text('Delete Todo'),
            content: Text('The Todo has been deleted'),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
      default:
    }
  }

  Future save() async {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if (todo.id != null) {
      return firebaseHelper.updateTodo(todo);
    } else {
      return firebaseHelper.insertTodo(todo);
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
    }
    setState(() {
      _priority = value;
    });
  }

  String retrievePriority(int value) {
    return _priorities[value - 1];
  }

  void updateTitle() {
    todo.title = titleEditingController.text;
  }

  void updateDescription() {
    todo.description = descriptionEditingController.text;
  }
}
