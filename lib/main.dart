import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vigenesia_flutter/screens/login_screen.dart';
import 'providers/user_provider.dart';
import 'screens/home_screen.dart';
import 'screens/motivation_screen.dart';
import 'screens/todo_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'Vigenesia Flutter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
        routes: {
          '/home': (context) => HomeScreen(),
          '/motivations': (context) => MotivationScreen(),
          '/todos': (context) => TodoScreen(),
          '/profile': (context) => ProfileScreen(),
          '/login': (context) => LoginScreen(),
        },
      ),
    );
  }
}
