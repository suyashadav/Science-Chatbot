import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'auth_service.dart';
import 'Sign-in.dart';
import 'resources_page.dart';
import 'chatbot_page.dart';
import 'quizzes_page.dart';
import 'profile_page.dart';
import 'subject.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<dynamic, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
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
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userData?['name'] ?? 'Loading...',
                style: const TextStyle(color: Colors.black),
              ),
              accountEmail: const Text(
                '', // Removed email display
                style: TextStyle(color: Colors.black),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFFBE4A7),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/avtar.png",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                "assets/images/home.png",
                width: 24,
                height: 24,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Image.asset(
                "assets/images/profile.png",
                width: 24,
                height: 24,
              ),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Image.asset(
                "assets/images/logout.png",
                width: 24,
                height: 24,
              ),
              title: const Text('Logout'),
              onTap: () async {
                await authService.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignINPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBE4A7),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: Image.asset(
                  'assets/images/menu-lines.png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Vidyarthi Saathi',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CircleAvatar(
              radius: 18,
              child: ClipOval(
                child: Image.asset(
                  "assets/images/avtar.png",
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: const Color(0xFFFBE4A7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/search-btn.png',
                    width: 20,
                    height: 20,
                  ),
                ),
                hintText: 'Science',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Result for ',
                    children: [
                      TextSpan(
                        text: '"Science"',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '1 FOUND',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SubjectPage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/science.png",
                          height: 150,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Science',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
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
            currentIndex: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/home-btn.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/home-btn.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/resource-btn.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/resource-btn.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/chatbot-btn.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/chatbot-btn.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/quiz-btn.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/quiz-btn.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/profile-btn.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/profile-btn.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: '',
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ResourcesPage()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatbotPage()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizzesPage()),
                  );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
