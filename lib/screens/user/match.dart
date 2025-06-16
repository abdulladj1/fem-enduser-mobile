import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile.dart';
import 'purchase/transaction-data.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
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

  Brightness get _statusBarIconBrightness {
    return _scrollOffset > 40 ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          _statusBarIconBrightness == Brightness.dark
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
                      IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color:
                              _scrollOffset > 8
                                  ? const Color(0xFF0027C1)
                                  : const Color(0xFF0027C1),
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.person,
                          color:
                              _scrollOffset > 8
                                  ? const Color(0xFF0027C1)
                                  : const Color(0xFF0027C1),
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
              const SizedBox(height: 8),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0E5889), Color(0xFF0078FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Series ${index + 1}",
                                    style: const TextStyle(
                                      fontFamily: 'SinkinSans',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "${20 + index}-${21 + index} Apr 2025",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Rp.40.000",
                                    style: TextStyle(
                                      fontFamily: 'SinkinSans',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0027C1),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TransactionDataPage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Beli Tiket Bundling',
                                      style: TextStyle(
                                        fontFamily: 'SinkinSans',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent[700],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Match Day ${index + 1}",
                                          style: const TextStyle(
                                            fontFamily: 'SinkinSans',
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          "${20 + index}-${21 + index} Apr 2025",
                                          style: const TextStyle(
                                            fontFamily: 'SinkinSans',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Text(
                                            "Rp.40.000",
                                            style: TextStyle(
                                              fontFamily: 'SinkinSans',
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF0027C1,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 4,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {},
                                            child: const Text(
                                              'Beli Tiket',
                                              style: TextStyle(
                                                fontFamily: 'SinkinSans',
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "1${index*2}.00 WIB",
                                              style: const TextStyle(
                                                fontFamily: 'SinkinSans',
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF0027C1),
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              "Surakarta",
                                              style: const TextStyle(
                                                fontFamily: 'SinkinSans',
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF0027C1),
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 32),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Icon(
                                                    Icons.shield,
                                                    color: const Color(
                                                      0xFF767676,
                                                    ),
                                                    size: 32,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "Tim A",
                                                    style: const TextStyle(
                                                      fontFamily: 'SinkinSans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF767676),
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              CircleAvatar(
                                                radius: 16,
                                                backgroundColor: const Color(
                                                  0xFFDC2626,
                                                ),
                                                child: Text(
                                                  "Vs",
                                                  style: const TextStyle(
                                                      fontFamily: 'SinkinSans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Icon(
                                                    Icons.shield,
                                                    color: const Color(
                                                      0xFF767676,
                                                    ),
                                                    size: 32,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "Tim B",
                                                    style: const TextStyle(
                                                      fontFamily: 'SinkinSans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF767676),
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
