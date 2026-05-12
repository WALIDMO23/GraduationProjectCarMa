import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:graduation_project/core/constants/app_constants.dart';
import 'package:graduation_project/core/comeponents/app_button.dart';
import 'package:graduation_project/core/theme/app_theme.dart';
import 'package:graduation_project/views/services/payment_methods.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  MapLibreMapController? mapController;
  LatLng _currentCenter = const LatLng(30.0444, 31.2357);
  String _currentAddress = 'جاري تحديد الموقع...';

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357),
    zoom: 14.4746,
  );

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
  }

  void _onCameraIdle() {
    // In a real app, you would use reverse geocoding here with the Amazon Location Service
    // For now, we update the center and keep a placeholder address
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
              initialCameraPosition: _initialPosition,
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(
                          'ابحث عن موقعك...',
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
                        ),
                      ],
                    ),
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
                  mapController!.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
                }
              },
              child: const Icon(Icons.my_location, color: AppTheme.primaryColor),
            ),
          ),

          // Floating Pin Marker in the Center
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40), // Shift up to compensate for bottom sheet
              child: Stack(
                alignment: Alignment.center,
                children: [
                   // shadow
                   Container(
                     margin: const EdgeInsets.only(top: 40),
                     width: 16, height: 8,
                     decoration: BoxDecoration(
                       color: Colors.black.withAlpha(50),
                       borderRadius: BorderRadius.circular(10),
                     ),
                   ),
                   // Pin
                   const Icon(
                    Icons.location_on,
                    size: 56,
                    color: AppTheme.primaryColor,
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

