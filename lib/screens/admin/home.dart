import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:ifl_mobile/models/ticket-purchase-lists.dart';
import 'package:ifl_mobile/models/ticket-purchases.dart';
import 'package:ifl_mobile/shared/utils/pref_helper.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  AdminHomePageState createState() => AdminHomePageState();
}

class AdminHomePageState extends State<AdminHomePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  void refresh() => _fetchVerifiedTickets();

  List<TicketPurchase> usedTickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
    _fetchVerifiedTickets();
  }

  Future<void> _fetchVerifiedTickets() async {
    final url = Uri.parse(
      '${dotenv.env['API_BASE_URL']}/admin/ticket-purchases/used-today',
    );
    final token = await PrefHelper().getToken();

    if (token == null) {
      print("Token not found.");
      return;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = TicketPurchaseListResponse.fromJson(jsonResponse);

        if (!mounted) return;
        setState(() {
          usedTickets = result.list;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        print("Failed to fetch tickets: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching tickets: $e");
    }
  }

  Future<void> _refreshData() async {
    await _fetchVerifiedTickets();
  }

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          _scrollOffset > 204
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // HEADER
                Stack(
                  children: [
                    Container(
                      height: 216,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF0A0A39), Color(0xFF0D0D0D)],
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/pattern-5.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Rekap Penonton",
                            style: TextStyle(
                              fontFamily: 'SinkinSans',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                "${usedTickets.length}",
                                style: const TextStyle(
                                  fontFamily: 'SinkinSans',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // CONTENT
                if (isLoading)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (usedTickets.isEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: const Center(
                      child: Text(
                        "Belum Ada Data Penonton Yang Masuk",
                        style: TextStyle(
                          fontFamily: 'SinkinSans',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0D0D0D),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: usedTickets.length,
                    itemBuilder: (context, index) {
                      final ticket = usedTickets[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/pattern-3.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 32,
                              backgroundImage: AssetImage(
                                'assets/images/Profile.png',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ticket.member.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  formatDate(ticket.usedAt),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
