import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' hide Path;
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_cashed_image.dart';
import 'package:takos_corner_express/widgets/global/custom_snackbar.dart';
import 'package:takos_corner_express/widgets/home/restaurant_quick_peek_sheet.dart';

class RestaurantsMapView extends StatefulWidget {
  final List<RestaurantModel> restaurants;
  final bool displayModal;
  final bool showItinerary;
  final bool fullScreen;
  const RestaurantsMapView({
    super.key,
    required this.restaurants,
    this.displayModal = true,
    this.showItinerary = false,
    this.fullScreen = false,
  });

  @override
  State<RestaurantsMapView> createState() => _RestaurantsMapViewState();
}

class _RestaurantsMapViewState extends State<RestaurantsMapView> {
  int? _focusedId;
  bool _locating = false;
  bool _atUserLocation = false;
  LatLng? _userLocation;
  List<LatLng> _routePoints = [];
  bool _loadingRoute = false;
  final _mapController = MapController();

  late final LatLng _initialCenter;

  @override
  void initState() {
    super.initState();
    final restaurants = widget.restaurants;
    _initialCenter = restaurants.isEmpty
        ? const LatLng(36.8065, 10.1815)
        : LatLng(
            restaurants.map((r) => r.lat).reduce((a, b) => a + b) /
                restaurants.length,
            restaurants.map((r) => r.lng).reduce((a, b) => a + b) /
                restaurants.length,
          );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _onTapMarker(RestaurantModel restaurant) async {
    setState(() => _focusedId = restaurant.id);
    await showRestaurantQuickPeekSheet(context, restaurant);
    if (mounted) setState(() => _focusedId = null);
  }

  Future<void> _goToMyLocation() async {
    setState(() => _locating = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      final latlng = LatLng(pos.latitude, pos.longitude);
      if (mounted) {
        setState(() {
          _userLocation = latlng;
          _atUserLocation = true;
        });
      }
      _mapController.move(latlng, 15);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _resetToInitial() {
    _mapController.move(_initialCenter, 13.5);
  }

  void _openFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => Scaffold(
          body: SafeArea(
            child: RestaurantsMapView(
              restaurants: widget.restaurants,
              displayModal: widget.displayModal,
              showItinerary: widget.showItinerary,
              fullScreen: true,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchItinerary() async {
    if (_routePoints.isNotEmpty) {
      setState(() => _routePoints = []);
      return;
    }
    setState(() => _loadingRoute = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      final origin = LatLng(pos.latitude, pos.longitude);
      if (mounted) {
        setState(() {
          _userLocation = origin;
          _atUserLocation = false;
        });
      }
      final dest = widget.restaurants.first;
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${origin.longitude},${origin.latitude};${dest.lng},${dest.lat}'
        '?overview=full&geometries=geojson',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coords = data['routes'][0]['geometry']['coordinates'] as List;
        final points = coords
            .map(
              (c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
            )
            .toList();
        if (mounted) {
          setState(() => _routePoints = points);
          final allPoints = [origin, LatLng(dest.lat, dest.lng)];
          _mapController.fitCamera(
            CameraFit.coordinates(
              coordinates: allPoints,
              padding: EdgeInsets.all(40.w),
            ),
          );
        }
      } else {
        if (mounted) {
          CustomSnackbar.show(
            context,
            message: 'Could not fetch route',
            type: SnackbarType.error,
          );
        }
      }
    } catch (_) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: 'Could not fetch route',
          type: SnackbarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _loadingRoute = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = widget.restaurants;

    return Container(
      height: widget.fullScreen ? double.infinity : 320.h,
      width: widget.fullScreen ? double.infinity : null,
      margin: widget.fullScreen
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: 16.w),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: widget.fullScreen
            ? BorderRadius.zero
            : BorderRadius.circular(16.r),
        border: widget.fullScreen
            ? null
            : Border.all(color: context.borderColor, width: 0.5),
      ),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 13.5,
              onPositionChanged: (_, hasGesture) {
                if (hasGesture && _atUserLocation) {
                  setState(() => _atUserLocation = false);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: context.isDark
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: context.isDark
                    ? const ['a', 'b', 'c', 'd']
                    : const [],
                userAgentPackageName: 'com.takoskorner.express',
              ),
              MarkerLayer(
                markers: [
                  ...restaurants.map((r) {
                    return Marker(
                      point: LatLng(r.lat, r.lng),
                      width: 80.w,
                      height: 72.h,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.displayModal) {
                            _onTapMarker(r);
                          }
                        },
                        child: _RestaurantMarkerPin(
                          restaurant: r,
                          focused: _focusedId == r.id,
                        ),
                      ),
                    );
                  }),
                  if (_userLocation != null)
                    Marker(
                      point: _userLocation!,
                      width: 40.w,
                      height: 40.w,
                      child: _UserLocationMarker(),
                    ),
                ],
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 4,
                      color: context.tertiary,
                      borderStrokeWidth: 2,
                      borderColor: Colors.white.withValues(alpha: 0.6),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 8.h,
            left: 8.w,
            child: _MapFab(
              icon: widget.fullScreen
                  ? SolarIconsBold.minimize
                  : SolarIconsBold.maximize,
              tooltip: widget.fullScreen ? 'Collapse map' : 'Expand map',
              onTap: widget.fullScreen
                  ? () => Navigator.of(context).pop()
                  : _openFullScreen,
            ),
          ),
          if (widget.displayModal)
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${restaurants.length} places',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 12.h,
            right: 10.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showItinerary) ...[
                  _MapFab(
                    icon: _loadingRoute
                        ? SolarIconsBold.target
                        : _routePoints.isNotEmpty
                        ? SolarIconsBold.routing2
                        : SolarIconsOutline.routing2,
                    loading: _loadingRoute,
                    tooltip: _routePoints.isNotEmpty
                        ? 'Clear itinerary'
                        : 'Show itinerary',
                    onTap: _fetchItinerary,
                  ),
                  SizedBox(height: 8.h),
                ],
                _MapFab(
                  icon: _locating
                      ? SolarIconsBold.target
                      : _atUserLocation
                      ? SolarIconsBold.mapPointWave
                      : SolarIconsOutline.gps,
                  loading: _locating,
                  tooltip: 'My location',
                  onTap: _goToMyLocation,
                ),
                SizedBox(height: 8.h),
                _MapFab(
                  icon: SolarIconsBold.home2,
                  tooltip: 'Reset view',
                  onTap: _resetToInitial,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapFab extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool loading;
  const _MapFab({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: loading ? null : onTap,
        child: Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: context.cardColor,
            shape: BoxShape.circle,
            boxShadow: context.shadows,
          ),
          child: loading
              ? Padding(
                  padding: EdgeInsets.all(9.w),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primaryColor,
                  ),
                )
              : Icon(icon, size: 17.sp, color: primaryColor),
        ),
      ),
    );
  }
}

class _UserLocationMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.tertiary.withValues(alpha: 0.2),
            ),
          ),
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.tertiary,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: const [
                BoxShadow(color: Color(0x44000000), blurRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantMarkerPin extends StatelessWidget {
  final RestaurantModel restaurant;
  final bool focused;
  const _RestaurantMarkerPin({required this.restaurant, required this.focused});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: focused ? 1.15 : 1,
      duration: const Duration(milliseconds: 200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            padding: EdgeInsets.all(focused ? 3.w : 2.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: focused ? primaryColor : Colors.white,
                width: focused ? 3 : 2,
              ),
              boxShadow: const [
                BoxShadow(color: Color(0x33000000), blurRadius: 4),
              ],
            ),
            child: ClipOval(
              child: CustomCashedImage(
                restaurant.image,
                fit: BoxFit.cover,
                width: 40.w,
                height: 40.w,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Container(
            constraints: BoxConstraints(maxWidth: 78.w),
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: focused
                  ? primaryColor
                  : Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              restaurant.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
