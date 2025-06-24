import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'screens/auth/sign-in.dart';
// import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile IFL',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Lottie.asset(
        'assets/lottie/blue-ball.json',
        width: 120,
        height: 120,
      ),
    ),
  );
}
}