import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleDayWidget extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final VoidCallback onTap;

  const ScheduleDayWidget({
    required this.day,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container (
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('d').format(day),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  DateFormat('EEE').format(day),
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}