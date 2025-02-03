import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vigenesia_flutter/widgets/sidebar.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userProfile = Provider.of<UserProvider>(context, listen: false).userProfile;
    _usernameController.text = userProfile.username;
    _emailController.text = userProfile.email;
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProvider>(context).userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Sidebar(), // Sidebar untuk navigasi di semua screen
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/profilebackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/images/logo.png'), // Logo Hololive
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(userProfile.avatar),
              ),
              const SizedBox(height: 16),
              // Form untuk mengubah profil
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final newUsername = _usernameController.text;
                  final newEmail = _emailController.text;

                  // Update Profile dengan data baru
                  Provider.of<UserProvider>(context, listen: false)
                      .updateProfileRemote(newUsername, newEmail, userProfile.avatar);

                  // Menampilkan snackbar sebagai konfirmasi
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil berhasil diperbarui')),
                  );
                },
                child: const Text('Update Profile'),
              ),
              const SizedBox(height: 16),
              // Tombol untuk mengganti avatar
              ElevatedButton(
                onPressed: () {
                  _showAvatarSelectionDialog(context);
                },
                child: const Text('Ganti Avatar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog memilih avatar
  void _showAvatarSelectionDialog(BuildContext context) {
    final userProfile = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Avatar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAvatarSelectionOption(context, 'avatar1', userProfile),
              _buildAvatarSelectionOption(context, 'avatar2', userProfile),
              _buildAvatarSelectionOption(context, 'avatar3', userProfile),
              _buildAvatarSelectionOption(context, 'avatar4', userProfile),
              _buildAvatarSelectionOption(context, 'avatar5', userProfile),
            ],
          ),
        );
      },
    );
  }

  // Fungsi untuk menampilkan pilihan avatar
  Widget _buildAvatarSelectionOption(BuildContext context, String avatarName, UserProvider userProfile) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/avatar/$avatarName.jpg'),
      ),
      title: Text('Avatar $avatarName'),
      onTap: () {
        // Update avatar user
        Provider.of<UserProvider>(context, listen: false)
            .updateProfileRemote(userProfile.userProfile.username, userProfile.userProfile.email, 'assets/avatar/$avatarName.jpg');
        Navigator.pop(context); // Close dialog
      },
    );
  }
}
