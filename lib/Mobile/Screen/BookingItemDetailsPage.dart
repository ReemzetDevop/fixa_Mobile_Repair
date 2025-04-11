import 'package:flutter/material.dart';
import '../../Model/NewBookingModel.dart';
import '../../Utils/Colors.dart';
import '../../Utils/DashedDivider.dart';
import '../Widget/TrackerWidget.dart';

class BookingDetailsPage extends StatefulWidget {
  final BookingModel booking;

  const BookingDetailsPage({required this.booking});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Booking Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Services',style: TextStyle(fontWeight: FontWeight.bold,fontSize:18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: _buildBookingItemsList(),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DashedDivider(
                      height: 2.0, // Height of the divider
                      dashWidth: 8.0, // Width of each dash
                      dashHeight: 2.0, // Height of each dash
                      color: Colors.black26, // Color of the dashed line
                      spacing: 2.0, // Spacing between dashes
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,),
                    child: Text('Order Status:-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30,top: 10),
                    child: OrderTrackingWidget(currentStatus: widget.booking.bookingstatus.toString()),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DashedDivider(
                      height: 2.0, // Height of the divider
                      dashWidth: 8.0, // Width of each dash
                      dashHeight: 2.0, // Height of each dash
                      color: Colors.black26, // Color of the dashed line
                      spacing: 2.0, // Spacing between dashes
                    ),
                  ),

                  _buildBillSummary(),

                ],
              ),
            ),

            _buildAddressCard(),
            _buildCancelRequestButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingItemsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.booking.bookingItems?.length ?? 0,
      itemBuilder: (context, index) {
        final item = widget.booking.bookingItems![index];
        return ListTile(
          leading:Image.network(
            '${item.details['imageUrl']}',
            height: 75,
            width: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/fixalogo.png', // Ensure this image is available in your assets
                height: 75,
                width: 60,
                fit: BoxFit.cover,
              );
            },
          ),

          title: Text(
            '${item.details['title']}',
            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
          ),
          subtitle: Text(
            '₹${item.details['charge']}',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBillSummary() {
    final totalServiceCharges = widget.booking.bookingItems?.fold<double>(
        0.0, (sum, item) => sum + (item.details['charge'] ?? 0.0)) ??
        0.0;

    // Calculate 18% GST on total service charges
    final gstCharges = totalServiceCharges * 0.18;
    final totalAmount = widget.booking.totalCharge ?? 0.0;
    final discountOffer = (totalServiceCharges + gstCharges) - totalAmount;

    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bill Summary',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Service Charges', style: TextStyle(fontSize: 14)),
              Text('₹${totalServiceCharges.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('GST Charges (18%)', style: TextStyle(fontSize: 14)),
              Text('₹${gstCharges.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14)),
            ],
          ),
          SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Discount/Offer', style: TextStyle(fontSize: 14)),
              Text(
                  '- ₹${(discountOffer < 0 ? 0 : discountOffer).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold)
              ),
            ],
          ),

          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                '₹${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    final address = widget.booking.bookingAddress;
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Divider(),
              const SizedBox(height: 4),
              if (address != null) ...[
                Text('Name:${widget.booking.username}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                Text('Flat: ${address.flat ?? '-'}'),
                Text('Locality: ${address.locality ?? '-'}'),
                Text('City: ${address.city ?? '-'}'),
                Text('Pincode: ${address.pincode ?? '-'}'),
                Text('Landmark: ${address.landmark ?? '-'}'),
                Text('Phone: ${widget.booking.userPhone}'),
                Text('Alternate Phone: ${address.alternatePhone ?? '-'}'),
                
              ] else
                const Text('No Address Provided'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancelRequestButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Are you sure you want to cancel this booking?'),
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'CALL',
                onPressed: () {
                  // Implement phone call functionality here
                  print('Calling support...');
                },
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Cancel Booking',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}













