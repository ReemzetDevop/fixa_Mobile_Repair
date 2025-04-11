import 'package:fixa/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandCard extends StatelessWidget {
  final String brandName;
  final String brandDesc;
  final String brandImage;
  final VoidCallback onPress; // A callback for handling the press action

  BrandCard({
    required this.brandName,
    required this.brandDesc,
    required this.brandImage,
    required this.onPress, // Pass the onPress function when using the widget
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress, // Execute the onPress callback when tapped
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.network(
                brandImage,
                width: double.infinity,
                height: 90.h,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  brandName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  brandDesc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.blueGrey,fontSize: 9.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ],
        ),
      ),
    );
  }
}
