import 'package:firebase_database/firebase_database.dart';
import 'package:fixa/Mobile/Screen/MModelList.dart';
import 'package:fixa/Utils/Colors.dart';
import 'package:flutter/material.dart';
import '../../Utils/CustomPageRoute.dart';
import '../../Utils/SearchBar.dart';
import '../Widget/BrandCard.dart';

class MBrandListScreen extends StatefulWidget {
  const MBrandListScreen({super.key});

  @override
  State<MBrandListScreen> createState() => _MBrandListScreenState();
}

class _MBrandListScreenState extends State<MBrandListScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('/Fixa/Brands');
  List<Map<String, String>> brands = [];
  List<Map<String, String>> filteredBrands = []; // Filtered brands list
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchBrands();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      String searchQuery = _searchController.text.toLowerCase();
      filteredBrands = brands.where((brand) {
        return brand['name']!.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  Future<void> fetchBrands() async {
    _databaseRef.keepSynced(true);
    try {
      _databaseRef.onValue.listen((event) {
        final snapshot = event.snapshot;
        if (snapshot.exists) {
          final data = snapshot.value;
          List<Map<String, String>> fetchedBrands = [];

          if (data is Map) {
            data.forEach((key, value) {
              if (value is Map) {
                fetchedBrands.add({
                  'name': value['BrandName'] ?? '',
                  'image': value['BrandImage'] ?? '',
                  'desc': value['BrandDesc'] ?? '',
                  'BrandId': key.toString(),
                });
              }
            });
          } else if (data is List) {
            for (var item in data) {
              if (item is Map) {
                fetchedBrands.add({
                  'name': item['BrandName'] ?? '',
                  'image': item['BrandImage'] ?? '',
                  'desc': item['BrandDesc'] ?? '',
                  'BrandId': item['BrandId'] ?? '',
                });
              }
            }
          }

          setState(() {
            brands = fetchedBrands;
            filteredBrands = fetchedBrands; // Initialize filteredBrands
            _isLoading = false;
          });
        } else {
          setState(() {
            brands = [];
            filteredBrands = [];
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      print('Error fetching brands: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Choose Your Brand',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SearchWidget(
            searchController: _searchController,
            searchHints: _generateSearchHints(),
          ),
          Expanded(
            child: filteredBrands.isEmpty
                ? Center(child: Text('No brands available'))
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 1,
                ),
                itemCount: filteredBrands.length,
                itemBuilder: (context, index) {
                  final brand = filteredBrands[index];
                  return BrandCard(
                    brandName: brand['name']!,
                    brandDesc: brand['desc']!,
                    brandImage: brand['image']!,
                    onPress: () {
                      Navigator.push(
                        context,
                        CustomPageRoute(
                          page: MModelListScreen(
                            Brandid: brand['BrandId']!,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Generate search hints from brand names
  List<String> _generateSearchHints() {
    return brands.map((brand) => brand['name']!.toLowerCase()).toList();
  }
}
