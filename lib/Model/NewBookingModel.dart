
import 'package:flutter/material.dart';

class BookingModel {
  final String? bookingId;
  final String? date;
  final String? time;
  final String? brand;
  final String? model;
  final double? totalCharge;
  final String? bookingstatus;
  final List<BookingItemModel>? bookingItems;
  final int? timestamp;
  final String? bookingpin;
  final BookingAddress? bookingAddress;
  final String? paymode;
  final double? gst;
  final String? userId;  // New field for user ID
  final String? username; // New field for username
  final String? userPhone; // New field for user phone number

  BookingModel({
    this.bookingId,
    this.date,
    this.time,
    this.brand,
    this.model,
    this.totalCharge,
    this.bookingstatus,
    this.bookingItems,
    this.timestamp,
    this.bookingpin,
    this.bookingAddress,
    this.paymode,
    this.gst,
    this.userId,
    this.username,
    this.userPhone,
  });

  factory BookingModel.fromMap(
      String id, Map<dynamic, dynamic> data, List<BookingItemModel> items) {
    final totalChargeValue = data['totalcharge'];
    final gstValue = data['gst'];
    final bookingAddressData = data['bookingaddress'];

    return BookingModel(
      bookingId: id,
      date: data['date'] as String?,
      time: data['time'] as String?,
      brand: data['brand'] as String?,
      model: data['model'] as String?,
      totalCharge: totalChargeValue is String
          ? double.tryParse(totalChargeValue)
          : (totalChargeValue as num?)?.toDouble(),
      bookingstatus: data['bookingstatus'] as String?,
      bookingItems: items,
      timestamp: data['timestamp'] as int?,
      bookingpin: data['bookingpin'] as String?,
      gst: gstValue is String
          ? double.tryParse(gstValue)
          : (gstValue as num?)?.toDouble(),
      bookingAddress: (bookingAddressData is Map<dynamic, dynamic>)
          ? BookingAddress.fromMap(bookingAddressData)
          : null, // Handle when it's a String (e.g., "No Address Provided")
      userId: data['userid'] as String?,
      username: data['username'] as String?,
      userPhone: data['userphone'] as String?,
    );
  }


  @override
  String toString() {
    return 'BookingModel(bookingId: $bookingId, date: $date, time: $time, brand: $brand, model: $model, totalCharge: $totalCharge, bookingstatus: $bookingstatus, bookingItems: $bookingItems, timestamp: $timestamp, bookingpin: $bookingpin, bookingAddress: $bookingAddress, paymode: $paymode, userId: $userId, username: $username, userPhone: $userPhone)';
  }
}

class BookingItemModel {
  final String issueKey;
  final Map<dynamic, dynamic> details;

  BookingItemModel({required this.issueKey, required this.details});

  @override
  String toString() {
    return 'BookingItemModel(issueKey: $issueKey, details: $details)';
  }
}

class BookingAddress {
  final String? addressType;
  final String? alternatePhone;
  final String? city;
  final String? flat;
  final String? id;
  final String? landmark;
  final String? locality;
  final String? pincode;

  BookingAddress({
    this.addressType,
    this.alternatePhone,
    this.city,
    this.flat,
    this.id,
    this.landmark,
    this.locality,
    this.pincode,
  });

  factory BookingAddress.fromMap(Map<dynamic, dynamic> data) {
    return BookingAddress(
      addressType: data['addressType'] as String?,
      alternatePhone: data['alternatePhone'] as String?,
      city: data['city'] as String?,
      flat: data['flat'] as String?,
      id: data['id'] as String?,
      landmark: data['landmark'] as String?,
      locality: data['locality'] as String?,
      pincode: data['pincode'] as String?,
    );
  }

  @override
  String toString() {
    return 'BookingAddress(addressType: $addressType, alternatePhone: $alternatePhone, city: $city, flat: $flat, id: $id, landmark: $landmark, locality: $locality, pincode: $pincode)';
  }
}
