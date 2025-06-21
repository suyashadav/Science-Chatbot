import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'auth_service.dart';
import 'Sign-in.dart';
import 'home.dart';
import 'resources_page.dart';
import 'chatbot_page.dart';
import 'quizzes_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<dynamic, dynamic>? userData;
  bool isLoading = true;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;
  final _newPasswordController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      if (user != null) {
        final snapshot = await _databaseRef.child('users/${user!.uid}').get();
        if (snapshot.exists) {
          setState(() {
            userData = snapshot.value as Map<dynamic, dynamic>;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  Future<void> _changePassword() async {
    try {
      if (_newPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a new password')),
        );
        return;
      }

      await _auth.currentUser?.updatePassword(_newPasswordController.text);
      _newPasswordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Password update failed';
      if (e.code == 'requires-recent-login') {
        errorMessage = 'Please re-authenticate to change password';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _signOut() async {
    try {
      // Option 1: Using authService (recommended)
      await authService.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SignINPage()),
        (route) => false,
      );

      // Option 2: Using FirebaseAuth directly (alternative)
      // await FirebaseAuth.instance.signOut();
      // Navigator.pushNamedAndRemoveUntil(
      //     context, '/login', (Route<dynamic> route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFFFBE4A7),
      ),
      backgroundColor: const Color(0xFFFBE4A7),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 30),
                  _buildProfileInfoCard(),
                  const SizedBox(height: 20),
                  _buildSettingsSection(),
                  const SizedBox(height: 20),
                  _buildLogoutButton(),
                  const SizedBox(height: 10),
                  _buildTermsText(),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.black54,
            currentIndex: 4,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/home1.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/home1.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/resource.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/resource.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Resource',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/bubble-chat.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/bubble-chat.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Chat-Bot',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/ideas.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/ideas.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Quiz',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/user.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/user.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                // break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResourcesPage()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatbotPage()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QuizzesPage()),
                  );
                  break;
                case 4:
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const ProfilePage()),
                  // );
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.teal[800],
            child: const Icon(
              Icons.person,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            userData?['name'] ?? 'No Name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Center(
          child: Text(
            user?.email ?? 'No Email',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileItem('Full Name', userData?['name'] ?? 'Not provided'),
            const Divider(height: 20, color: Colors.grey),
            _buildProfileItem('Email', user?.email ?? 'Not provided'),
            const Divider(height: 20, color: Colors.grey),
            _buildProfileItem('Mobile', userData?['mobile'] ?? 'Not provided'),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onTap: _showChangePasswordDialog,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal[800],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _signOut,
        child: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    return const Center(
      child: Text(
        'Terms & conditions apply*',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          backgroundColor: Colors.white,
          content: TextField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password',
              labelStyle: TextStyle(
                color: Colors.black54,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
            ),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _changePassword();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[800],
              ),
              child: const Text(
                'Update',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
