import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'match.dart';
import 'ticket.dart';

class UserHomeRoot extends StatefulWidget {
  final int initialIndex;
  const UserHomeRoot({super.key, this.initialIndex = 0});

  @override
  _UserHomeRootState createState() => _UserHomeRootState();
}

class _UserHomeRootState extends State<UserHomeRoot> {
  late int _currentIndex;
  // late Season _activeSeason;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    HomePage(),
    MatchPage(),
    TicketPage(),
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
            label: 'Pertandingan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Tiket',
          ),
        ],
      ),
    );
  }
}
