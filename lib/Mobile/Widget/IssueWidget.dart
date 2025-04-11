import 'package:fixa/Mobile/Screen/MBrandList.dart';
import 'package:fixa/Mobile/Screen/MModelList.dart';
import 'package:fixa/Mobile/Screen/MServiceBook.dart';
import 'package:fixa/Utils/Colors.dart';
import 'package:fixa/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Utils/CustomPageRoute.dart';
import '../Widget/ServiceCard.dart';

class IssueWidget extends StatefulWidget {
  @override
  State<IssueWidget> createState() => _IssueWidgetState();
}

class _IssueWidgetState extends State<IssueWidget> {
  final DatabaseReference _databaseRef =
  FirebaseDatabase.instance.ref('/Fixa/PopularIssue'); // Firebase Realtime Database reference
  List<Map<String, dynamic>> services = []; // List to store services
  bool _isLoading = true; // Loading indicator
  int servicesToShow = 3; // Number of services to show initially (2 rows)

  @override
  void initState() {
    super.initState();
    fetchServices(); // Fetch all services when the page initializes
  }

  Future<void> fetchServices() async {
    try {
      // Fetch all documents from Firebase Realtime Database
      final snapshot = await _databaseRef.get();

      if (snapshot.exists) {
        List<Map<String, dynamic>> fetchedServices = [];

        // Check if the snapshot value is a Map or a List
        final data = snapshot.value;

        if (data is Map<dynamic, dynamic>) {
          // If it's a Map, iterate over its entries
          data.forEach((key, value) {
            if (value is Map) {
              fetchedServices.add({
                'name': value['IssueName'] ?? '', // Default empty string if key is missing
                'image': value['IssueImage'] ?? '', // Default empty string if key is missing
              });
            }
          });
        } else if (data is List) {
          // If it's a List, iterate through the list
          for (var item in data) {
            if (item is Map) {
              fetchedServices.add({
                'name': item['IssueName'] ?? '', // Default empty string if key is missing
                'image': item['IssueImage'] ?? '', // Default empty string if key is missing
              });
            }
          }
        } else {
          print('Unexpected data structure: $data');
        }

        setState(() {
          services = fetchedServices; // Update the state with fetched services
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching services: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
                : GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Three columns
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.58.h, // Adjust aspect ratio based on your content
              ),
              itemCount: servicesToShow > services.length
                  ? services.length
                  : servicesToShow,
              itemBuilder: (context, index) {
                final service = services[index];
                return ServiceCard(
                  serviceName: service['name']!,
                  serviceImage: service['image']!,
                  onPress: () {
                    Navigator.push(
                      context,
                      CustomPageRoute(
                        page: MBrandListScreen(),
                      ),
                    );
                  },
                );
              },
            ),
            if (servicesToShow < services.length)
              TextButton(
                onPressed: () {
                  setState(() {
                    // Show 4 more services each time (2 more rows)
                    servicesToShow += 4;
                  });
                },
                child: Text(
                  'Show More Issues',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final String serviceName;
  final String serviceImage;
  final VoidCallback onPress;

  ServiceCard({
    required this.serviceName,
    required this.serviceImage,
    required this.onPress,
  });

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and the animation itself
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Duration of the animation
    );

    // Define the translation animation (moving forward)
    _animation = Tween<double>(begin: 0.0, end: 50.0).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse(); // Automatically reverse after completing
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward(); // Repeat the animation continuously
        }
      });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress, // Trigger the onPress callback when tapped
      child: Card(
        color: Colors.white,
        elevation: 3,
        margin: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                widget.serviceImage,
                width: double.infinity,
                height: 80.h,
                fit: BoxFit.fitHeight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.serviceName,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_animation.value, 0), // Translate along the X-axis (forward)
                    child: Icon(
                      Icons.double_arrow,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
