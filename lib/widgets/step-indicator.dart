import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;

  const StepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'label': 'Data Transaksi',
        'sub': 'Informasi pemesanan',
        'icon': Icons.event_note,
      },
      {
        'label': 'Pembayaran',
        'sub': 'Informasi pembayaran',
        'icon': Icons.payment,
      },
      {
        'label': 'Selesai',
        'sub': 'Informasi transaksi',
        'icon': Icons.check_circle_outline,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;

        final color =
            isActive
                ? Colors.blue.shade900
                : isCompleted
                ? Colors.green
                : Colors.grey.shade400;

        final bgColor = isActive ? Colors.blue.shade50 : Colors.transparent;

        return Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      steps[index]['icon'] as IconData,
                      color: color,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      steps[index]['label'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      steps[index]['sub'] as String,
                      style: TextStyle(fontSize: 10, color: color),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (index < steps.length - 1)
                Container(
                  height: 2,
                  width: double.infinity,
                  color:
                      index < currentStep ? Colors.green : Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
