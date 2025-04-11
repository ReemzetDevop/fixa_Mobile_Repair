import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fixa/Mobile/Screen/MHomePage.dart';
import 'package:fixa/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Animation/AnimatedIconWidget.dart';
import '../../Model/UserModel.dart';
import '../../NotificationOneSignal/OneSignalNotification.dart';
import '../../Services/UserRepo.dart';
import '../Widget/ScheduleDayWidget.dart';

class SelectAddress extends StatefulWidget {
  final Map<String, Map<String, dynamic>> cartItems;
  final double totalamount;
  final String model;
  final String brand;

  SelectAddress({
    required this.cartItems,
    required this.totalamount,
    required this.brand,
    required this.model,
  });

  @override
  State<SelectAddress> createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  late String _userId;
  late DatabaseReference _databaseRef;

  List<Map<String, dynamic>> addresses = [];
  Map<String, dynamic>? selectedAddress; // Updated variable
  DateTime _selectedScheduleDate = DateTime.now();
  DateTime _selectedScheduleTime=DateTime.now();
  UserModel? user;
  DatabaseReference? userbookingref;
  final _database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser ;
    fetchuser();
    if (user == null) {
      print('User  is not logged in');
      return;
    }
    _userId = user.uid;
    _databaseRef = FirebaseDatabase.instance.ref().child('Fixa/User/$_userId/addresses');
    userbookingref = _database.ref('Fixa/User/$_userId/booking');
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    final snapshot = await _databaseRef.get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        addresses = data.entries
            .map((e) => {'id': e.key, ...Map<String, dynamic>.from(e.value)})
            .toList();
      });
    }
  }

  Future<void> _saveAddress(Map<String, dynamic> addressData) async {
    await _databaseRef.push().set(addressData);
    _fetchAddresses();
  }

  void _showAddAddressDialog() {
    final TextEditingController pincodeController = TextEditingController();
    final TextEditingController flatController = TextEditingController();
    final TextEditingController localityController = TextEditingController();
    final TextEditingController landmarkController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController alternatePhoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Add New Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ..._buildTextFields(
                      pincodeController,
                      flatController,
                      localityController,
                      landmarkController,
                      cityController,
                      alternatePhoneController),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final newAddress = {
                        'pincode': pincodeController.text,
                        'flat': flatController.text,
                        'locality': localityController.text,
                        'landmark': landmarkController.text,
                        'city': cityController.text,
                        'alternatePhone': alternatePhoneController.text,
                      };
                      _saveAddress(newAddress);
                      Navigator.pop(context);
                    },
                    child: Text('Save Address', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildTextFields(
      TextEditingController pincodeController,
      TextEditingController flatController,
      TextEditingController localityController,
      TextEditingController landmarkController,
      TextEditingController cityController,
      TextEditingController alternatePhoneController) {
    return [
      TextField(
        controller: pincodeController,
        decoration: const InputDecoration(
          labelText: 'Pincode',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 6),
      TextField(
        controller: flatController,
        decoration: const InputDecoration(
          labelText: 'Flat No / HNo',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 6),
      TextField(
        controller: localityController,
        decoration: const InputDecoration(
          labelText: 'Locality / Street',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 6),
      TextField(
        controller: landmarkController,
        decoration: const InputDecoration(
          labelText: 'Landmark (Optional)',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 6),
      TextField(
        controller: cityController,
        decoration: const InputDecoration(
          labelText: 'City',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 6),
      TextField(
        controller: alternatePhoneController,
        decoration: const InputDecoration(
          labelText: 'Alternate Phone Number',
          border: OutlineInputBorder(),
        ),
      ),
    ];
  }

  Future<void> _proceedToBook() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Check if cartItems is null or empty
      if (widget.cartItems == null || widget.cartItems.isEmpty) {
        Navigator.of(context).pop(); // Close the loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No items in the cart to book.'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Exit the method early
      }

      String? bookingid = userbookingref?.push().key.toString();
      print('Booking ID: $bookingid'); // Debugging: Print the booking ID

      final bookingData = {
        'bookingitem': widget.cartItems,
        'totalcharge': widget.totalamount.toStringAsFixed(2),
        'time': DateTime.now().toLocal().toIso8601String(),
        'date': DateTime.now().toLocal().toString().split(' ')[0],
        'timestamp': ServerValue.timestamp,
        'userid': _userId,
        'username': user?.name ?? "Unknown",
        'userphone': user?.userPhone ?? "Unknown",
        'model': widget.model,
        'brand': widget.brand,
        'bookingid': bookingid,
        'bookingaddress': selectedAddress ?? "No Address Provided", // Ensure this is not null
        'bookingstatus': 'Pending',
        'bookingpin': generateUniqueCode(),
        'paymode': 'COD',
        'scheduleday': _selectedScheduleDate.toIso8601String(),
        'repairtype':'DoorStep'
      };



      await userbookingref?.child(bookingid!).set(bookingData);
      await _database.ref('Fixa/Admin/booking').child(bookingid!).set(bookingData);
      Navigator.of(context).pop();
      widget.cartItems.clear();


      sendpushnotification(
        'Your Booking is successfully',
        'https://firebasestorage.googleapis.com/v0/b/reemzet-developer.appspot.com/o/Notification%2Fbooking.png?alt=media&token=dd477cf6-6ad4-43f7-9a93-40054461bf86',
        [user?.userPhone ?? ''],
      );
      sendpushnotification(
        'New Booking From Fixa Service',
        'https://firebasestorage.googleapis.com/v0/b/reemzet-developer.appspot.com/o/Notification%2Fbooking.png?alt=media&token=dd477cf6-6ad4-43f7-9a93-40054461bf86',
        ['Admin'],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking confirmed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
     // Navigator.of(context).popUntil((route) => route.isFirst); // Go back to the home screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Mhomepage(initialIndex: 1)),
            (route) => false,
      );
      setState(() {});
    } catch (error) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to confirm booking: $error'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error confirming booking: $error');
    }
  }

  Future<void> fetchuser() async {
    user = await UserRepository().getUserData();
    setState(() {});
  }

  String generateUniqueCode() {
    Random random = Random();
    int uniqueNumber = 100000 + random.nextInt(900000); // Generates a number between 100000 and 999999
    return "FIXA$uniqueNumber";
  }


  Future<void> sendpushnotification(String msg, String imageurl, List<String> externalid) async {
    final pushoneSignalNotification = PushOneSignalNotification();
    await pushoneSignalNotification.sendPushNotification(
      message: msg,
      title: 'Fixa Service',
      heading: 'New message from Fixa Service',
      externalIds: externalid,
      targetChannel: 'push',
      customData: {"custom_key": "custom_value"},
      imageUrl: imageurl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Select Address', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          ...addresses.map((address) {
            return CheckboxListTile(
              secondary: const Icon(Icons.home, size: 30, color: Colors.black),
              checkColor: Colors.black,
              title: Expanded(
                child: Text(
                  '${address['flat']}, ${address['locality']}, ${address['city']} ',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: Text(
                'Landmark: ${address['landmark']}, Pin: ${address['pincode']}',
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              value: selectedAddress == address, // Updated line
              onChanged: (value) {
                setState(() {
                  selectedAddress = value! ? address : null;
                });
              },

            );
          }).toList(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
            child: InkWell(
              onTap: () {
                _showAddAddressDialog();
              },
              child: Text(
                'Add new Address +',
                style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Select Schedule Day',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          _buildScheduleDays(),
        _buildScheduleTimeSlots()
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 8,right: 8,bottom: 2),
        color: Colors.white, // Background color for the bottom navigation bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Ensure the column only takes up as much space as needed
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5, top: 10, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color:AppColors.primary, // You can change the color as needed
                          size: 20, // Adjust the size of the icon
                        ),
                        SizedBox(width: 5), // Adds some space between the icon and text
                        Text(
                          'Repair Mode:- At Store',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Change',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: (){
                if (selectedAddress != null) {
                  _proceedToBook();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please choose an address!'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }


              },
              child: Container(
                height: 50,
                width: double.infinity,
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Proceed to Book ₹${widget.totalamount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
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
          ],
        ),
      ),
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
  Widget _buildScheduleTimeSlots() {
    DateTime now = DateTime.now();

    // Round up to the next 30-minute slot
    int minutes = now.minute;
    int nextMinutes = (minutes % 30 == 0) ? minutes : (minutes ~/ 30 + 1) * 30;

    DateTime firstSlot = DateTime(now.year, now.month, now.day, now.hour, nextMinutes);
    List<DateTime> timeSlots = [];

    // Generate 10 slots (You can adjust the number as needed)
    for (int i = 0; i < 12; i++) {
      timeSlots.add(firstSlot);
      firstSlot = firstSlot.add(Duration(minutes: 30));
    }

    // Set the first slot as default selected time if not already set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedScheduleTime == null) {
        setState(() {
          _selectedScheduleTime = timeSlots.first;
        });
      }
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,  // Adjust the number of columns as needed
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 2,
        ),
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          final slot = timeSlots[index];

          return ScheduleTimeWidget(
            time: slot,
            isSelected: _selectedScheduleTime == slot,
            onTap: () {
              setState(() {
                _selectedScheduleTime = slot;
              });
            },
          );
        },
      ),
    );
  }


  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}


class ScheduleTimeWidget extends StatelessWidget {
  final DateTime time;
  final bool isSelected;
  final VoidCallback onTap;

  const ScheduleTimeWidget({
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          DateFormat.jm().format(time), // 12-hour format (e.g., 10:30 AM)
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}



