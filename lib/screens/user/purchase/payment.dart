import 'package:flutter/material.dart';
import 'done-payment.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Beli Tiket'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                StepItem(label: 'Data\nTransaksi', active: true),
                StepItem(label: 'Pembayaran', active: true),
                StepItem(label: 'Selesai'),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Silakan selesaikan pembayaran Anda untuk mendapatkan e-tiket',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Menunggu Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Text('Detail Pemesanan'),
                    Text('Nomor Faktur\n: pfl-10162-7607'),
                    Text('Tanggal Pemesanan\n: 1 Mei 2025'),
                    SizedBox(height: 12),
                    Text('Detail Pembelian'),
                    Text('Tiket Pertandingan Day 2\nRp25.000,00'),
                    Text('Biaya Admin\nRp2.500,00'),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Harga Total'),
                        Text('Rp27.500,00', style: TextStyle(color: Colors.blue))
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade900),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DonePaymentPage(),
                  ),
                );
              },
              child: const Text('Buka Link Pembayaran', style: TextStyle(color: Colors.white)),
            )
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
    final color = active ? Colors.green : Colors.grey;
    return Column(
      children: [
        Icon(Icons.check_box, color: color),
        Text(label, textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
