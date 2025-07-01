import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
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

  Brightness get _statusBarIconBrightness {
    return _scrollOffset > 40 ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusBarIconBrightness == Brightness.dark
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: _scrollOffset > 8 ? Colors.white : Colors.white,
              border: const Border(
                bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset(
                      'assets/images/PFL-Logo-Biru.png',
                      height: 32,
                    ),
                  ),
                  Row(
                    children: [
                      // IconButton(
                      //   icon: Icon(Icons.notifications,
                      //       color: _scrollOffset > 40 ? const Color(0xFF0027C1) : const Color(0xFF0027C1)),
                      //   onPressed: () {},
                      // ),
                      IconButton(
                        icon: Icon(Icons.person,
                            color: _scrollOffset > 40 ? const Color(0xFF0027C1) : const Color(0xFF0027C1)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProfilePage()),
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            controller: _scrollController,
            children: [
              TicketCard(
                title: "MATCH DAY 1",
                date: "19 April 2025",
                location: "Surakarta",
                status: "Selesai",
                qrAsset: "assets/images/qr-ticket.png",
              ),
              TicketCard(
                title: "MATCH DAY 2",
                date: "20 April 2025",
                location: "Surakarta",
                status: "Belum Digunakan",
                qrAsset: "assets/images/qr-ticket.png",
              ),
              TicketCard(
                title: "MATCH DAY 3",
                date: "26 April 2025",
                location: "Surakarta",
                status: "Belum Digunakan",
                qrAsset: "assets/images/qr-ticket.png",
              ),
              TicketCard(
                title: "MATCH DAY 2",
                date: "20 April 2025",
                location: "Surakarta",
                status: "Belum Digunakan",
                qrAsset: "assets/images/qr-ticket.png",
              ),
              TicketCard(
                title: "MATCH DAY 3",
                date: "26 April 2025",
                location: "Surakarta",
                status: "Belum Digunakan",
                qrAsset: "assets/images/qr-ticket.png",
              ),
              TicketCard(
                title: "MATCH DAY 2",
                date: "20 April 2025",
                location: "Surakarta",
                status: "Belum Digunakan",
                qrAsset: "assets/images/qr-ticket.png",
              ),
              TicketCard(
                title: "MATCH DAY 3",
                date: "26 April 2025",
                location: "Surakarta",
                status: "Belum Digunakan",
                qrAsset: "assets/images/qr-ticket.png",
              ),
              TicketCard(
                title: "MATCH DAY 2",
                date: "20 April 2025",
                location: "Surakarta",
                status: "Belum Digunakan",
                qrAsset: "assets/images/qr-ticket.png",
              ),
              TicketCard(
                title: "MATCH DAY 3",
                date: "26 April 2025",
                location: "Surakarta",
                status: "Belum Digunakan",
                qrAsset: "assets/images/qr-ticket.png",
              ),
            ],
          ),
        ),
      )
    );
  }
}

class TicketCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String status;
  final String qrAsset;

  const TicketCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.status,
    required this.qrAsset,
  });

  @override
  Widget build(BuildContext context) {
    final isUsed = status == 'Selesai';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Image.asset(qrAsset, width: 70, height: 70),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF00009C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(date),
                Text(location),
              ],
            ),
          ),
          Text(
            status,
            style: TextStyle(
              color: isUsed ? Colors.grey : const Color(0xFF00009C),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
