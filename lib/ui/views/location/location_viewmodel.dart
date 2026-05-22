// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:city_customer_app/app/app.bottomsheets.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/models/location_body.dart';
import 'package:city_customer_app/responses/addresses_response.dart';
import 'package:city_customer_app/responses/maps_api_response/place_address.dart';
import 'package:city_customer_app/responses/maps_api_response/places_response.dart';
import 'package:city_customer_app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LocationViewModel extends BaseViewModel {
  final LatLng center = const LatLng(34.00557, 71.544687);
  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();
  final _bottomSheetService = locator<BottomSheetService>();
  final _locationService = locator<LocationService>();
  final log = getLogger("LocationViewModel");

  late BitmapDescriptor currentLocationIcon;
  Set<Marker> markers = <Marker>{};
  late LatLng markerPosition;

  Completer<GoogleMapController> completeController =
      Completer<GoogleMapController>();
  GoogleMapController? googleMapController;
  Position? currentPosition;

  LatLng? selectedLocationLatLng;
  LatLng? currentLatLng;
  String? selectedLocationText;
  bool isLocationSearched = false;
  PlaceApiResponse? placeApiResponse;
  List<Predictions> prediction = [];
  String currentLocationName = '';
  TextEditingController locController = TextEditingController();
  FocusNode locFocusNode = FocusNode();

  LocationBody? locationBody = LocationBody();
  PlaceAddressResponse? placeAddressResponse;
  LocationAddress? previousAddress;

  bool isUpdateLocation = false;
  bool isLocationLoading = true;

  LocationViewModel(this.previousAddress) {
    if (previousAddress != null) {
      isUpdateLocation = true;
      isLocationLoading = false;
    } else {
      // Get current location before showing map to avoid showing Peshawar
      initializeLocation();
    }
  }

  Future<void> initializeLocation() async {
    isLocationLoading = true;
    rebuildUi();
    try {
      await getCurrentLocation();
      if (currentPosition != null) {
        _setupCustomMarkers();
        addMarker(currentPosition!);
      }
    } catch (e) {
      log.e("Error getting current location: $e");
    } finally {
      isLocationLoading = false;
      rebuildUi();
    }
  }

  updateFromPreviousData() {
    if (previousAddress == null) {
      // fetchCurrentLocationName(latLng);
      return;
    }
    locationBody?.id = previousAddress?.id;
    locationBody?.fullAddress = previousAddress?.address;

    locationBody?.name = previousAddress?.address?.split(",").first;
    locationBody?.streetAddress = previousAddress?.address?.split(",").last;
    locationBody?.lat = double.parse((previousAddress?.lat ?? 0.0).toString());
    locationBody?.lng = double.parse((previousAddress?.lang ?? 0.0).toString());
    locationBody?.lng = double.parse((previousAddress?.lang ?? 0.0).toString());
    locController.text = previousAddress?.address ?? "";

    currentPosition = Position(
        latitude:
            double.parse((previousAddress?.lat ?? center.latitude).toString()),
        longitude: double.parse(
            (previousAddress?.lang ?? center.longitude).toString()),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
        timestamp: DateTime.now());
    rebuildUi();
    addMarker(currentPosition!);
    animateToCurrentLocation();

    log.wtf("@updateFromPreviousData ======> $currentPosition");
  }

  updateType() {
    if (previousAddress != null) {
      locationBody?.label = previousAddress?.type;
    }
  }

  void showBottomSheet() {
    log.wtf("@updateFromPreviousData ======> ${locationBody?.toJson()}");

    _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.mapAddress,
        isScrollControlled: true,
        data: locationBody);
  }

  Future<void> getCurrentLocation() async {
    currentPosition = await _locationService.getCurrentLocation();
    currentLatLng =
        LatLng(currentPosition?.latitude ?? 0, currentPosition?.longitude ?? 0);
    log.wtf(currentLatLng);
    rebuildUi();
  }

  void onMapCreated(GoogleMapController controller) async {
    completeController.complete(controller);
    googleMapController = controller;
    log.wtf("@onMapCreated ======> $currentPosition");
    log.wtf("@previousAddress ======> $previousAddress");
    if (previousAddress != null) {
      updateType();
      updateFromPreviousData();
    } else {
      // Location should already be loaded from initializeLocation()
      if (currentPosition != null) {
        animateToCurrentLocation();
        checkAndGetCurrentLocationName();
      } else {
        // Fallback: try to get location if not already loaded
        setLocationAndMarker();
      }
    }
  }

  Future<void> setLocationAndMarker() async {
    unFocusField();
    if (currentPosition != null) {
      clearPredictionList();
      // clearControllerData();
      isLocationSearched = false;
      // addMarker(currentPosition!);
      rebuildUi();
    } else {
      await getCurrentLocation();
      _setupCustomMarkers();
    }
    if (currentPosition != null) addMarker(currentPosition!);

    ///
    animateToCurrentLocation();
    checkAndGetCurrentLocationName();
  }

  void unFocusField() {
    focusNode.canRequestFocus = false;
    focusNode.unfocus();
  }

  void clearControllerData() {
    locController.clear();
    rebuildUi();
  }

  void checkAndGetCurrentLocationName() async {
    if (currentLocationName.isEmpty) {
      log.wtf("@currentLocationName is empty");
      if (currentLatLng != null) {
        log.wtf("@currentLatLng is null");
        await fetchCurrentLocationName(currentLatLng!);
      } else {
        await getCurrentLocation();
        await fetchCurrentLocationName(currentLatLng!);
      }
    }
    if (currentLocationName.isNotEmpty) {
      locController.text = currentLocationName;
    }
    rebuildUi();
  }

  void clearPredictionList() {
    prediction.clear();
    rebuildUi();
  }

  void animateToCurrentLocation() {
    log.wtf("@animateToCurrentLocation ======> $currentPosition");
    if (currentPosition != null && googleMapController != null) {
      googleMapController?.animateCamera(CameraUpdate.newLatLng(LatLng(
          currentPosition!.latitude,
          currentPosition!.longitude)));
    }
  }

  LatLng get initialCameraPosition {
    if (currentPosition != null) {
      return LatLng(currentPosition!.latitude, currentPosition!.longitude);
    }
    return center;
  }

  void _setupCustomMarkers() async {
    currentLocationIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);

    rebuildUi();
  }

  void addMarker(Position position, {bool removeLocationCheck = false}) async {
    log.wtf("@addMarker position ======> $position ");
    LatLng markerLocation = LatLng(position.latitude, position.longitude);
    log.wtf("@addMarker before ======> $isLocationSearched ");
    selectedLocationLatLng = markerLocation;
    markers.clear();
    markers.add(
      Marker(
        position: markerLocation,
        markerId: const MarkerId('pin_location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Your selected location'),
      ),
    );

    log.wtf("@addMarker ======> $markerLocation ");
    if (removeLocationCheck) isLocationSearched = false;

    log.wtf("@addMarker after ======> $isLocationSearched ");
    rebuildUi();
  }

  void findPlace(String? placeName) async {
    if (placeName == "") {
      prediction = [];
      rebuildUi();
    }
    try {
      placeApiResponse =
          await _locationService.placeAutoComplete(placeName ?? "");
      if (placeApiResponse == null) return;

      if (placeApiResponse?.status == "OK") {
        prediction = placeApiResponse?.predictions ?? [];
        log.d(prediction);
        isLocationSearched = true;
      }
    } catch (e) {
      log.e("exception findPlace $e");
    }
    notifyListeners();
  }

  Future<void> fetchCurrentLocationName(LatLng latLng) async {
    log.wtf(latLng);
    LocationBody? locationBody =
        await _locationService.getAddressFromLatLng(latLng);

    currentLocationName = locationBody?.fullAddress ?? "";
    this.locationBody?.name = locationBody?.name;
    this.locationBody?.lat = locationBody?.lat;
    this.locationBody?.lng = locationBody?.lng;
    this.locationBody?.fullAddress = locationBody?.fullAddress;
    this.locationBody?.streetAddress = locationBody?.streetAddress;
    updateType();
    log.wtf(currentLocationName);
    rebuildUi();
  }

  getPlaceAddressDetails(String placeId) async {
    clearPredictionList();
    isLocationSearched = false;
    unFocusField();

    placeAddressResponse =
        await _locationService.getPlaceAddressDetails(placeId);
    log.wtf(placeAddressResponse?.toJson());
    final lat = placeAddressResponse?.locationBody?.lat ?? 0;
    final lng = placeAddressResponse?.locationBody?.lng ?? 0;
    currentLatLng = LatLng(lat, lng);
    rebuildUi();
    log.wtf("@getPlaceAddressDetails======> ${locationBody?.id}");
    updateLocationBody(placeAddressResponse?.locationBody);
    // animateToCurrentLocation();
    googleMapController?.animateCamera(CameraUpdate.newLatLng(LatLng(
        currentLatLng?.latitude ?? center.latitude,
        currentLatLng?.longitude ?? center.longitude)));

    log.wtf("@addMarker before ======> $isLocationSearched ");
    selectedLocationLatLng = currentLatLng;
    markers.clear();
    markers.add(
      Marker(
        position: selectedLocationLatLng ?? center,
        markerId: const MarkerId('pin_location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Your selected location'),
      ),
    );

    checkAndGetCurrentLocationName();

    rebuildUi();
  }

  updateLocationBody(LocationBody? body) {
    log.wtf("@updateLocationBody======> ${locationBody?.id}");
    int? id = locationBody!.id;
    // if (id != null) {}
    locationBody = body;
    locationBody?.id = id;

    log.wtf(locationBody?.id);
    updateType();
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    super.dispose();
  }
}
