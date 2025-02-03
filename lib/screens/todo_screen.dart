import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/todo_model.dart';
import '../widgets/sidebar.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTodos(); // Fetch todos from the provider
  }

  void _fetchTodos() async {
    await Provider.of<UserProvider>(context, listen: false).fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<UserProvider>(context).todos;

    return Scaffold(
      drawer: Sidebar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/todobackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // List Todo items
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8), // Transparansi untuk memberi efek shadow
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF1D87FF), width: 2), // Border biru Hololive
                      ),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 20, // Ukuran font lebih besar
                              fontWeight: FontWeight.bold, // Menambahkan fontWeight agar lebih menonjol
                              fontFamily: 'Raleway', // Menggunakan font Raleway
                              color: Color(0xFF1D87FF), // Menggunakan warna biru Hololive
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            todo.description,
                            style: TextStyle(
                              fontSize: 16, // Ukuran font deskripsi sedikit lebih kecil
                              fontFamily: 'Raleway', // Menggunakan font Raleway
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () {
                                _editTodoDialog(context, todo);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                Provider.of<UserProvider>(context, listen: false)
                                    .deleteTodoRemote(todo.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Add Todo button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1D87FF), // Warna biru Hololive untuk tombol
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _addTodoDialog(context);
                },
                child: Text('Tambah Todo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog untuk menambah todo
  void _addTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tambah Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: "Judul todo..."),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(hintText: "Deskripsi todo..."),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Simpan"),
              onPressed: () {
                String title = _titleController.text;
                String description = _descriptionController.text;
                if (title.isNotEmpty && description.isNotEmpty) {
                  Provider.of<UserProvider>(context, listen: false)
                      .createTodo(title, description);
                  _titleController.clear();
                  _descriptionController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Dialog untuk mengedit todo
  void _editTodoDialog(BuildContext context, Todo todo) {
    _titleController.text = todo.title;
    _descriptionController.text = todo.description;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: "Ubah judul todo..."),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(hintText: "Ubah deskripsi todo..."),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Simpan"),
              onPressed: () {
                String title = _titleController.text;
                String description = _descriptionController.text;
                if (title.isNotEmpty && description.isNotEmpty) {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateTodoRemote(todo.id, title, description);
                  _titleController.clear();
                  _descriptionController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
