import 'package:flutter/material.dart';

import '../../Utils/Colors.dart';
class TotalAmountBar extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onProceedToPay;

  const TotalAmountBar({
    Key? key,
    required this.totalAmount,
    required this.onProceedToPay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: ₹${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onProceedToPay,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Proceed to Pay',style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}