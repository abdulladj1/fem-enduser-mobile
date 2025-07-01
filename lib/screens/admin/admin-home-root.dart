import 'package:flutter/material.dart';
import 'home.dart';
import 'scan.dart';
import 'profile.dart';

class AdminHomeRoot extends StatefulWidget {
  const AdminHomeRoot({super.key});

  @override
  State<AdminHomeRoot> createState() => _AdminHomeRootState();
}

class _AdminHomeRootState extends State<AdminHomeRoot> {
  int _selectedIndex = 0;

  final GlobalKey<AdminHomePageState> _homeKey = GlobalKey<AdminHomePageState>();

  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminHomePage(key: _homeKey),
      const SizedBox(),
      const AdminProfilePage(),
    ];

    return Scaffold(
      extendBody: true,
      body: pages[_selectedIndex == 1 ? 0 : _selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScanPage()),
          );
          if (result == true) {
            _homeKey.currentState?.refresh();
          }
        },
        tooltip: 'Scan Tiket',
        backgroundColor: const Color(0xFFF4F4F4),
        child: const Icon(Icons.qr_code_scanner),
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 8,
        currentIndex: _selectedIndex > 1 ? 1 : _selectedIndex,
        onTap: (index) {
          if (index == 1) return;
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
