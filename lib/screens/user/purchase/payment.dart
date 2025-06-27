import 'package:flutter/material.dart';
import 'package:ifl_mobile/models/purchase.dart';

class Step2Payment extends StatelessWidget {
  final VoidCallback onNext;

  const Step2Payment({
    super.key,
    required this.onNext,
    required PurchaseResponse purchase,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Metode Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Tambahkan pilihan pembayaran di sini
        const ListTile(
          leading: Icon(Icons.credit_card),
          title: Text('Kartu Kredit'),
        ),
        const ListTile(
          leading: Icon(Icons.account_balance_wallet),
          title: Text('E-Wallet'),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: onNext,
          child: const Text('Lanjutkan ke Selesai'),
        ),
      ],
    );
  }
}
