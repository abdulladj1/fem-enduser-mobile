import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/member.dart';

class AdminHomePage extends StatefulWidget {
  final List<Member> verifiedMembers;

  const AdminHomePage({super.key, required this.verifiedMembers});
  // const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 1)); // Simulasi fetch
    setState(() {
      // Di sini kamu bisa panggil API sesungguhnya atau ubah data state.
      // Misalnya: fetchVerifiedMembers()
    });
  }

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
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 216,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF0A0A39), Color(0xFF0D0D0D)],
                        ),
                        image: DecorationImage(
                          image: AssetImage('assets/images/pattern-5.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
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
                              Icon(Icons.person, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "${widget.verifiedMembers.length}",
                                style: TextStyle(
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

                widget.verifiedMembers.isEmpty
                    ? Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      alignment: Alignment.center,
                      child: Text(
                        "Belum Ada Data Penonton Yang Masuk",
                        style: TextStyle(
                          fontFamily: 'SinkinSans',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0D0D0D),
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                    : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.verifiedMembers.length,
                      itemBuilder: (context, index) {
                        final member = widget.verifiedMembers[index];
                        return AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: 1.0,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/pattern-3.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundImage: AssetImage(
                                    'assets/images/Profile.png',
                                  ),
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      member.email,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (member.phone != null)
                                      Text(
                                        member.phone!,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                  ],
                                ),
                              ],
                            ),
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
