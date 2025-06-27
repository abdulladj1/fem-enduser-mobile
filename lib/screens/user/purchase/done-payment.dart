import 'package:flutter/material.dart';

class Step3Success extends StatelessWidget {
  const Step3Success({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: const [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Pembayaran Berhasil!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Tiket kamu sudah dikirim ke email.'),
        ],
      ),
    );
  }
}
