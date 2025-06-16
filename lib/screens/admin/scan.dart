import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../models/member.dart';
// import 'home.dart';
// import 'admin-home-root.dart';
import 'dart:convert';

class ScanPage extends StatefulWidget {
  final Function(Member member) onMemberScanned;

  // const ScanPage({super.key});
  const ScanPage({super.key, required this.onMemberScanned});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with TickerProviderStateMixin {
  String? scannedData;
  final MobileScannerController _controller = MobileScannerController();
  final PanelController _panelController = PanelController();
  List<Member> verifiedMembers = [];

  late AnimationController _lineController;
  Animation<double>? _lineAnimation;

  @override
  void initState() {
    super.initState();

    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _lineAnimation = CurvedAnimation(
      parent: _lineController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _lineController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _scanImageFromGallery() async {
    final status = await Permission.photos.request();
    final storageStatus = await Permission.storage.request();
    if (status.isGranted || storageStatus.isGranted) {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final result = await _controller.analyzeImage(image.path);
        // if (result != null && result.barcodes.isNotEmpty) {
        if (result.barcodes.isNotEmpty) {
          setState(() {
            scannedData = result.barcodes.first.rawValue;
          });
          _panelController.open();
        }
      }
    } else {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
        onDetect: (capture) {
          final barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final data = barcodes.first.rawValue;
            try {
              final Map<String, dynamic> jsonData = jsonDecode(data!);
              final member = Member.fromJson(jsonData);
              widget.onMemberScanned(member); // Kirim balik ke root
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Member berhasil diverifikasi")),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("QR tidak valid")),
              );
            }
          }
        },
      ),

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
                    _iconButton(Icons.image, _scanImageFromGallery),
                    _iconButton(Icons.flash_on, () {
                      _controller.toggleTorch();
                    }),
                  ],
                ),
              ],
            ),
          ),

          if (_lineAnimation != null)
            AnimatedBuilder(
              animation: _lineAnimation!,
              builder: (context, child) {
                final double start = -164;
                final double end = screenHeight + 164;
                final double top =
                    start + _lineAnimation!.value * (end - start);

                final bool isMovingUp =
                    _lineController.status == AnimationStatus.reverse;

                final double startFade = 200.0;
                final double endFade = screenHeight - 200.0;

                double fadeOpacity;

                if (top < startFade) {
                  fadeOpacity = (top / startFade).clamp(0.0, 1.0);
                } else if (top > endFade) {
                  fadeOpacity = ((screenHeight - top) / startFade).clamp(
                    0.0,
                    1.0,
                  );
                } else {
                  fadeOpacity = 1.0;
                }

                return Positioned(
                  top: top,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: fadeOpacity,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(isMovingUp ? 3.1416 : 0),
                      child: Image.asset(
                        'assets/images/ScanLine.png',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),

          SlidingUpPanel(
            controller: _panelController,
            minHeight: 120,
            maxHeight: 280,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            panel: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/pattern-3.png'),
                  fit: BoxFit.cover,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child:
                  scannedData == null
                      ? const Center(
                        child: Text(
                          "Arahkan kamera ke QR Code",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "DETAIL SCAN",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
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
                  style: TextStyle(
                    fontFamily: 'SinkinSans',
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D0D0D),
                    fontSize: 16,
                  ),
                ),
                const Text(
                  "01-01-2025",
                  style: TextStyle(
                    fontFamily: 'SinkinSans',
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0D0D0D),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

extension on bool {
  get barcodes => null;
}
