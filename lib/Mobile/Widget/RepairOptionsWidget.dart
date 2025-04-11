import 'package:flutter/material.dart';

class RepairOptionBottomSheet extends StatelessWidget {
  final void Function(String option) onOptionSelected;

  const RepairOptionBottomSheet({Key? key, required this.onOptionSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Choose Repair Option",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            onTap: () {
              onOptionSelected("Repair at Doorstep");
             // Close the BottomSheet
            },
            leading: const Icon(Icons.home_repair_service, color: Colors.blue),
            title: const Text("Repair at Doorstep",style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: const Text("Get your device repaired at your location."),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              onOptionSelected("Repair at Store");
            },
            leading: const Icon(Icons.store, color: Colors.green),
            title: const Text("Repair at Store",style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: const Text("Flat Discounts: Up to ₹500 Off! - Visit the store for a discounted repair."),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "₹500 OFF",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
