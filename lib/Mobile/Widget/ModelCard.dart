import 'package:fixa/Utils/Colors.dart';
import 'package:fixa/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModelCard extends StatelessWidget {
  final String modelName;
  final String modelId;
  final String brandId;
  final String modelImage;
  final VoidCallback onPress; // Callback for the onPress action

  ModelCard({
    required this.modelName,
    required this.modelId,
    required this.brandId,
    required this.modelImage,
    required this.onPress, // Pass the onPress function when using the widget
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress, // Execute the onPress callback when tapped
      child: Card(
        color: Colors.white,
        elevation:3,
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.network(
                  modelImage,
                  width: double.infinity,
                  height: 70.h, // Reduce from 80.h
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    modelName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: double.infinity,
                // Remove fixed height constraint
                child: ElevatedButton(
                  onPressed: onPress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    // Add these properties
                    minimumSize: Size.fromHeight(35.h), // Set minimum height
                    padding: EdgeInsets.symmetric(vertical: 8.h), // Adjust vertical padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    'Select',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
