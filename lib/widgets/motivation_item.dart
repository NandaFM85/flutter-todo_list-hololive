import 'package:flutter/material.dart';
import '../models/motivation_model.dart';

class MotivationItem extends StatelessWidget {
  final Motivation motivation;
  final Function onEdit;
  final Function onDelete;

  MotivationItem({
    required this.motivation,
    required this.onEdit,
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
          motivation.content,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => onEdit(motivation.id),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => onDelete(motivation.id),
            ),
          ],
        ),
      ),
    );
  }
}
