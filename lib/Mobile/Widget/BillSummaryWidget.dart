import 'package:flutter/material.dart';

class BillSummaryWidget extends StatelessWidget {
  final double totalServiceValue;

  const BillSummaryWidget({
    Key? key,
    required this.totalServiceValue,
  }) : super(key: key);

  double get totalAmount => totalServiceValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black54, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.only(left: 8,right: 8,bottom: 2,top: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Payment Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 4),
            _buildRow('Service Charge', totalServiceValue),
            SizedBox(height: 4),
            const DashedDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    totalAmount.toStringAsFixed(2),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Text(value.toStringAsFixed(2)),
        ],
      ),
    );
  }
}

class DashedDivider extends StatelessWidget {
  const DashedDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey,
      thickness: 1,
    );
  }
}
