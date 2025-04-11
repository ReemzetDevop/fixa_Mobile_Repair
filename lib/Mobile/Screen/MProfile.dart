
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../Model/UserModel.dart';
import '../../Services/UserRepo.dart';
import 'MBookingList.dart';

class Mprofile extends StatefulWidget {
  const Mprofile({super.key});

  @override
  State<Mprofile> createState() => _MprofileState();
}

class _MprofileState extends State<Mprofile> {
  UserModel? user;
  bool isLoading = true;
  String errorMessage = '';

  Future<void> fetchUser() async {
    try {
      final fetchedUser = await UserRepository().getUserData();
      setState(() {
        user = fetchedUser;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load user data';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Picture
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: Lottie.network(
                  'https://lottie.host/015f130b-177a-45f3-a8ba-b57c338ad22d/aIc3hgu9ki.json',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 120),
                  frameBuilder: (context, child, composition) {
                    if (composition == null) {
                      return const CircularProgressIndicator();
                    }
                    return child;
                  },
                ),
              ),
            ),
          ),
          // User Details
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (errorMessage.isNotEmpty)
            Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          else if (user != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      user!.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user!.userPhone,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
          const SizedBox(height: 20),
          // Options List
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildOptionItem('My Cart', Icons.shopping_cart),
              const Divider(),
              _buildOptionItem('My Order', Icons.history),
              const Divider(),
              _buildOptionItem('Logout', Icons.exit_to_app),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to create list items
  Widget _buildOptionItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      onTap: () {
        if (title == 'Logout') {
          _showLogoutDialog();
        } else if (title == 'My Order') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>MBookingScreen()),
          );
        }
        else if (title == 'My Cart') {

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title clicked')),
          );
        }
      },
    );
  }

  // Logout Confirmation Dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
