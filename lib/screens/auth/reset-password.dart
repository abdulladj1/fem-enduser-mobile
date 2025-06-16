import 'package:flutter/material.dart';
import 'sign-in.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/pattern-2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  'assets/images/PFL-Logo-Vertical-Biru.png',
                  height: 172,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'UBAH KATA SANDI',
                          style: TextStyle(
                            fontFamily: 'SinkinSans',
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF00009C),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'KATA SANDI BARU',
                        style: TextStyle(
                            fontFamily: 'SinkinSans',
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF00009C),
                            fontSize: 10,
                          ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'masukkan kata sandi baru',
                          hintStyle: TextStyle(
                            fontFamily: 'SinkinSans',
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF757575),
                            fontSize: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'KONFIRMASI KATA SANDI BARU',
                        style: TextStyle(
                          fontFamily: 'SinkinSans',
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF00009C),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'konfirmasi kata sandi baru',
                          hintStyle: TextStyle(
                            fontFamily: 'SinkinSans',
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF757575),
                            fontSize: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0027C1),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignInPage()),
                            );
                          },
                          child: const Text(
                            'KONFIRMASI',
                            style: TextStyle(
                              fontFamily: 'SinkinSans',
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFFFFFF),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
