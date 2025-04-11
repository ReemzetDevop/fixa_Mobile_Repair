import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  final BuildContext context;

  LocationService(this.context);

  // Fetch both address and coordinates
  Future<Map<String, dynamic>?> getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      String? address = await _getAddressFromLatLng(position.latitude, position.longitude);

      if (address != null) {
        return {
          "address": address,
          "latitude": position.latitude,
          "longitude": position.longitude,
        };
      }
      return null;
    } catch (e) {
      debugPrint("Error getting position: $e");
      return null;
    }
  }

  // Handles location permissions
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  // Fetch address from latitude and longitude using Google Maps API
  Future<String?> _getAddressFromLatLng(double lat, double lng) async {
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=AIzaSyAAQzj4K4H8RARgq-YNHh6G-YaKFdq3WgY&language=en&latlng=$lat,$lng';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        return data["results"][0]["formatted_address"];
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
      return null;
    }
  }
}
