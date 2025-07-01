import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ifl_mobile/models/ticket-purchases.dart';
import 'package:ifl_mobile/shared/utils/pref_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with TickerProviderStateMixin {
  String? scannedData;
  TicketPurchase? scannedTicket;
  bool isProcessing = false;

  final MobileScannerController _controller = MobileScannerController();
  final PanelController _panelController = PanelController();

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
        if (result.barcodes.isNotEmpty) {
          final code = result.barcodes.first.rawValue;
          if (code != null) {
            setState(() {
              scannedData = code;
            });
            _panelController.open();
            _verifyTicket(code);
          }
        }
      }
    } else {
      openAppSettings();
    }
  }

  Future<void> _verifyTicket(String code) async {
    final url = Uri.parse(
      '${dotenv.env['API_BASE_URL']}/admin/ticket-purchases/scan',
    );
    final token = await PrefHelper().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? '',
        },
        body: jsonEncode({'code': code}),
      );

      final Map<String, dynamic> json = jsonDecode(response.body);
      final TicketPurchaseResponse resp = TicketPurchaseResponse.fromJson(json);

      if (response.statusCode == 200) {
        setState(() {
          scannedTicket = resp.data;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Scan berhasil!")));
      } else {
        _showError(resp.message);
      }
    } catch (e) {
      _showError("Terjadi kesalahan: $e");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (isProcessing) return;

              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final code = barcodes.first.rawValue;
                if (code != null) {
                  setState(() {
                    scannedData = code;
                    isProcessing = true;
                  });
                  _panelController.open();
                  _verifyTicket(code).whenComplete(() {
                    setState(() {
                      isProcessing = false;
                    });
                  });
                }
              }
            },
          ),

          // AppBar Button
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

          // Scan Line
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

          // Sliding Panel
          SlidingUpPanel(
            controller: _panelController,
            minHeight: 120,
            maxHeight: 300,
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
                  scannedTicket == null
                      ? const Center(
                        child: Text(
                          "Arahkan kamera ke QR Code",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                      : _scanResultWidget(scannedTicket!),
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

  Widget _scanResultWidget(TicketPurchase t) {
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
          "DETAIL TIKET",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFFEDF1FF),
              child: Icon(
                Icons.confirmation_number,
                size: 28,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.member.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    t.venue.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Tanggal: ${formatDate(t.usedAt)}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }
}

extension on bool {
  get barcodes => null;
}
