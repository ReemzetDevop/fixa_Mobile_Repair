import 'package:fixa/Utils/Colors.dart';
import 'package:fixa/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildCustomCard({
  required String headerText,
  required String subtitleText,
  required String buttonText,
  required VoidCallback onPressed,
}) {
  return Card(
    elevation: 3,
    color: Colors.white,
    margin: const EdgeInsets.all(20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerText,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  subtitleText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                    color: AppColors.primary
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 115.w, // Set your desired width
                  height: 35.h, // Set your desired height
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ElevatedButton(
                    onPressed: onPressed,
                    child: Text(
                      buttonText,
                      style: TextStyle(color: Colors.white,fontSize:12.sp),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0, // Remove elevation for flat button appearance
                      backgroundColor: Colors.transparent, // Make the button background transparent to show container color
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    ),
  );
}
