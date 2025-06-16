import 'package:flutter/material.dart';
import 'payment.dart';

class TransactionDataPage extends StatelessWidget {
  const TransactionDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Beli Tiket'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                StepItem(label: 'Data\nTransaksi', active: true),
                StepItem(label: 'Pembayaran'),
                StepItem(label: 'Selesai'),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset('assets/images/banner-payment.png'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Detail Pembelian',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pertandingan Day 2'),
                  const SizedBox(height: 8),
                  const Text('19 April 2025'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.remove),
                          ),
                          const Text('1 TIKET'),
                          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                        ],
                      ),
                      const Text('Rp25.000,00'),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(),
                  ),
                );
              },
              child: const Text('Lanjutkan ke Pembayaran', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  final String label;
  final bool active;

  const StepItem({required this.label, this.active = false, super.key});

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.blue.shade900 : Colors.grey;
    return Column(
      children: [
        Icon(Icons.check_box, color: color),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: 12),
        ),
      ],
    );
  }
}
