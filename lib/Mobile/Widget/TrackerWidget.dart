import 'package:flutter/material.dart';
class OrderTrackingWidget extends StatelessWidget {
  final String currentStatus;

  OrderTrackingWidget({Key? key, required this.currentStatus}) : super(key: key);

  final List<String> statuses = [
    'Pending',
    'Confirmed and Assigned',
    'Picked up',
    'In process',
    'On Hold',
    'Awaiting Approval',
    'Waiting for spare parts',
    'Completed',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: statuses.asMap().entries.map((entry) {
        int index = entry.key;
        String status = entry.value;
        bool isCurrent = status == currentStatus;
        bool isCompleted = index < statuses.indexOf(currentStatus);
        bool showVerticalLine = index < statuses.indexOf(currentStatus) || isCurrent;

        // Check if the status is one of the hidden statuses
        bool isHiddenStatus = ['On Hold', 'Awaiting Approval', 'Waiting for spare parts'].contains(status);

        // Only show the hidden statuses if the currentStatus matches them
        if (isHiddenStatus && currentStatus != status) {
          return SizedBox.shrink(); // Do not display the status if it's hidden
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusItem(status, isCurrent, isCompleted, showVerticalLine),
            if (index < statuses.length - 1) // Avoid adding a divider after the last item
              const SizedBox(height: 15), // Reduced divider spacing
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStatusItem(String status, bool isCurrent, bool isCompleted, bool showVerticalLine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStatusIcon(isCurrent, isCompleted),
            SizedBox(width: 10),
            _buildStatusText(status, isCurrent),
          ],
        ),
        if (showVerticalLine) _buildVerticalLine(),
      ],
    );
  }

  Widget _buildStatusIcon(bool isCurrent, bool isCompleted) {
    Color iconColor;
    if (isCompleted) {
      iconColor = Colors.green;
    } else if (isCurrent) {
      iconColor = Colors.blue;
    } else {
      iconColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconColor.withOpacity(0.2), // Soft background for icons
        border: Border.all(
          color: iconColor,
          width: 2,
        ),
      ),
      child: Icon(
        isCompleted || isCurrent ? Icons.check_circle : Icons.circle,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildStatusText(String status, bool isCurrent) {
    return Text(
      status,
      style: TextStyle(
        fontSize: 16,
        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
        color: isCurrent ? Colors.blue : Colors.grey,
      ),
    );
  }

  // Custom vertical line widget
  Widget _buildVerticalLine() {
    return Container(
      margin: EdgeInsets.only(left: 17),
      height: 20, // Adjust the height as needed
      width: 0.5,
      color: Colors.grey, // Color of the vertical line
    );
  }
}
