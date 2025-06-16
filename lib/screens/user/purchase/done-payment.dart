import 'package:flutter/material.dart';

class DonePaymentPage extends StatelessWidget {
  const DonePaymentPage({super.key});

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
                StepItem(label: 'Selesai', active: true),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'e-tiket telah dikirimkan ke email\nmarselino11@gmail.com',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green),
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
                    Text('Pembayaran Berhasil', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Text('Detail Pemesanan'),
                    Text('Nomor Faktur\n: pfl-10162-7607'),
                    Text('Tanggal Pemesanan\n: 1 Mei 2025'),
                    SizedBox(height: 12),
                    Text('Detail Pembayaran'),
                    Text('Bank Pembayaran\nMandiri'),
                    Text('Atasnama e-wallet\nMarselino Ferdinan'),
                    Text('Nomor e-wallet\n12345634245')
                  ],
                ),
              ),
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
    final color = active ? Colors.blue : Colors.grey;
    return Column(
      children: [
        Icon(Icons.check_box, color: color),
        Text(label, textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
