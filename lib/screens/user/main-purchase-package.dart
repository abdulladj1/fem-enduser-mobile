import 'package:flutter/material.dart';
import 'package:ifl_mobile/models/purchase.dart';
import 'package:ifl_mobile/constants/purchase-type.dart';
import 'package:ifl_mobile/services/purchase.dart';
import 'package:ifl_mobile/widgets/step-indicator.dart';
import 'package:ifl_mobile/shared/utils/pref_helper.dart';
import 'purchase/transaction-data.dart';
import 'purchase/payment.dart';
import 'purchase/done-payment.dart';

class MainPurchasePage extends StatefulWidget {
  const MainPurchasePage({
    super.key,
    required this.purchaseType,
    required this.targetId,
  });

  final PurchaseType purchaseType;
  final String targetId;

  @override
  State<MainPurchasePage> createState() => _MainPurchasePageState();
}

class _MainPurchasePageState extends State<MainPurchasePage> {
  late Future<PurchaseResponse> _future;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _future = _loadPurchase();
  }

  Future<PurchaseResponse> _loadPurchase() async {
    final token = await PrefHelper().getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    return PurchaseService().createPurchase(
      widget.purchaseType,
      widget.targetId,
      token: token,
    );
  }

  void _nextStep() => setState(() => _currentStep++);

  Widget _stepContent(PurchaseResponse purchase) {
    switch (_currentStep) {
      case 0:
        return Step1TransactionData(purchase: purchase, onNext: _nextStep);
      case 1:
        return Step2Payment(purchase: purchase, onNext: _nextStep);
      default:
        return const Step3Success();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beli Tiket')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<PurchaseResponse>(
          future: _future,
          builder: (_, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('Error: ${snap.error}'));
            }

            final purchase = snap.data!;
            return Column(
              children: [
                StepIndicator(currentStep: _currentStep),
                const SizedBox(height: 16),
                Expanded(child: _stepContent(purchase)),
              ],
            );
          },
        ),
      ),
    );
  }
}
