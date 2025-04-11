import 'package:fixa/Mobile/Widget/CurrentStatusTracker.dart';
import 'package:fixa/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../Model/NewBookingModel.dart';
import '../Widget/BookingCard.dart';
import 'BookingItemDetailsPage.dart';

class MBookingScreen extends StatefulWidget {
  const MBookingScreen({Key? key}) : super(key: key);

  @override
  State<MBookingScreen> createState() => _MBookingScreenState();
}

class _MBookingScreenState extends State<MBookingScreen> {
  final _database = FirebaseDatabase.instance;
  late final DatabaseReference _bookingRef;
  List<BookingModel> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _bookingRef = _database
        .ref('Fixa/User/${FirebaseAuth.instance.currentUser!.uid}/booking');
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      final snapshot = await _bookingRef.get();

      if (snapshot.exists) {
        final bookingData = snapshot.value as Map<dynamic, dynamic>;

        final List<BookingModel> bookings = bookingData.entries.map((entry) {
          final bookingDetails = entry.value as Map<dynamic, dynamic>;

          // Parse booking items
          final bookingItems = (bookingDetails['bookingitem'] as Map<dynamic, dynamic>? ?? {})
              .entries
              .map((itemEntry) {
            final issueKey = itemEntry.key.toString();
            final issueDetails = Map<String, dynamic>.from(itemEntry.value as Map<dynamic, dynamic>);
            return BookingItemModel(issueKey: issueKey, details: issueDetails);
          }).toList();

          // Parse complete booking using BookingModel
          return BookingModel.fromMap(
            entry.key.toString(),
            bookingDetails,
            bookingItems,
          );
        }).toList();

        // Filter and sort bookings
        final filteredBookings = bookings
            .where((booking) {
          final bookingDateTime = DateTime.tryParse(booking.date ?? '') ?? DateTime.now();
          return bookingDateTime.isAfter(DateTime.now().subtract(const Duration(days: 7)));
        })
            .toList()
          ..sort((a, b) => (b.timestamp ?? 0).compareTo(a.timestamp ?? 0));

        // Update state
        setState(() {
          _bookings = filteredBookings;
        });

        print('Fetched Bookings: $_bookings');
      } else {
        print('No bookings found.');
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
          ? const Center(child: Text('No bookings found'))
          : Expanded(
            child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _bookings.length,
                    itemBuilder: (context, index) {
            final booking = _bookings[index];
            return BookingCard(
              orderStatus: booking.bookingstatus ?? 'Pending',
              orderDate: booking.date ?? '',
              orderId: booking.bookingpin ?? '',
              imageUrl: booking.bookingItems?.first.details['imageUrl'] ?? '',
              modelName: booking.model ?? 'Unknown Model',
              service: booking.bookingItems?.first.details['title'] ?? 'Unknown Service',
              amount: booking.totalCharge ?? 0.0, onpress: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingDetailsPage(booking: booking,),
                ),
              );
            },
            );
                    },
                  ),
          ),
    );
  }
}






