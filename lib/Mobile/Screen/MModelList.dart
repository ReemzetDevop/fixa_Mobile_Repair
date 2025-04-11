import 'package:firebase_database/firebase_database.dart';
import 'package:fixa/Mobile/Screen/MServiceList.dart';
import 'package:fixa/Utils/Colors.dart';
import 'package:flutter/material.dart';

import '../../Utils/CustomPageRoute.dart';
import '../../Utils/SearchBar.dart';
import '../Widget/ModelCard.dart';

class MModelListScreen extends StatefulWidget {
  final String Brandid;
  const MModelListScreen({super.key, required this.Brandid});

  @override
  State<MModelListScreen> createState() => _MModelListScreenState();
}

class _MModelListScreenState extends State<MModelListScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('/Fixa/Brands');
  Map<String, List<Map<String, String>>> categorizedModels = {};
  List<String> modelNames = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _expandedSeries = Set<String>();

  @override
  void initState() {
    super.initState();
    fetchModels();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _searchQuery = _searchController.text.toLowerCase());
  }

  Future<void> fetchModels() async {
    try {
      final snapshot = await _databaseRef.child(widget.Brandid).child('Models').get();
      if (snapshot.exists) {
        final Map<String, List<Map<String, String>>> tempCategories = {};
        final List<String> tempModelNames = [];

        snapshot.children.forEach((child) {
          final value = child.value as Map<dynamic, dynamic>? ?? {};
          final model = {
            'name': value['ModelName']?.toString() ?? '',
            'image': value['ModelImage']?.toString() ?? '',
            'modelId': child.key?.toString() ?? '',
            'brandId': value['BrandId']?.toString() ?? '',
            'series': value['Series']?.toString() ?? 'Others',
          };

          final series = model['series']!;
          if (!tempCategories.containsKey(series)) {
            tempCategories[series] = [];
          }
          tempCategories[series]!.add(model);
          tempModelNames.add(model['name']!);
        });

        setState(() {
          categorizedModels = tempCategories;
          modelNames = tempModelNames;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching models: $e');
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, String>> _filterModels(List<Map<String, String>> models) {
    return models.where((model) =>
        model['name']!.toLowerCase().contains(_searchQuery)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Choose your Model', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SearchWidget(
            searchController: _searchController,
            searchHints: modelNames,
          ),
          Expanded(
            child: categorizedModels.isEmpty
                ? Center(child: Text('No models available'))
                : _buildSeriesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSeriesList() {
    return ListView(
      children: categorizedModels.entries.map((entry) {
        final seriesName = entry.key;
        final filteredModels = _filterModels(entry.value);
        final hasMatches = filteredModels.isNotEmpty;

        if (!hasMatches && _searchQuery.isNotEmpty) return SizedBox.shrink();

        return Card(
          color:Colors.white,
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              ListTile(
                title: Text(seriesName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary
                  ),
                ),
                trailing: Icon(
                  _expandedSeries.contains(seriesName)
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: AppColors.primary,
                ),
                onTap: () => setState(() {
                  _expandedSeries.contains(seriesName)
                      ? _expandedSeries.remove(seriesName)
                      : _expandedSeries.add(seriesName);
                }),
              ),
              if (_expandedSeries.contains(seriesName) && hasMatches)
                _buildModelGrid(filteredModels),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildModelGrid(List<Map<String, String>> models) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemCount: models.length,
        itemBuilder: (context, index) {
          final model = models[index];
          return ModelCard(
            modelName: model['name']!,
            modelId: model['modelId']!,
            brandId: model['brandId']!,
            modelImage: model['image']!,
            onPress: () => Navigator.push(
              context,
              CustomPageRoute(
                page: MServiceListScreen(
                  modelId: model['modelId']!,
                  brandlId: model['brandId']!,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}