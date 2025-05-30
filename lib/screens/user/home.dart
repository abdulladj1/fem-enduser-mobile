import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile.dart';
import 'user-home-root.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Color get _appBarColor {
  //   if (_scrollOffset > 40) {
  //     return Colors.white;
  //   } else {
  //     return Colors.transparent;
  //   }
  // }

  // Brightness get _statusBarIconBrightness {
  //   return _scrollOffset > 40 ? Brightness.dark : Brightness.light;
  // }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          // _statusBarIconBrightness == Brightness.dark
          //     ? SystemUiOverlayStyle.dark
          //     : SystemUiOverlayStyle.light,
              _scrollOffset > 204 ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: _scrollOffset > 204 ? Colors.white : Colors.transparent,
              border: _scrollOffset > 204 ? const Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)) : const Border(
                bottom: BorderSide(color: Colors.transparent, width: 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _scrollOffset > 204 ? Image.asset('assets/images/PFL-Logo-Biru.png', height: 32) : Image.asset(
                      'assets/images/PFL-Logo-Putih.png',
                      height: 32,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color:
                              _scrollOffset > 204 ? const Color(0xFF0027C1) : Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.person,
                          color:
                              _scrollOffset > 204 ? const Color(0xFF0027C1) : Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/comingsoon.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Pertandingan Terdekat
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/soccer-ball-fill.png',
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "PERTANDINGAN TERDEKAT",
                      style: TextStyle(
                        fontFamily: 'SinkinSans',
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00009C),
                        fontSize: 12,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const UserHomeRoot(initialIndex: 1),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF00009C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "lihat semua",
                            style: TextStyle(
                              fontFamily: 'SinkinSans',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFFFF),
                              fontSize: 8,
                            ),
                          ),
                          SizedBox(width: 2),
                          Image.asset(
                            'assets/icons/chevron-right-white.png',
                            width: 16,
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 12.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: 8.0,
                ),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF00009C),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text("Match Day 1", style: TextStyle(color: Colors.white)),
                    Text(
                      "19 April 2025",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.shield, color: Colors.white),
                            Text(
                              "Tim A",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Text("VS", style: TextStyle(color: Colors.white)),
                        Column(
                          children: [
                            Icon(Icons.shield, color: Colors.white),
                            Text(
                              "Tim B",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text("SURAKARTA", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),

              // Series
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.confirmation_number,
                      color: const Color(0xFF00009C),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "SERIES",
                      style: TextStyle(
                        fontFamily: 'SinkinSans',
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00009C),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 8.0,
                ),
                height: 72,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/series-banner.png'),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              // Voting
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(Icons.emoji_events, color: const Color(0xFF00009C)),
                    SizedBox(width: 4),
                    Text(
                      "VOTING",
                      style: TextStyle(
                        fontFamily: 'SinkinSans',
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00009C),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 184,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/voting-banner.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 8),

              // Team
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(Icons.emoji_events, color: const Color(0xFF00009C)),
                    SizedBox(width: 4),
                    Text(
                      "PFL TEAM & LINE UP",
                      style: TextStyle(
                        fontFamily: 'SinkinSans',
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00009C),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 184,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/team-banner.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
