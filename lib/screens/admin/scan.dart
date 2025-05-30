import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String? scannedData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Scanner
          MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.normal,
              facing: CameraFacing.back,
              torchEnabled: false,
            ),
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && scannedData == null) {
                setState(() {
                  scannedData = barcodes.first.rawValue;
                });
              }
            },
          ),

          // Tombol overlay
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconButton(Icons.arrow_back, () => Navigator.pop(context)),
                Row(
                  children: [
                    _iconButton(Icons.help_outline, () {}),
                    _iconButton(Icons.image, () {}),
                    _iconButton(Icons.flash_on, () {
                      MobileScannerController().toggleTorch();
                    }),
                  ],
                )
              ],
            ),
          ),

          // Hasil Scan
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: scannedData == null
                  ? const Text("Arahkan kamera ke QR Code",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
                  : _scanResultWidget(scannedData!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(icon, color: Colors.indigo),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _scanResultWidget(String result) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("DETAIL SCAN",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFFEDF1FF),
              child: Icon(Icons.person, size: 28, color: Colors.indigo),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Text("01-01-2025", style: TextStyle(color: Colors.grey)),
              ],
            )
          ],
        ),
      ],
    );
  }
}
