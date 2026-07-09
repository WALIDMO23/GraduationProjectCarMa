import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:graduation_project/core/constants/app_constants.dart';
import 'package:graduation_project/core/comeponents/app_button.dart';
import 'package:graduation_project/core/theme/app_theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  MapLibreMapController? mapController;
  LatLng _currentCenter = const LatLng(30.0444, 31.2357);
  String _currentAddress = 'جاري تحديد الموقع...';
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentCenter = LatLng(position.latitude, position.longitude);
      });
      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentCenter, zoom: 15),
        ));
      }
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isSearching = true);
    try {
      final url = 'https://places.geo.${AppConstants.amazonLocationRegion}.amazonaws.com/v2/search-text?key=${AppConstants.amazonLocationApiKey}';
      final response = await _dio.post(
        url,
        data: {'QueryText': query},
      );
      
      if (mounted) {
        setState(() {
          _searchResults = response.data['ResultItems'] ?? [];
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isSearching = false);
      print("Search Error: $e");
    }
  }

  void _onResultSelected(dynamic result) {
    final point = result['Position'];
    final lat = point[1].toDouble();
    final lng = point[0].toDouble();
    final address = result['Title'] ?? result['Address'] ?? 'موقع مختار';

    setState(() {
      _currentCenter = LatLng(lat, lng);
      _currentAddress = address;
      _searchResults = [];
      _searchController.text = address;
    });

    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentCenter, zoom: 16),
      ));
    }
  }

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
  }

  void _onCameraIdle() {
    setState(() {
      _currentAddress = "الموقع المختار: (${_currentCenter.latitude.toStringAsFixed(4)}, ${_currentCenter.longitude.toStringAsFixed(4)})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map Background
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: MapLibreMap(
              styleString: 'https://maps.geo.${AppConstants.amazonLocationRegion}.amazonaws.com/v2/styles/${AppConstants.amazonLocationStyleName}/descriptor?key=${AppConstants.amazonLocationApiKey}',
              initialCameraPosition: CameraPosition(target: _currentCenter, zoom: 14),
              onMapCreated: _onMapCreated,
              onCameraIdle: _onCameraIdle,
              onCameraMove: (position) {
                _currentCenter = position.target;
              },
              myLocationEnabled: true,
              myLocationRenderMode: MyLocationRenderMode.normal,
              myLocationTrackingMode: MyLocationTrackingMode.none,
              compassEnabled: false,
            ),
          ),

          // Search Bar at the Top (Interactive UI placeholder)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              children: [
                // Back Button
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                const SizedBox(width: 12),
                // Search Input Field Simulator
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _searchPlaces,
                          decoration: InputDecoration(
                            hintText: 'ابحث عن موقعك...',
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
                            suffixIcon: _isSearching 
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : null,
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      if (_searchResults.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 250),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final result = _searchResults[index];
                                return ListTile(
                                  title: Text(result['Title'] ?? ''),
                                  subtitle: Text(result['Address'] ?? ''),
                                  leading: const Icon(Icons.location_on_outlined),
                                  onTap: () => _onResultSelected(result),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // "My Location" FAB mapped to bottom right above sheet
          Positioned(
            bottom: 280, // Above the bottom sheet height approx
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.surface,
              onPressed: () {
                if (mapController != null) {
                  mapController!.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: _currentCenter, zoom: 15),
                  ));
                }
              },
              child: const Icon(Icons.my_location, color: AppTheme.primaryColor),
            ),
          ),

          // Floating Pin Marker in the Center (Constant UI element)
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 48,
                    color: AppTheme.primaryColor,
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Selection Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                   SizedBox(height: 24),
                   Text(
                    'تأكيد موقعك الحالي',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest ,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                         Container(
                           padding: const EdgeInsets.all(10),
                           decoration: BoxDecoration(
                             color: AppTheme.primaryColor.withValues(alpha: 0.1),
                             shape: BoxShape.circle,
                           ),
                           child: const Icon(
                             Icons.location_city,
                             color: AppTheme.primaryColor,
                           ),
                         ),
                         SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Text(
                                'القاهرة، مصر',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _currentAddress,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Edit Icon
                        Icon(Icons.edit_location_alt, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'تأكيد الموقع والمتابعة',
                    onPressed: () {
                      Navigator.pop(context, {
                        'address': _currentAddress,
                        'lat': _currentCenter.latitude,
                        'lng': _currentCenter.longitude,
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

