import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/fixalogo.png',
            height: 80,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/icons/facebook.png', // Replace with your SVG asset path
                  height: 24,
                  width: 24,
                ),
                onPressed: () {
                  // Open Facebook link
                },
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icons/instagram.png', // Replace with your SVG asset path
                  height: 24,
                  width: 24,
                ),
                onPressed: () {
                  // Open Instagram link
                },
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icons/youtube.png', // Replace with your SVG asset path
                  height: 24,
                  width: 24,
                ),
                onPressed: () {
                  // Open YouTube link
                },
              ),
            ],
          ),

          // Address
          Text(
            'Address: Ashok Nagar, Road No 8,\nKankadbagh, Patna - 800020\n(Near New Bypass)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // Copyright notice (optional)
          Text(
            '© 2024 Fixa Repair. All rights reserved.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
