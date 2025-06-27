import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ifl_mobile/models/season.dart' as modelSeason;
import 'package:ifl_mobile/models/ticket.dart';
import 'package:ifl_mobile/models/series.dart';
import 'package:ifl_mobile/services/season.dart';
import 'package:ifl_mobile/services/series.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'profile.dart';
import 'user-home-root.dart';

String _splitWords(String input) {
  final words = input.split(' ');
  return words.join('\n');
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  modelSeason.Season? activeSeason;
  List<Series> seriesList = [];
  Series? _nearestSeries;
  List<Match> nearestMatches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    fetchActiveSeason().then((season) {
      setState(() {
        activeSeason = season;
        isLoading = false;
      });
    });

    _loadSeries();
    _loadNearestSeries();
  }

  Future<void> _loadSeries() async {
    try {
      final fetched = await fetchSeries(
        status: 1,
        sort: 'startDate',
        dir: 'asc',
        seasonId: null,
      );

      List<Match> matches = [];
      if (fetched.isNotEmpty) {
        final Series nearest = fetched.first;
        for (final t in nearest.tickets ?? []) {
          matches.addAll(t.matchs);
        }
      }

      setState(() {
        seriesList = fetched;
        nearestMatches = matches;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadNearestSeries() async {
    try {
      final fetched = await fetchSeries(
        status: 1,
        sort: 'startDate',
        dir: 'asc',
        seasonId: null,
      );

      if (fetched.isNotEmpty) {
        final Series firstSeries = fetched.first;
        final matches = <Match>[
          for (final t in firstSeries.tickets ?? []) ...t.matchs,
        ];

        setState(() {
          _nearestSeries = firstSeries;
          nearestMatches = matches;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _matchCard(Match m, Ticket ticket) {
    final venueName = _nearestSeries?.venue.name ?? '';
    return Container(
      width: 380,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/pattern-5.png'),
          fit: BoxFit.cover,
        ),
        color: Color(0xFF00009C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Match ${ticket.name}',
                  style: const TextStyle(
                    fontFamily: 'SinkinSans',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00009C),
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                DateFormat(
                  'd MMMM yyyy',
                  'id_ID',
                ).format(ticket.date.toLocal()),
                style: const TextStyle(
                  fontFamily: 'SinkinSans',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _teamColumn(m.homeLogo, m.homeTeam),
              const SizedBox(width: 40),
              Text(
                'VS',
                style: TextStyle(
                  fontFamily: 'SinkinSans',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(width: 40),
              _teamColumn(m.awayLogo, m.awayTeam),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/Venue.png', fit: BoxFit.cover),
              SizedBox(width: 8),
              Text(
                venueName,
                style: const TextStyle(
                  fontFamily: 'SinkinSans',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// helper kecil untuk logo + nama
  Widget _teamColumn(String logo, String name) {
    bool isSvg(String url) => url.toLowerCase().endsWith('.svg');

    return Column(
      children: [
        isSvg(logo)
            ? SvgPicture.network(
              logo,
              width: 28,
              fit: BoxFit.contain,
              placeholderBuilder:
                  (context) => const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
            )
            : CachedNetworkImage(
              imageUrl: logo,
              width: 28,
              fit: BoxFit.contain,
              placeholder:
                  (_, __) => const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              errorWidget:
                  (_, __, ___) => const Icon(
                    Icons.broken_image,
                    size: 28,
                    color: Colors.grey,
                  ),
            ),
        const SizedBox(height: 8),
        SizedBox(
          width: 50,
          child: Text(
            _splitWords(name),
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontFamily: 'SinkinSans',
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 8,
            ),
          ),
        ),
      ],
    );
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: _scrollOffset > 204 ? Colors.white : Colors.transparent,
              border:
                  _scrollOffset > 204
                      ? const Border(
                        bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                      )
                      : const Border(
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
                    child:
                        _scrollOffset > 204
                            ? Image.asset(
                              'assets/images/PFL-Logo-Biru.png',
                              height: 32,
                            )
                            : Image.asset(
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
                              _scrollOffset > 204
                                  ? const Color(0xFF0027C1)
                                  : Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.person,
                          color:
                              _scrollOffset > 204
                                  ? const Color(0xFF0027C1)
                                  : Colors.white,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/soccer-ball-fill.png',
                          width: 20,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'PERTANDINGAN TERDEKAT',
                          style: TextStyle(
                            fontFamily: 'SinkinSans',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF00009C),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const UserHomeRoot(initialIndex: 1),
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
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            ' lihat semua',
                            style: TextStyle(
                              fontFamily: 'SinkinSans',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 8,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Image.asset(
                            'assets/icons/chevron-right-white.png',
                            width: 16,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 224,
                width: double.infinity,
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : (_nearestSeries == null || nearestMatches.isEmpty)
                        ? const Center(child: Text('Belum ada jadwal'))
                        : CarouselSlider(
                          options: CarouselOptions(
                            height: 284,
                            enableInfiniteScroll: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.82,
                            // autoPlay: true,
                            // autoPlayInterval: Duration(seconds: 4),
                            // autoPlayAnimationDuration: Duration(
                            //   milliseconds: 800,
                            // ),
                            // autoPlayCurve: Curves.easeInOut,
                          ),
                          items:
                              nearestMatches.map((m) {
                                final ticket = _nearestSeries?.tickets
                                    ?.firstWhereOrNull(
                                      (t) => t.matchs.contains(m),
                                    );
                                if (ticket == null) {
                                  return const SizedBox();
                                }
                                return _matchCard(m, ticket);
                              }).toList(),
                        ),
              ),

              // Series
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserHomeRoot(initialIndex: 1),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 8.0,
                  ),
                  height: 72,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/series-banner.png'),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
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
