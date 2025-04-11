import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final String orderStatus;
  final String orderDate;
  final String orderId;
  final String imageUrl;
  final String modelName;
  final String service;
  final double amount;
  final Function onpress;

  const BookingCard({
    Key? key,
    required this.orderStatus,
    required this.orderDate,
    required this.orderId,
    required this.imageUrl,
    required this.modelName,
    required this.service,
    required this.amount,
    required this.onpress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black54, width: 0.5),borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: (){onpress();},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Status Row

              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    orderStatus,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "OrderId:- $orderId",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,fontSize: 12
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(orderDate, style: TextStyle(color: Colors.grey)),
              const Divider(),
              // Order Details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/fixalogo.png', // Replace with your fallback image path
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 16),
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Model- $modelName',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height:4),
                        Text(
                          "Booked Repair Services",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          service,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              // Amount Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Repair Amount",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₹${amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}