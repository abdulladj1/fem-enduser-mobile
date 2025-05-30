import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:ifl_mobile/shared/utils/pref_helper.dart';
import 'dart:convert';
import 'sign-up.dart';
import 'forgot-password.dart';
import '../admin/admin-home-root.dart';
import '../user/user-home-root.dart';
// import '../admin/scan.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    final Map<String, String> adminBody = {
      'username': email,
      'password': password,
    };

    final Map<String, String> userBody = {
      'email': email,
      'password': password,
    };

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan kata sandi wajib diisi')),
      );
      return;
    }

    final isAdmin = email.startsWith('ADM_');
    final String endpoint = isAdmin ? 'admin/auth/login' : 'member/auth/login';
    final url = Uri.parse('${dotenv.env['API_BASE_URL']}/$endpoint');

    if (!isAdmin) {
      if (!email.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email tidak valid')),
        );
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(isAdmin ? adminBody : userBody),
      );

      setState(() {
        isLoading = false;
      });

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final String token;

      if (response.statusCode == 200) {
        token = jsonResponse['data']['token']; 

        await PrefHelper().saveToken(token);

        late Widget targetPage;

        if (isAdmin) {
          targetPage = const AdminHomeRoot();
        } else {
          targetPage = const UserHomeRoot();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['message'])),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.06),
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
                          'SELAMAT DATANG!',
                          style: TextStyle(
                            fontFamily: 'SinkinSans',
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF00009C),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'EMAIL',
                        style: TextStyle(
                          fontFamily: 'SinkinSans',
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF00009C),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'masukkan email',
                          hintStyle: const TextStyle(
                            fontFamily: 'SinkinSans',
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF757575),
                            fontSize: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'KATA SANDI',
                        style: TextStyle(
                          fontFamily: 'SinkinSans',
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF00009C),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'masukkan kata sandi',
                          hintStyle: const TextStyle(
                            fontFamily: 'SinkinSans',
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF757575),
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
                          onPressed: isLoading ? null : () => login(context),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text(
                                    'MASUK',
                                    style: TextStyle(
                                      fontFamily: 'SinkinSans',
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Lupa Kata Sandi?',
                            style: TextStyle(
                              fontFamily: 'SinkinSans',
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF00009C),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Wrap(
                          children: [
                            const Text(
                              'BELUM MEMILIKI AKUN? ',
                              style: TextStyle(
                                fontFamily: 'SinkinSans',
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF00009C),
                                fontSize: 10,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Registrasi Di Sini',
                                style: TextStyle(
                                  fontFamily: 'SinkinSans',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF00009C),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
