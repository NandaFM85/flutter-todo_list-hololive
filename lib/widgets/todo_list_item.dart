import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final Function onDelete;

  TodoListItem({
    required this.todo,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        title: Text(
          todo.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(todo.description),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => onDelete(todo.id),
        ),
      ),
    );
  }
}
