import 'package:flutter/material.dart';

class BookingAddressWidget extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String? address;

  const BookingAddressWidget({
    Key? key,
    required this.name,
    required this.phoneNumber,
    this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        elevation: 0.3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service Address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Name - $name',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Mob - $phoneNumber',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  address ?? 'Address not available',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black87,
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
