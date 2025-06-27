import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/purchase.dart';

class Step1TransactionData extends StatelessWidget {
  const Step1TransactionData({
    super.key,
    required this.purchase,
    required this.onNext,
  });

  final PurchaseResponse purchase;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final t = purchase.tickets.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset('assets/images/banner-payment.png'),
        ),
        const SizedBox(height: 24),
        const Text(
          'Detail Pembelian',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(DateFormat('d MMMM yyyy', 'id_ID').format(t.date)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${purchase.amount} TIKET',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(purchase.grandTotal),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade900,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Lanjutkan ke Pembayaran',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
