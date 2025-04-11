import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:fixa/Mobile/Screen/StoreLists.dart';
import 'package:fixa/Mobile/Widget/FaQWidget.dart';
import 'package:fixa/Mobile/Widget/WhyCHooseUSWidget.dart';
import 'package:fixa/Utils/Colors.dart';
import 'package:fixa/Utils/CustomPageRoute.dart';
import 'package:fixa/Utils/PageNavigator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Animation/AnimatedIconWidget.dart';
import '../../Services/CouponService.dart';
import '../../Utils/SearchBar.dart';
import '../Widget/BillSummaryWidget.dart';
import '../Widget/RepairOptionsWidget.dart';
import '../Widget/ServiceCard.dart';
import 'SelectAddress.dart';
class MServiceListScreen extends StatefulWidget {
  final String modelId;
  final String brandlId;

  const MServiceListScreen(
      {super.key, required this.modelId, required this.brandlId});

  @override
  State<MServiceListScreen> createState() => _MServiceListScreenState();
}

class _MServiceListScreenState extends State<MServiceListScreen> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  late final String _servicesPath;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> filteredServices = [];
  bool _isLoading = true;
  Map<String, Map<String, dynamic>> cartItems = {};
  double totalPrice = 0.0; // Store total price of cart
  String? _selectedCouponCode;
  double _discountAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _servicesPath =
        '/Fixa/Brands/${widget.brandlId}/Models/${widget.modelId}/servicelist';
    fetchServices();
    _searchController.addListener(_filterServices);
  }

  Future<void> fetchFixaProfile() async {
    final snapshot = await _database.ref('Fixa/FixaProfile').get();

    if (snapshot.exists) {
      final profileData = snapshot.value as Map<Object?, Object?>;
      setState(() {}); // Update the UI
    } else {
      print('Fixa profile data not found');
    }
  }



  final Map<String, List<Map<String, dynamic>>> categorizedServices = {};
  final Map<String, bool> expandedCategories = {}; // To track expanded state

  Future<void> fetchServices() async {
    try {
      final servicesRef = _database.ref(_servicesPath);
      final snapshot = await servicesRef.get();

      if (snapshot.exists) {
        Map<String, List<Map<String, dynamic>>> fetchedCategories = {};

        snapshot.children.forEach((child) {
          Map<String, dynamic> serviceData =
          Map<String, dynamic>.from(child.value as Map);

          String category = serviceData['ServiceCat'] ?? 'Others';

          Map<String, dynamic> service = {
            'name': serviceData['ServiceName'] ?? '',
            'servicecat': category,
            'image': serviceData['ServiceImage'] ?? '',
            'charge': serviceData['ServiceCharge'] ?? 0.0,
            'serviceMrp': serviceData['Mrp'] ?? 0.0,
            'description': serviceData['ServiceDescription'] ?? '',
            'id': child.key ?? '',
            'servicecovers': serviceData['servicecovers'] is String
                ? (serviceData['servicecovers'] as String)
                .split(',')
                .map((tag) => tag.trim())
                .toList()
                : <String>[],
          };

          // Add to category list
          if (!fetchedCategories.containsKey(category)) {
            fetchedCategories[category] = [];
          }
          fetchedCategories[category]!.add(service);
        });

        setState(() {
          categorizedServices.clear();
          categorizedServices.addAll(fetchedCategories);

          expandedCategories.clear();
          for (var category in fetchedCategories.keys) {
            expandedCategories[category] = false; // Initially collapsed
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          categorizedServices.clear();
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

  void _filterServices() {
    String query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        filteredServices = services;
      });
      return;
    }

    setState(() {
      filteredServices = services.where((service) {
        String serviceName = service['name'].toLowerCase();
        List<dynamic> servicecovers = service['servicecovers'];
        return serviceName.contains(query) ||
            servicecovers.any((cover) => cover.toLowerCase().contains(query));
      }).toList();
    });
  }

  void _addToCart(String serviceId, double serviceCharge, String serviceName, String serviceImageUrl) {
    setState(() {
      if (cartItems.containsKey(serviceId)) {
        cartItems[serviceId]!['quantity'] += 1; // Increment quantity
      } else {
        cartItems[serviceId] = {
          'title': serviceName,
          'charge': serviceCharge,
          'imageUrl': serviceImageUrl,
        };
      }
      totalPrice += serviceCharge;
    });
  }

  void _removeFromCart(String serviceId) {
    if (cartItems.containsKey(serviceId)) {
      setState(() {
        totalPrice -= cartItems[serviceId]!['charge'];
          cartItems.remove(serviceId);
      });
    } else {
      // Notify user if the item is not in the cart
      Fluttertoast.showToast(
          msg: "Item not in cart", toastLength: Toast.LENGTH_SHORT);
    }
  }

  Future<void> _showCouponDialog(BuildContext context) async {
    final couponService = CouponService();
    final coupons = await couponService.fetchCoupons();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Apply Coupon',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          content: coupons.isEmpty
              ? const Text('No coupons available.')
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: coupons.length,
                    itemBuilder: (context, index) {
                      final coupon = coupons[index];
                      return _CouponCard(
                        amount: '${coupon['percentageOff']}% OFF',
                        // Use 'percentageOff' instead of 'amount'
                        title:
                            coupon['description'] ?? 'No description available',
                        // Use 'description' or provide a fallback
                        validity: coupon['validTill'] != null
                            ? 'Valid until ${coupon['validTill']}'
                            : 'No validity specified',
                        // Handle null for 'validTill'
                        onTap: () {
                          _applyCoupon(coupon);
                          Navigator.pop(context); // Close the dialog
                        },
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _applyCoupon(Map<String, dynamic> coupon) {
    final totalServiceValue = totalPrice;
    final percentageOff = (coupon['percentageOff'] as num).toDouble();
    final maxDiscount = (coupon['maxDiscount'] as num).toDouble();

    double discount =
        (totalServiceValue * percentageOff / 100).clamp(0, maxDiscount);
    setState(() {
      _selectedCouponCode = coupon['couponCode'];
      _discountAmount = discount;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Coupon "${coupon['couponCode']}" applied! You saved ₹${discount.toStringAsFixed(2)}.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  List<String> _generateSearchHints() {
    Set<String> hints = {};

    for (var service in services) {
      hints.add(service['name'].toLowerCase());
      for (var cover in service['servicecovers']) {
        hints.add(cover.toLowerCase());
      }
    }

    return hints.toList();
  }

  double _calculateTotalAmount() {
    return totalPrice  - _discountAmount;
  }
  void _showRepairOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return RepairOptionBottomSheet(
          onOptionSelected: (option) {

            if (option == "Repair at Doorstep") {
              print('press');
              Navigator.push(
                  context,
                  CustomPageRoute(page: SelectAddress(cartItems: cartItems,
                    totalamount: _calculateTotalAmount(),
                    brand: widget.brandlId, model: widget.modelId),));
            } else if (option == "Repair at Store") {
              Navigator.push(
                  context,
                  CustomPageRoute(page: StoreListPage(cartItems: cartItems,
                    totalamount: _calculateTotalAmount(),
                    brand: widget.brandlId, model: widget.modelId,)));
            }
          },
        );
      },
    );
  }


  String? currentlyExpandedCategory;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Services', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [

                    CustomCollapsibleList(
                      categorizedServices: categorizedServices,  // Your service data
                      cartItems: cartItems,                      // Your cart items
                      onAddToCart: (String id, double charge, String name, String image) {
                        _addToCart(id, charge, name, image); // Convert charge if needed
                      },
                      onRemoveFromCart: _removeFromCart,  // Directly pass remove function
                    ),


                    Padding(
                      padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
                      child: BillSummaryWidget(
                          totalServiceValue: totalPrice,),
                    ),
                      _selectedCouponCode != null ?Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text('Coupon "$_selectedCouponCode" is applied: ₹${_discountAmount.toStringAsFixed(2)} off',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ):SizedBox(),
                    InkWell(
                      onTap: () {
                        _showCouponDialog(context);
                      },
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 8, right: 8, top: 10, bottom: 10),
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Increased border radius
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.card_giftcard),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'View all coupons',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                _showCouponDialog(context);
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Whychooseuswidget(),
                    Padding(
                      padding: const EdgeInsets.only(left: 15,top: 15),
                      child: Align(alignment:Alignment.topLeft,
                          child: Text('Frequently Asked Questions (FAQ)',
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                    ),
                    FAQWidget()
                  ],
                ),
              ),
                bottomNavigationBar: cartItems.isNotEmpty
            ? InkWell(
                onTap: () {
                  _showRepairOptions(context);
                },
                child: Card(
                  elevation: 3,
                  color: Colors.white,
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.all(5),
                    width: double.infinity,
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Proceed to Book  ₹${_calculateTotalAmount().toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 5),
                        AnimatedIconWidget(
                          icon: Icons.arrow_circle_right_outlined,
                          color: Colors.white,
                          size: 24.0,
                          duration: Duration(seconds: 1),
                          range: 10.0, // Move by 10 pixels
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : null);
  }
}






class CustomCollapsibleList extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>> categorizedServices;
  final Map<String, dynamic> cartItems;
  final Function(String id, double charge, String name, String image) onAddToCart;
  final Function(String id) onRemoveFromCart;

  const CustomCollapsibleList({
    Key? key,
    required this.categorizedServices,
    required this.cartItems,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  }) : super(key: key);

  @override
  _CustomCollapsibleListState createState() => _CustomCollapsibleListState();
}

class _CustomCollapsibleListState extends State<CustomCollapsibleList> {
  String? _currentlyExpandedCategory;

  @override
  Widget build(BuildContext context) {
    List<String> categories = widget.categorizedServices.keys.toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        String category = categories[index];
        List<Map<String, dynamic>> services =
        widget.categorizedServices[category]!;

        bool hasItemsInCart = services.any((service) =>
            widget.cartItems.containsKey(service['id'])
        );
        bool isExpanded =
            _currentlyExpandedCategory == category || hasItemsInCart;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                category,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: hasItemsInCart ? Colors.green : Colors.black,
                ),
              ),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: hasItemsInCart ? Colors.green : Colors.grey,
              ),
              onTap: () {
                setState(() {
                  if (hasItemsInCart && _currentlyExpandedCategory == category) {
                    return; // कार्ट वाली कैटेगरी को बंद नहीं होने दें
                  }
                  _currentlyExpandedCategory = isExpanded ? null : category;
                });
              },
            ),
            AnimatedCrossFade(
              duration: Duration(milliseconds: 300),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: SizedBox.shrink(),
              secondChild: Column(
                children: services.map((service) {
                  bool isAddedToCart =
                  widget.cartItems.containsKey(service['id']);
                  return ServiceCard(
                    serviceName: service['name'],
                    serviceCharge: service['charge'],
                    serviceMrp: service['serviceMrp'],
                    serviceDescription: service['description'],
                    serviceImage: service['image'],
                    Servicecovers: service['servicecovers'],
                    onPress: () {},
                    onAddToCart: () => widget.onAddToCart(
                      service['id'],
                      service['charge'],
                      service['name'],
                      service['image'],
                    ),
                    isAddedToCart: isAddedToCart,
                    onRemoveFromCart: () =>
                        widget.onRemoveFromCart(service['id']),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}


class _CouponCard extends StatelessWidget {
  final String amount;
  final String title;
  final String validity;
  final VoidCallback onTap;

  const _CouponCard({
    Key? key,
    required this.amount,
    required this.title,
    required this.validity,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            // Logo Section
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/images/fixalogo.png',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Details Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amount,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    validity,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Coupon Indicator
            Container(
              height: 60,
              width: 18,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
