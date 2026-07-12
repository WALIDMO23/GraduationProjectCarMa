import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/core/comeponents/app_button.dart';
import 'package:graduation_project/views/services/payment_methods.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map Background
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
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
                          '╪د╪ذ╪ص╪س ╪╣┘ ┘à┘ê┘é╪╣┘â...',
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
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
              },
              child: Icon(Icons.my_location, color: Theme.of(context).colorScheme.primary),
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
                    Icon(
                    Icons.location_on,
                    size: 56,
                    color: Theme.of(context).colorScheme.primary,
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
                    '╪ز╪ث┘â┘è╪» ┘à┘ê┘é╪╣┘â ╪د┘╪ص╪د┘┘è',
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
                      border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                         Container(
                           padding: const EdgeInsets.all(10),
                           decoration: BoxDecoration(
                             color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                             shape: BoxShape.circle,
                           ),
                           child:  Icon(
                             Icons.location_city,
                             color: Theme.of(context).colorScheme.primary,
                           ),
                         ),
                         SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Text(
                                '╪د┘┘é╪د┘ç╪▒╪ر╪î ┘à╪╡╪▒',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '╪د┘┘à╪╣╪د╪»┘è╪î ╪┤╪د╪▒╪╣ 9╪î ╪ذ╪ش┘ê╪د╪▒ ╪د┘┘à╪ص╪╖╪ر',
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
                    text: '╪ز╪ث┘â┘è╪» ╪د┘┘à┘ê┘é╪╣ ┘ê╪د┘┘à╪ز╪د╪ذ╪╣╪ر',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentMethodsPage(),
                        ),
                      );
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

