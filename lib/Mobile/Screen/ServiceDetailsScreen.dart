import 'package:firebase_database/firebase_database.dart';
import 'package:fixa/Mobile/Widget/ServicePosterSliderWidget.dart';
import 'package:fixa/Model/UserModel.dart';
import 'package:fixa/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Services/UserRepo.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String serviceRef;
  final String modelId;
  final String brandlId;

  const ServiceDetailsScreen({super.key, required this.serviceRef,required this.brandlId,required this.modelId});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Map<String, dynamic>? serviceDetails;
  bool _isLoading = true;
  UserModel? user;


  @override
  void initState() {
    super.initState();
    fetchServiceDetails();
    fetchuser();
  }
  Future<void> fetchServiceDetails() async {

    try {
      final serviceRef = _database.ref(widget.serviceRef);
      final snapshot = await serviceRef.get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          serviceDetails = {
            'serviceid':snapshot.key,
            'name': data['ServiceName'] ?? '',
            'image': data['ServiceImage'] ?? '',
            'charge': (data['ServiceCharge'] ?? 0.0) as double,
            'serviceMrp': (data['Mrp'] ?? 0.0) as double,
            'description': data['ServiceDescription'] ?? '',
            'poster': data['ServiceImages'] ?? [], // Assuming poster is a list of URLs
          };
          print(serviceDetails);
          _isLoading = false;
        });
      } else {
        print('No service found with the given reference.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching service details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> addToCart(
      String serviceId,
      String serviceName,
      double serviceCharge,
      String userId,
      String serviceImage,
      ) async {
    try {
      if (userId.isEmpty) {
        Fluttertoast.showToast(msg: 'User not authenticated');
        return;
      }
      final cartRef = _database.ref('Fixa/User/$userId/cart');
      final cartSnapshot = await cartRef.get();
      if (cartSnapshot.exists) {
        Map<String, dynamic> cartData = Map<String, dynamic>.from(cartSnapshot.value as Map);

        String existingBrand = cartData.values.first['brand'] ?? '';
        String existingModel = cartData.values.first['model'] ?? '';

        if (existingBrand != widget.brandlId || existingModel != widget.modelId) {
          Fluttertoast.showToast(
            msg: 'You can only add services from the same brand and model. Clear your cart first.',
          );
          return;
        }
      }

      // Proceed to add the item to the cart
      final serviceRef = cartRef.child(serviceId);
      await serviceRef.set({
        'serviceName': serviceName,
        'serviceCharge': serviceCharge,
        'brand': widget.brandlId,
        'model': widget.modelId,
        'image': serviceImage,
        'serviceid': serviceId,
        'date': DateTime.now().toString().split(' ')[0], // Extract only the date in YYYY-MM-DD format
        'time': '${DateTime.now().hour}:${DateTime.now().minute}', // Current time in HH:mm format
        'timestamp': DateTime.now().millisecondsSinceEpoch, // Use milliseconds since epoch
      });

      Fluttertoast.showToast(msg: 'Item added to cart');

    } catch (e) {
      print('Error adding item to cart: $e');
      Fluttertoast.showToast(msg: 'Failed to add item to cart');
    }
  }

  Future<void> fetchuser()async{
    user = await UserRepository().getUserData();
    setState(() {

    });
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(serviceDetails?['name'] ?? '', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Column(
        children: [
          LinearProgressIndicator(), // Loading bar
          const SizedBox(height: 16), // Spacing
          const Center(child: Text('Loading service details...')), // Optional loading text
        ],
      )
          : serviceDetails == null
          ? const Center(child: Text('No service details available'))
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (serviceDetails!['poster'] != null)
                    ServicePosterSliderWidget(
                      mediaUrls: List<String>.from(serviceDetails!['poster']),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceDetails!['name'] ?? 'Service Name',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_downward, size: 20, color: Colors.green),
                            Text(
                              '${calculatePercentage(
                                serviceDetails!['serviceMrp'],
                                serviceDetails!['charge'],
                              ).toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '\$${serviceDetails!['serviceMrp'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.blueGrey,
                                decorationThickness: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '₹${serviceDetails!['charge'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        HtmlWidget(serviceDetails!['description'] ?? '<p>Service Description</p>'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50, // Set the desired height for the button
                    child: ElevatedButton.icon(
                      onPressed: () {
                       addToCart(serviceDetails!['serviceid'], serviceDetails!['name'],  serviceDetails!['charge'],
                           user!.uid, serviceDetails!['image']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Make the button rectangular
                        ),
                      ),
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.white), // Add your desired icon
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 50, // Set the desired height for the button
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Book Now action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Make the button rectangular
                        ),
                      ),
                      icon: const Icon(Icons.book, color: Colors.white), // Add your desired icon
                      label: const Text(
                        'Book Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  double calculatePercentage(double mrp, double discountedPrice) {
    if (mrp <= 0 || discountedPrice < 0 || discountedPrice > mrp) {
      throw ArgumentError(
          "Invalid input values. Make sure MRP > 0, discountedPrice >= 0, and discountedPrice <= MRP.");
    }

    double percentageOff = ((mrp - discountedPrice) / mrp) * 100;
    return percentageOff;
  }
}

