import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:ifl_mobile/models/series.dart';
import 'profile.dart';
import 'main-purchase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/purchase-type.dart';

String formatRange(DateTime start, DateTime end) {
  final bulanSama = start.month == end.month && start.year == end.year;

  if (bulanSama) {
    return '${start.day} - ${end.day} '
        '${DateFormat('MMM yyyy', 'id_ID').format(end)}';
  } else {
    return '${DateFormat('d MMM', 'id_ID').format(start)} - '
        '${DateFormat('d MMM yyyy', 'id_ID').format(end)}';
  }
}

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController();
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 2,
  );
  // late AnimationController _lottieController;
  double _scrollOffset = 0.0;
  List<Series> seriesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // _lottieController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 1000),
    // );

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    fetchSeries(status: 1, sort: "startDate", dir: "asc", seasonId: null).then((
      fetched,
    ) {
      setState(() {
        seriesList = fetched.toList();
        print('Series fetched: ${seriesList.length}');
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    // _lottieController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<Series>> fetchSeries({
    int? status,
    String? seasonId,
    String? sort,
    String? dir,
  }) async {
    final queryParams = <String, String>{};

    if (status != null) queryParams['status'] = status.toString();
    if (seasonId != null) queryParams['seasonId'] = seasonId;
    if (sort != null) queryParams['sort'] = sort;
    if (dir != null) queryParams['dir'] = dir;

    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    final uri = Uri.parse(
      '$baseUrl/member/series/with-tickets',
    ).replace(queryParameters: queryParams);

    final responseSeries = await http.get(uri);

    if (responseSeries.statusCode == 200) {
      final data = json.decode(responseSeries.body);
      final list = data['data']['list'] as List;
      return list.map((json) => Series.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load series');
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedSeries = await fetchSeries(
        status: 1,
        sort: "startDate",
        dir: "asc",
        seasonId: null,
      );

      setState(() {
        seriesList = fetchedSeries;
      });
    } catch (e) {
      // ignore: avoid_print
      print("Refresh error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  onRefresh: () async {
                    await _handleRefresh();
                    _refreshController.refreshCompleted();
                  },
                  header: CustomHeader(
                    height: 100,
                    builder: (context, mode) {
                      return Center(
                        child: Transform.translate(
                          offset: const Offset(0, 40),
                          child: Lottie.asset(
                            'assets/lottie/blue-ball.json',
                            width: 48,
                            height: 48,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                  child:
                      (seriesList.isEmpty)
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/package-open.png',
                                  width: 80,
                                  height: 80,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Belum ada jadwal pertandingan',
                                  style: TextStyle(
                                    fontFamily: 'SinkinSans',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF00009C),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(top: 80),
                            itemCount: seriesList.length,
                            itemBuilder: (context, index) {
                              final series = seriesList[index];
                              final seriesTickets = series.tickets ?? [];
                              // final Ticket? ticket =
                              //     seriesTickets.isNotEmpty
                              //         ? seriesTickets.first
                              //         : null;

                              //                             debugPrint(
                              //     'Series "${series.name}" → tickets: ${seriesTickets.length}, '
                              //     'matchs: ${ticket?.matchs.length ?? 0}'
                              //   );
                              //   debugPrint('Series ID: ${series.id}');
                              // for (var t in tickets) {
                              //   debugPrint('Ticket seriesId: ${t.seriesId}');
                              // }

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0E5889),
                                      Color(0xFF0078FF),
                                    ],
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                series.name,
                                                style: const TextStyle(
                                                  fontFamily: 'SinkinSans',
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                formatRange(
                                                  series.startDate.toLocal(),
                                                  series.endDate.toLocal(),
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                formatter.format(series.price),
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
                                                  backgroundColor: const Color(
                                                    0xFF0027C1,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                        horizontal: 20,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (_) =>
                                                              MainPurchasePage(
                                                                purchaseType:
                                                                    PurchaseType
                                                                        .ticket,
                                                                targetId:
                                                                    series.id,
                                                              ),
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
                                    ListView.separated(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      separatorBuilder:
                                          (context, index) =>
                                              const SizedBox(height: 16),
                                      itemCount: seriesTickets.length,
                                      itemBuilder: (context, ticketIndex) {
                                        final ticket =
                                            seriesTickets[ticketIndex];
                                        final matchTickets = ticket.matchs;
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFF113C),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(16),
                                                        topRight:
                                                            Radius.circular(16),
                                                      ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Match ${ticket.name}',
                                                          style: const TextStyle(
                                                            fontFamily:
                                                                'SinkinSans',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                            'd MMMM yyyy',
                                                            'id_ID',
                                                          ).format(
                                                            ticket.date
                                                                .toLocal(),
                                                          ),
                                                          style: const TextStyle(
                                                            fontFamily:
                                                                'SinkinSans',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            formatter.format(
                                                              ticket.price,
                                                            ),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'SinkinSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 16,
                                                          ),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                    0xFF0027C1,
                                                                  ),
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        4,
                                                                  ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (
                                                                        _,
                                                                      ) => MainPurchasePage(
                                                                        purchaseType:
                                                                            PurchaseType.ticket,
                                                                        targetId:
                                                                            ticket.id,
                                                                      ),
                                                                ),
                                                              );
                                                            },
                                                            child: const Text(
                                                              'Beli Tiket',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'SinkinSans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    Colors
                                                                        .white,
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
                                              isLoading
                                                  ? const CircularProgressIndicator()
                                                  : ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        matchTickets.length,
                                                    itemBuilder: (
                                                      context,
                                                      matchIndex,
                                                    ) {
                                                      final m =
                                                          matchTickets[matchIndex];
                                                      return Container(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        padding:
                                                            const EdgeInsets.all(
                                                              20,
                                                            ),
                                                        child: Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${m.time} WIB',
                                                                  style: const TextStyle(
                                                                    fontFamily:
                                                                        'SinkinSans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Color(
                                                                      0xFF0027C1,
                                                                    ),
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 12,
                                                                ),
                                                                Text(
                                                                  series
                                                                      .venue
                                                                      .name,
                                                                  style: const TextStyle(
                                                                    fontFamily:
                                                                        'SinkinSans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color(
                                                                      0xFF0027C1,
                                                                    ),
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              width: 32,
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                            m.homeLogo,
                                                                        width:
                                                                            28,
                                                                        fit:
                                                                            BoxFit.contain,
                                                                        placeholder:
                                                                            (
                                                                              context,
                                                                              url,
                                                                            ) => const SizedBox(
                                                                              width:
                                                                                  28,
                                                                              height:
                                                                                  28,
                                                                              child: CircularProgressIndicator(
                                                                                strokeWidth:
                                                                                    2,
                                                                              ),
                                                                            ),
                                                                        errorWidget:
                                                                            (
                                                                              context,
                                                                              url,
                                                                              error,
                                                                            ) => const Icon(
                                                                              Icons.broken_image,
                                                                              size:
                                                                                  28,
                                                                              color:
                                                                                  Colors.grey,
                                                                            ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            50,
                                                                        child: Text(
                                                                          m.homeTeam,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: const TextStyle(
                                                                            fontFamily:
                                                                                'SinkinSans',
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Color(
                                                                              0xFF767676,
                                                                            ),
                                                                            fontSize:
                                                                                10,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  CircleAvatar(
                                                                    radius: 16,
                                                                    backgroundColor:
                                                                        const Color(
                                                                          0xFFDC2626,
                                                                        ),
                                                                    child: Text(
                                                                      "Vs",
                                                                      style: const TextStyle(
                                                                        fontFamily:
                                                                            'SinkinSans',
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color:
                                                                            Colors.white,
                                                                        fontSize:
                                                                            8,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                            m.awayLogo,
                                                                        width:
                                                                            28,
                                                                        fit:
                                                                            BoxFit.contain,
                                                                        placeholder:
                                                                            (
                                                                              context,
                                                                              url,
                                                                            ) => const SizedBox(
                                                                              width:
                                                                                  28,
                                                                              height:
                                                                                  28,
                                                                              child: CircularProgressIndicator(
                                                                                strokeWidth:
                                                                                    2,
                                                                              ),
                                                                            ),
                                                                        errorWidget:
                                                                            (
                                                                              context,
                                                                              url,
                                                                              error,
                                                                            ) => const Icon(
                                                                              Icons.broken_image,
                                                                              size:
                                                                                  28,
                                                                              color:
                                                                                  Colors.grey,
                                                                            ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            50,
                                                                        child: Text(
                                                                          m.awayTeam,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: const TextStyle(
                                                                            fontFamily:
                                                                                'SinkinSans',
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Color(
                                                                              0xFF767676,
                                                                            ),
                                                                            fontSize:
                                                                                10,
                                                                          ),
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
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                ),
      ),
    );
  }
}
