import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

Widget howWeRepairYourPhoneWidget() {
  return Card(
    color: Colors.white,
    elevation: 2,
    margin: EdgeInsets.all(8),
    child: Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Step 1: Choose Brand and Model',
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Choose your phone brand and model, select the issue, and book the service.',
                    style: TextStyle(fontSize: 10.sp,),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Step 2: Expert Doorstep Service',
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Our expert will fix your device at your doorstep with care.',
                    style: TextStyle(fontSize: 10.sp,),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Step 3: Best Service & Post Service Support',
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'We provide top service and single-click post-service support.',
                    style: TextStyle(fontSize: 10.sp,),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Lottie.asset('assets/lottie/repair.json'), // Animation for Step 1 and 2
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
