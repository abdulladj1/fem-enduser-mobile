import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'home.dart';
import 'scan.dart';
import 'profile.dart';
import '../../models/member.dart';

class AdminHomeRoot extends StatefulWidget {
  const AdminHomeRoot({super.key});

  @override
  State<AdminHomeRoot> createState() => _AdminHomeRootState();
}

class _AdminHomeRootState extends State<AdminHomeRoot> {
  int _selectedIndex = 0;

  List<Member> verifiedMembers = [];

  void addVerifiedMember(Member member) {
    final exists = verifiedMembers.any((m) => m.id == member.id);
    if (!exists) {
      setState(() {
        verifiedMembers.add(member);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminHomePage(verifiedMembers: verifiedMembers),
      ScanPage(onMemberScanned: addVerifiedMember),
      AdminProfilePage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

