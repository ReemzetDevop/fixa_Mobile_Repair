import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../Animation/AnimatedIconWidget.dart';
import '../../Model/StoreModel.dart';
import '../../Utils/Colors.dart';
import '../Widget/ScheduleDayWidget.dart';

class StoreListPage extends StatefulWidget {
  final Map<String, Map<String, dynamic>> cartItems;
  final double totalamount;
  final String model;
  final String brand;

  StoreListPage({
    required this.cartItems,
    required this.totalamount,
    required this.brand,
    required this.model,
  });

  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  final DatabaseReference _database =
  FirebaseDatabase.instance.ref().child('Fixa/FixaProfile/Stores');

  List<Store> _stores = [];
  String? _selectedStoreId; // Store ID of the selected store
  late double _currentTotalAmount;
  DateTime _selectedScheduleDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _currentTotalAmount = widget.totalamount;
    _fetchStores();
    _applyDiscount();
  }

  void _applyDiscount() {
    setState(() {
      double discount = 0;
      if (_currentTotalAmount <= 1500) {
        discount = 150;
      } else if (_currentTotalAmount <= 2500) {
        discount = 250;
      } else if (_currentTotalAmount <= 3500) {
        discount = 400;
      } else {
        discount = 500;
      }

      _currentTotalAmount = (_currentTotalAmount - discount).clamp(0, double.infinity);
    });
  }

  void _fetchStores() {
    _database.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        setState(() {
          _stores = data.entries.map((entry) {
            final value = entry.value as Map<dynamic, dynamic>;
            return Store.fromMap(entry.key, value);
          }).toList();
        });
      } else {
        setState(() {
          _stores = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text('Store List', style: TextStyle(color: Colors.white)),
      ),
      body: StoreList(),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget BottomNavBar() {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 2),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey.shade100,
            padding: const EdgeInsets.only(left: 15, bottom: 5, top: 10, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.primary, size: 20),
                    SizedBox(width: 5),
                    Text(
                      'Repair Mode: At Store',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Change',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Proceed to Book ₹${_currentTotalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                AnimatedIconWidget(
                  icon: Icons.arrow_circle_right_outlined,
                  color: Colors.white,
                  size: 24.0,
                  duration: Duration(seconds: 1),
                  range: 10.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget StoreList() {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Select Schedule Day', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ..._stores.map((store) {
          return Card(
            color: Colors.white,
            child: RadioListTile<String>(
              secondary: store.photo.isNotEmpty
                  ? Image.network(
                store.photo,
                width: 70,
                height: 70,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                },
              )
                  : Icon(Icons.store, size: 50, color: Colors.grey),
              title: Text(
                store.name,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${store.location}\nPhone: ${store.phone}',
                style: TextStyle(fontSize: 12),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              value: store.id,
              groupValue: _selectedStoreId,
              controlAffinity: ListTileControlAffinity.trailing, // Moves radio to the right
              onChanged: (value) {
                setState(() {
                  _selectedStoreId = value;
                });
              },
            ),
          );
        }).toList(),

        const SizedBox(height: 5),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Select Schedule Day', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 5),
        _buildScheduleDays()
      ],
    );
  }

  Widget _buildScheduleDays() {
    DateTime currentDate = DateTime.now();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 1,
        ),
        itemCount: 5,
        itemBuilder: (context, index) {
          final day = currentDate.add(Duration(days: index));
          return ScheduleDayWidget(
            day: day,
            isSelected: _isSameDay(_selectedScheduleDate, day),
            onTap: () {
              setState(() {
                _selectedScheduleDate = day;
              });
            },
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}

