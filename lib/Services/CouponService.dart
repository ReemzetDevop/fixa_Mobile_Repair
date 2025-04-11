import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CouponService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("/Fixa/Offer/coupons");

  Future<List<Map<String, dynamic>>> fetchCoupons() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final coupons = snapshot.value as Map<dynamic, dynamic>;
      return coupons.entries.map((e) {
        final coupon = e.value as Map<dynamic, dynamic>;
        return {
          "id": e.key,
          "couponCode": coupon["couponCode"],
          "percentageOff": coupon["percentageOff"],
          "maxDiscount": coupon["maxDiscount"],
          "validTill": coupon["validTill"],
          "description": coupon["description"],
        };
      }).toList();
    }
    return [];
  }
}