import 'package:flutter/material.dart';

class BookingStatusIcon extends StatelessWidget {
  final String status;

  BookingStatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    // Define a map of status to icons
    final Map<String, IconData> statusIcons = {
      'Pending': Icons.hourglass_empty,
      'Confirm': Icons.check_circle,
      'Pickup': Icons.local_shipping,
      'Picked': Icons.done_all,
      'Repairing': Icons.build,
      'Out for delivery': Icons.delivery_dining,
      'Delivered': Icons.home,
    };

    // Get the icon for the current status, default to a help icon if not found
    IconData iconData = statusIcons[status] ?? Icons.help_outline;

    return Icon(
      iconData,
      color: Colors.orange, // Icon color remains white
      size: 20, // Customize the size as needed
    );
  }
}

class BookingStatusWidget extends StatelessWidget {
  final String bookingStatus;

  BookingStatusWidget({required this.bookingStatus});

  @override
  Widget build(BuildContext context) {
    // Define a map of status to colors
    final Map<String, Color> statusColors = {
      'Pending': Colors.red,
      'Confirm': Colors.blueAccent,
      'Pickup': Colors.orange,
      'Picked': Colors.lightGreen,
      'Repairing': Colors.yellow,
      'Out for delivery': Colors.teal,
      'Delivered': Colors.green,
    };

    // Get the color for the current status, default to blueAccent if not found
    Color backgroundColor = statusColors[bookingStatus] ?? Colors.blueAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          BookingStatusIcon(status: bookingStatus),
          SizedBox(width: 4),
          Text(
            bookingStatus,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
