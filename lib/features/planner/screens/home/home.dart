//home_dart.
import 'dart:async';
import 'package:QoshKel/features/authentication/controllers/user_controller.dart';
import 'package:QoshKel/features/personalization/models/place_model.dart';
import 'package:QoshKel/features/services/directions_sevice.dart';
import 'package:QoshKel/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:QoshKel/features/planner/screens/home/widgets/background.dart';
import 'package:QoshKel/features/planner/screens/home/widgets/draggablesection.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title, required this.onShowRoute,});
  final String title;
  final Function(LatLng) onShowRoute;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  final Completer<GoogleMapController> _controller = Completer();
  final Location _location = Location();
  LatLng? _currentPosition;
  Set<Polyline> _polylines = {};


  // Draggable section state
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  bool _isSearching = false;
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _budgetFocusNode = FocusNode();

  final TextEditingController _searchController = TextEditingController();

  final double _initialSize = 0.5; // 60% of screen
  final double _minSize = 0.12; // Just search bar visible
  final double _expandedSize = 0.8; // Near full screen for search

  @override
  void initState() {
    super.initState();
    _initLocation();
    _sheetController.addListener(_handleSheetChanges);
  }

  void _handleSheetChanges() {
    if (!_sheetController.isAttached) return;

    final size = _sheetController.size;
    if (!_isSearching && size < _initialSize - 0.1 && size > _minSize + 0.05) {
      _sheetController.animateTo(
        _minSize,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _onSearchTapped() {
    setState(() => _isSearching = true);
    _sheetController.animateTo(
      _expandedSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _exitSearch() {
    setState(() => _isSearching = false);
    _searchFocusNode.unfocus();
    _budgetFocusNode.unfocus();
    _sheetController.animateTo(
      _initialSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

void _showRoute(LatLng destination) async {
  if (_currentPosition == null) return;


/// MY API KEY
  final directionsService = DirectionsService('AIzaSyAzybIHmrqZyR3qo-M26uBoBJBpjMvVOso');
  
  final directions = await directionsService.getDirections(
    _currentPosition!,
    destination,
  );

  if (directions == null) return;

  setState(() {
    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: directions.polylinePoints,
      ),
    };
  });

  final controller = await _controller.future;
  controller.animateCamera(
    CameraUpdate.newLatLngBounds(directions.bounds, 100),
  );
}

  Future<void> _initLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await _location.requestService();
    if (!serviceEnabled) return;

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final loc = await _location.getLocation();
    setState(() {
      _currentPosition = LatLng(loc.latitude!, loc.longitude!);
    });

    _moveCamera(_currentPosition!, initial: true);

    _location.onLocationChanged.listen((loc) {
      if (!mounted) return;
      final updatedPos = LatLng(loc.latitude!, loc.longitude!);
      setState(() {
        _currentPosition = updatedPos;
      });
    });
  }

  Future<void> _moveCamera(LatLng target, {bool initial = false}) async {
    final controller = await _controller.future;

    final cameraUpdate = initial
        ? CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(target.latitude - 0.0040,
                  target.longitude), // slight offset upward
              zoom: 15.0,
            ),
          )
        : CameraUpdate.newLatLng(target);

    controller.animateCamera(cameraUpdate);
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _searchFocusNode.dispose();
    _budgetFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

      @override
        Widget build(BuildContext context) {

          final controller = Get.put(UserController());
          
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: <Widget>[
                BackgroundImage(
                  mapWidget: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          if (_currentPosition != null) {
            _moveCamera(_currentPosition!);
          }
        },
        initialCameraPosition: CameraPosition(
          target: _currentPosition ?? const LatLng(51.1284, 71.4307),
          zoom: 12.0,
        ),
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
      // Add this line
      ),
          ),
          Positioned(
            right: 16,
            top: MediaQuery.of(context).padding.top + 16,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isSearching ? 0.0 : 1.0,
              child: FloatingActionButton(
                tooltip: 'Go to my location',
                onPressed: () {
                  if (_currentPosition != null) {
                    _moveCamera(_currentPosition!);
                  }
                },
                backgroundColor: Colors.white,
                mini: true,
                child: const Icon(Icons.my_location, color: TColors.primary),
              ),
            ),
          ),
           DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: _initialSize,
            minChildSize: _minSize,
            maxChildSize: 1.0,
            snap: true,
            snapSizes: [_minSize, _initialSize, _expandedSize],
            builder: (context, scrollController) {
              return DraggableSection(
                scrollController: scrollController,
                isSearching: _isSearching,
                onSearchTapped: _onSearchTapped,
                onExitSearch: _exitSearch,
                searchFocusNode: _searchFocusNode,
                searchController: _searchController,
                budgetFocusNode: _budgetFocusNode,
                onShowRoute: _showRoute,
              );
            },
          ),
        ],
      ),
    );
  }
}