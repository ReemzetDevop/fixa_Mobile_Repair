import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // For fetching current location
import 'package:intl/intl.dart'; // For formatting date and time

class MServiceBookingPage extends StatefulWidget {
  @override
  _MServiceBookingPageState createState() => _MServiceBookingPageState();
}

class _MServiceBookingPageState extends State<MServiceBookingPage> {
  // Variables to store selected date, time, and address
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _address = '';
  String _paymentMethod = '';

  final List<String> paymentOptions = ['Credit Card', 'PayPal', 'Cash on Delivery'];

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Method to pick time
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _address = 'Lat: ${position.latitude}, Long: ${position.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Booking'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Picker
              ListTile(
                title: Text('Choose Date'),
                subtitle: Text(
                  _selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                      : 'No date selected',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              Divider(),

              // Time Picker
              ListTile(
                title: Text('Choose Time Slot'),
                subtitle: Text(
                  _selectedTime != null
                      ? _selectedTime!.format(context)
                      : 'No time selected',
                ),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              Divider(),

              // Current Location and Address Picker
              ListTile(
                title: Text('Current Address'),
                subtitle: Text(_address.isNotEmpty
                    ? _address
                    : 'Tap to get your current location'),
                trailing: Icon(Icons.location_on),
                onTap: _getCurrentLocation,
              ),
              Divider(),

              // Payment Option Selection
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Choose Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: paymentOptions.map((option) {
                  return RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: _paymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                  );
                }).toList(),
              ),

              // Submit Button
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedDate != null && _selectedTime != null && _address.isNotEmpty && _paymentMethod.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Booking Successful!'),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please complete all fields'),
                      ));
                    }
                  },
                  child: Text('Confirm Booking'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
