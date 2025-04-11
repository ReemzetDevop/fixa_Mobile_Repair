import 'package:fixa/Utils/Colors.dart';
import 'package:fixa/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceCard extends StatefulWidget {
  final String serviceName;
  final double serviceCharge;
  final double serviceMrp;
  final String serviceDescription;
  final String serviceImage;
  final List<String> Servicecovers;
  final VoidCallback onPress;
  final Function onAddToCart;    // Function to add to cart
  final Function onRemoveFromCart; // Function to remove from cart
  final bool isAddedToCart;     // Flag to check if the item is in the cart

  ServiceCard({
    required this.serviceName,
    required this.serviceCharge,
    required this.serviceDescription,
    required this.serviceImage,
    required this.serviceMrp,
    required this.onPress,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.Servicecovers,
    required this.isAddedToCart,
  });

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isLoading = false; // To manage loading state
  void _showDescriptionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.serviceName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: InAppWebView(
                      initialData: InAppWebViewInitialData(
                        data: """
                        <html>
                          <head>
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                          </head>
                          <body>
                            ${widget.serviceDescription}
                          </body>
                        </html>
                        """,
                      ),
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          javaScriptEnabled: true,
                          disableVerticalScroll: false,
                          disableHorizontalScroll: true,
                          supportZoom: false,
                        ),
                      ),
                      onLoadStart: (controller, url) {
                        // Handle load start
                      },
                      onLoadStop: (controller, url) {
                        // Handle load complete
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      child: Card(
        color: Colors.white,
        elevation: 0,
       margin: EdgeInsets.all(1),/*
       shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blueGrey, width: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),*/
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Service Image
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.network(
                        widget.serviceImage,
                        height: 85,
                        width: 50,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Center(child: Text('Image not available')),
                          );
                        },
                      ),
                    ),
                  ),
                  // Service Details
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.serviceName,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton( onPressed: _showDescriptionModal, icon: Icon(Icons.info_outline,size: 18,))
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                '${calculatePercentage(widget.serviceMrp, widget.serviceCharge).toStringAsFixed(2)}% Off',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '₹${widget.serviceMrp.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1),
                          Text(
                            '₹${widget.serviceCharge.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  isLoading
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (!widget.isAddedToCart) {
                        await widget.onAddToCart(); // Call add to cart function
                      } else {
                        await widget.onRemoveFromCart(); // Call remove from cart function
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color:widget.isAddedToCart ?Colors.black:Colors.white, // Black background color
                        borderRadius: BorderRadius.all(Radius.circular(5),),
                        border: Border.all(
                          color: Colors.black, // Black border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.isAddedToCart ? 'Added' : 'Add',
                            style: TextStyle(
                              color: widget.isAddedToCart ?Colors.white:Colors.black, // White text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            widget.isAddedToCart ? Icons.highlight_remove : Icons.add_circle_outline,size: 18,
                            color:widget.isAddedToCart ?Colors.white:Colors.black,// White icon color
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              ),
            ],
          ),
        ),
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

