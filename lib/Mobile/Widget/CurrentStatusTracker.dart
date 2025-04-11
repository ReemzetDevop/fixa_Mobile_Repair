import 'package:flutter/material.dart';

class OrderStatusWidget extends StatelessWidget {
  final String currentStatus;

  OrderStatusWidget({required this.currentStatus});

  final Map<String, IconData> statusIcons = {
    'Pending': Icons.hourglass_empty,
    'Confirm': Icons.check_circle,
    'Pickup': Icons.local_shipping,
    'Picked': Icons.done_all,
    'Repairing': Icons.build,
    'Out for delivery': Icons.delivery_dining,
    'Delivered': Icons.home,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: statusIcons.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: [
              Icon(
                entry.value,
                color: entry.key == currentStatus ? Colors.blue : Colors.grey,
              ),
              Text(
                entry.key,
                style: TextStyle(
                  fontSize: 12,
                  color: entry.key == currentStatus ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
