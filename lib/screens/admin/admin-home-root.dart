import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'scan.dart';
import 'profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AdminHomeRoot(),
    );
  }
}
class AdminHomeRoot extends StatefulWidget {
  final int initialIndex;
  const AdminHomeRoot({super.key, this.initialIndex = 0});

  @override
  _AdminHomeRootState createState() => _AdminHomeRootState();
}

class _AdminHomeRootState extends State<AdminHomeRoot> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    AdminHomePage(),
    ScanPage(),
    AdminProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, 
        selectedItemColor: const Color(0xFF00009C),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;   
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
