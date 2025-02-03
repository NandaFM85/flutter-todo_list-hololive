import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  Navbar({Key? key}) : preferredSize = Size.fromHeight(60.0), super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Vigenesia Flutter"),
      actions: [
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        IconButton(
          icon: Icon(Icons.mood),
          onPressed: () {
            Navigator.pushNamed(context, '/motivation');
          },
        ),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            Navigator.pushNamed(context, '/todo');
          },
        ),
      ],
    );
  }
}
