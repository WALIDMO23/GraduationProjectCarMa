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
  final FocusNode _searchFocusNode = FocusNode();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  bool _showResults = false;
  bool _isAnimatingToSelection = false;
  Timer? _debounce;

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus && mounted) {
        setState(() => _showResults = false);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _dio.close();
    super.dispose();
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
      await _reverseGeocode(_currentCenter);
    }
  }

  /// Debounce search to avoid calling API on every keystroke
  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _showResults = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchPlaces(query.trim());
    });
  }

  Future<void> _searchPlaces(String query) async {
    if (!mounted) return;
    setState(() {
      _isSearching = true;
      _showResults = true;
    });

    try {
      // Amazon Location Service – Places v2 search-text endpoint
      final url =
          'https://places.geo.${AppConstants.amazonLocationRegion}.amazonaws.com/v2/search-text';
      final response = await _dio.post(
        url,
        queryParameters: {'key': AppConstants.amazonLocationApiKey},
        data: {
          'QueryText': query,
          'MaxResults': 8,
          'BiasPosition': [_currentCenter.longitude, _currentCenter.latitude],
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (!mounted) return;

      final items = response.data['ResultItems'] as List<dynamic>? ?? [];
      setState(() {
        _searchResults = items;
        _isSearching = false;
        _showResults = items.isNotEmpty;
      });

      debugPrint('[LocationPicker] Search "$query" → ${items.length} results');
    } on DioException catch (e) {
      debugPrint('[LocationPicker] Search error: ${e.message} | ${e.response?.data}');
      if (mounted) setState(() => _isSearching = false);
    } catch (e) {
      debugPrint('[LocationPicker] Unexpected error: $e');
      if (mounted) setState(() => _isSearching = false);
    }
  }

  /// Extract human-readable label from a result item
  String _getResultLabel(dynamic result) {
    // Title is the primary name (e.g. "Cairo")
    final title = result['Title'] as String?;
    // Address object may contain a nested Label
    final addressObj = result['Address'];
    String? addressLabel;
    if (addressObj is Map) {
      addressLabel = addressObj['Label'] as String?;
    } else if (addressObj is String) {
      addressLabel = addressObj;
    }
    return title ?? addressLabel ?? 'موقع مختار';
  }

  String _getResultSubtitle(dynamic result) {
    final addressObj = result['Address'];
    if (addressObj is Map) {
      final parts = <String>[];
      final street = addressObj['Street'] as String?;
      final city = addressObj['Municipality'] as String?;
      final country = addressObj['Country'] as String?;
      if (street != null) parts.add(street);
      if (city != null) parts.add(city);
      if (country != null) parts.add(country);
      return parts.join(', ');
    }
    return '';
  }

  LatLng? _extractPosition(dynamic result) {
    // Position is [longitude, latitude] per Amazon Location Service spec
    final pos = result['Position'];
    if (pos is List && pos.length >= 2) {
      final lng = (pos[0] as num).toDouble();
      final lat = (pos[1] as num).toDouble();
      return LatLng(lat, lng);
    }
    return null;
  }

  Future<void> _onResultSelected(dynamic result) async {
    // Try extracting position directly from the result
    LatLng? position = _extractPosition(result);

    // Fallback: resolve via PlaceId if Position is missing (countries, regions, etc.)
    if (position == null) {
      final placeId = result['PlaceId'] as String?;
      if (placeId != null) {
        debugPrint('[LocationPicker] Position missing, resolving via PlaceId: $placeId');
        position = await _resolvePositionByPlaceId(placeId);
      }
    }

    if (position == null) {
      debugPrint('[LocationPicker] Could not extract position from result: $result');
      return;
    }

    final label = _getResultLabel(result);
    final subtitle = _getResultSubtitle(result);
    // Use the combined label+subtitle as the display address for richer context
    final displayAddress = subtitle.isNotEmpty ? '$label, $subtitle' : label;

    setState(() {
      _isAnimatingToSelection = true;
      _currentCenter = position!;
      _currentAddress = displayAddress;
      _searchResults = [];
      _showResults = false;
      _searchController.text = label;
    });

    _searchFocusNode.unfocus();

    // Move camera to selected location
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position, zoom: 16),
    ));

    // Wait for animation to complete before allowing reverse geocoding again.
    // This prevents onCameraIdle from overwriting the search result address.
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isAnimatingToSelection = false);
      }
    });
  }

  /// Resolve coordinates from a PlaceId when the search result doesn't include Position.
  Future<LatLng?> _resolvePositionByPlaceId(String placeId) async {
    try {
      final url =
          'https://places.geo.${AppConstants.amazonLocationRegion}.amazonaws.com/v2/get-place';
      final response = await _dio.post(
        url,
        queryParameters: {'key': AppConstants.amazonLocationApiKey},
        data: {'PlaceId': placeId},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        final pos = response.data['Position'];
        if (pos is List && pos.length >= 2) {
          final lng = (pos[0] as num).toDouble();
          final lat = (pos[1] as num).toDouble();
          debugPrint('[LocationPicker] PlaceId resolved → ($lat, $lng)');
          return LatLng(lat, lng);
        }
      }
    } on DioException catch (e) {
      debugPrint('[LocationPicker] PlaceId resolve error: ${e.message}');
    } catch (e) {
      debugPrint('[LocationPicker] PlaceId resolve unexpected: $e');
    }
    return null;
  }

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
  }

  Future<void> _reverseGeocode(LatLng position) async {
    try {
      final url =
          'https://places.geo.${AppConstants.amazonLocationRegion}.amazonaws.com/v2/reverse-geocode';
      final response = await _dio.post(
        url,
        queryParameters: {'key': AppConstants.amazonLocationApiKey},
        data: {
          'QueryPosition': [position.longitude, position.latitude],
          'MaxResults': 1,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final results = response.data['ResultItems'] as List<dynamic>?;
        if (results != null && results.isNotEmpty) {
          final first = results[0];
          final label = _getResultLabel(first);
          if (mounted) {
            setState(() => _currentAddress = label);
          }
          return;
        }
      }
    } on DioException catch (e) {
      debugPrint('[LocationPicker] Reverse geocode error: ${e.message}');
    } catch (e) {
      debugPrint('[LocationPicker] Reverse geocode unexpected: $e');
    }

    if (mounted) {
      setState(() {
        _currentAddress =
            'الموقع المختار: (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})';
      });
    }
  }

  void _onCameraIdle() {
    // Skip reverse geocoding while the camera is animating to a search result
    // to prevent the carefully-set search address from being overwritten.
    if (_isAnimatingToSelection) return;
    _reverseGeocode(_currentCenter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Background
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: MapLibreMap(
              styleString:
                  'https://maps.geo.${AppConstants.amazonLocationRegion}.amazonaws.com/v2/styles/${AppConstants.amazonLocationStyleName}/descriptor?key=${AppConstants.amazonLocationApiKey}',
              initialCameraPosition: CameraPosition(target: _currentCenter, zoom: 14),
              onMapCreated: _onMapCreated,
              onCameraIdle: _onCameraIdle,
              onCameraMove: (position) {
                _currentCenter = position.target;
              },
              onMapClick: (point, coordinates) {
                mapController?.animateCamera(
                  CameraUpdate.newLatLng(coordinates),
                );
              },
              myLocationEnabled: true,
              myLocationRenderMode: MyLocationRenderMode.normal,
              myLocationTrackingMode: MyLocationTrackingMode.none,
              compassEnabled: false,
            ),
          ),

          // Search Bar + Suggestions Overlay
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
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
                        child: Icon(Icons.arrow_back,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Search TextField
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: _onSearchChanged,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (v) {
                            if (v.trim().isNotEmpty) _searchPlaces(v.trim());
                          },
                          decoration: InputDecoration(
                            hintText: 'ابحث عن أي مكان... (Tokyo, Paris, القاهرة)',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                            icon: Icon(Icons.search,
                                color: Theme.of(context).colorScheme.onSurfaceVariant),
                            suffixIcon: _isSearching
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2)),
                                  )
                                : _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 18),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            _searchResults = [];
                                            _showResults = false;
                                          });
                                        },
                                      )
                                    : null,
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),

                // Suggestions Dropdown
                if (_showResults && _searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8, left: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          final title = _getResultLabel(result);
                          final subtitle = _getResultSubtitle(result);
                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.location_on_outlined,
                                  color: AppTheme.primaryColor, size: 18),
                            ),
                            title: Text(
                              title,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: subtitle.isNotEmpty
                                ? Text(subtitle,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)
                                : null,
                            onTap: () => _onResultSelected(result),
                            dense: true,
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // My Location FAB
          Positioned(
            bottom: 280,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.surface,
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location, color: AppTheme.primaryColor),
            ),
          ),

          // Center Pin Marker
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
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

          // Bottom Confirmation Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: const [
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
                  const SizedBox(height: 24),
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
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3)),
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'الموقع المختار',
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
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.edit_location_alt, color: AppTheme.primaryColor),
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
