import 'dart:async';
import 'dart:math'; // Import this to generate random colors
import 'package:fixa/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewWidget extends StatefulWidget {
  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  List<Map<String, String>> reviews = [
    {'name': 'Alice', 'review': 'Great service and fast repair!'},
    {'name': 'Bob', 'review': 'Really satisfied with the doorstep repair.'},
    {'name': 'Charlie', 'review': 'Professional and punctual!'},
    {'name': 'Diana', 'review': 'Super quick response and great support!'},
    {'name': 'Edward', 'review': 'Very happy with the repair service.'},
    {'name': 'Fiona', 'review': 'Good value for the price and great quality.'},
    {'name': 'George', 'review': 'Highly recommend Fixa service!'},
    {'name': 'Hannah', 'review': 'Convenient and easy to book.'},
    {'name': 'Ian', 'review': 'Fast, efficient, and friendly service.'},
    {'name': 'Jane', 'review': 'Excellent repair work and customer service.'},
  ];

  bool _isLoading = false;
  late ScrollController _scrollController;
  Timer? _scrollTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    startAutoScroll();
  }

  // Auto-scroll logic
  void startAutoScroll() {
    _scrollTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;

        if (currentScroll < maxScroll) {
          _scrollController.animateTo(
            currentScroll + 300, // Adjust to your needs
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            0.0, // Scroll back to the beginning
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // Function to generate a random color
  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
      height: 70.h, // Adjust height as needed
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          final String name = review['name']!;
          final Color backgroundColor = _getRandomColor(); // Get random background color
          return Container(
            width: 300.w, // Width of each review card
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              elevation: 2,
              color: backgroundColor, // Set random background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: Colors.white,
                          child: Text(
                            name[0], // First letter of name
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Change text color to white
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name, // Full name
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Change name text color to white
                              ),
                            ),
                            Text(
                              review['review'] ?? '',
                              maxLines:1, // Set the maximum number of lines
                              overflow: TextOverflow.ellipsis, // Add ellipsis if the text overflows
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                                // Change review text color to white
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
