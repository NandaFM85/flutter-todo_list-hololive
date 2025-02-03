import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProvider>(context).userProfile;

    return Drawer(
      child: Column(
        children: [
          // User Profile Image and Name
          UserAccountsDrawerHeader(
            accountName: Text(userProfile.username),
            accountEmail: Text(userProfile.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(userProfile.avatar),
            ),
          ),
          // Sidebar menu options
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Logika untuk logout, bisa membersihkan sesi atau menggunakan Navigator untuk kembali ke layar login.
              Navigator.pushReplacementNamed(context, '/login'); // Ganti dengan rute layar login
            },
          ),
        ],
      ),
    );
  }
}
