import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/motivation_model.dart';
import '../widgets/sidebar.dart';

class MotivationScreen extends StatefulWidget {
  @override
  _MotivationScreenState createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMotivations(); // Fetch motivations from the provider
  }

  void _fetchMotivations() async {
    await Provider.of<UserProvider>(context, listen: false).fetchMotivations();
  }

  @override
  Widget build(BuildContext context) {
    final motivations = Provider.of<UserProvider>(context).motivations;

    return Scaffold(
      drawer: Sidebar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/homepostbackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Motivations list
            Expanded(
              child: ListView.builder(
                itemCount: motivations.length,
                itemBuilder: (context, index) {
                  final motivation = motivations[index];
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
                            motivation.content,
                            style: TextStyle(
                              fontSize: 20, // Ukuran font lebih besar
                              fontWeight: FontWeight.bold, // Menambahkan fontWeight agar lebih menonjol
                              fontFamily: 'Raleway', // Menggunakan font Raleway
                              color: Color(0xFF1D87FF), // Menggunakan warna biru Hololive
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () {
                                _editMotivationDialog(context, motivation);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                Provider.of<UserProvider>(context, listen: false)
                                    .deleteMotivationRemote(motivation.id);
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
            
            // Add Motivation button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1D87FF), // Warna biru Hololive untuk tombol
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _addMotivationDialog(context);
                },
                child: Text('Tambah Motivasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog untuk menambah motivasi
  void _addMotivationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tambah Motivasi"),
          content: TextField(
            controller: _contentController,
            decoration: InputDecoration(hintText: "Isi motivasi..."),
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
                String content = _contentController.text;
                if (content.isNotEmpty) {
                  Provider.of<UserProvider>(context, listen: false)
                      .createMotivation(content);
                  _contentController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Dialog untuk mengedit motivasi
  void _editMotivationDialog(BuildContext context, Motivation motivation) {
    _contentController.text = motivation.content;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Motivasi"),
          content: TextField(
            controller: _contentController,
            decoration: InputDecoration(hintText: "Ubah motivasi..."),
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
                String content = _contentController.text;
                if (content.isNotEmpty) {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateMotivationRemote(motivation.id, content);
                  _contentController.clear();
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
