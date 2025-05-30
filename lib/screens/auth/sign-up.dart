import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'sign-in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> registerUser() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom harus diisi')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('${dotenv.env['API_BASE_URL']}/member/auth/register'); 

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 201) {
        // sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pendaftaran berhasil')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal daftar: ${error['message'] ?? 'Unknown error'}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                        'REGISTRASI',
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
                      'NAMA LENGKAP',
                      style: TextStyle(
                        fontFamily: 'SinkinSans',
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF00009C),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'masukkan nama lengkap',
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
                    const SizedBox(height: 20),
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
                        onPressed: isLoading ? null : registerUser,
                        child: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'DAFTAR',
                                style: TextStyle(
                                  fontFamily: 'SinkinSans',
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Wrap(
                        children: [
                          const Text(
                            'SUDAH MEMILIKI AKUN? ',
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
                                MaterialPageRoute(builder: (context) => const SignInPage()),
                              );
                            },
                            child: const Text(
                              'Login Di Sini',
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}