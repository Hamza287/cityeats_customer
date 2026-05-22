import 'dart:async';

import 'package:city_customer_app/app/app.bottomsheets.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/models/location_body.dart';
import 'package:city_customer_app/responses/maps_api_response/place_address.dart';
import 'package:city_customer_app/responses/maps_api_response/places_response.dart';
import 'package:city_customer_app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectMapLocationViewModel extends BaseViewModel {
  final LatLng center = const LatLng(34.00557, 71.544687);

  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();
  final _bottomSheetService = locator<BottomSheetService>();
  LocationBody? locationBody = LocationBody();
  // final _bottomSheetService = locator<BottomSheetService>();
  final _locationService = locator<LocationService>();
  final log = getLogger("SearchMapViewModel");

  final _navigationService = locator<NavigationService>();

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

  // LocationBody? locationBody = LocationBody();
  PlaceAddressResponse? placeAddressResponse;

  String? initialAddress;

  bool isUpdateLocation = false;
  bool isLocationLoading = true;

  SelectMapLocationViewModel() {
    // Get current location before showing map to avoid showing Peshawar
    initializeLocation();
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

  // LocationAddress? previousAddress;

  // MapLocationViewModel() {
  // log.wtf(previousAddress?.toJson());
  // }

  // updateType() {
  //   if (previousAddress != null) {
  //     locationBody?.label = previousAddress?.type;
  //   }
  // }

  navigateToBack() {
    _navigationService.back(result: locationBody);
  }

  Future<void> getCurrentLocation() async {
    log.d("@getCurrentLocation");
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

    // Location should already be loaded from initializeLocation()
    if (currentPosition != null) {
      animateToCurrentLocation();
      checkAndGetCurrentLocationName();
    } else {
      // Fallback: try to get location if not already loaded
      setLocationAndMarker();
    }
  }

  Future<void> setLocationAndMarker() async {
    log.d("setLocationAndMarker");
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
      }
    }
    if (currentLocationName.isNotEmpty) {
      // locController.text = currentLocationName;
    } else {}
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
    log.wtf("fetchAddressName: ");
    log.wtf(latLng);
    LocationBody? locationBody =
        await _locationService.getAddressFromLatLng(latLng);

    currentLocationName = locationBody?.fullAddress ?? "";
    this.locationBody?.name = locationBody?.name;
    this.locationBody?.lat = locationBody?.lat;
    this.locationBody?.lng = locationBody?.lng;
    this.locationBody?.fullAddress = locationBody?.fullAddress;
    this.locationBody?.streetAddress = locationBody?.streetAddress;

    log.d("nameD: ${this.locationBody?.name} ");

    // updateType();
    log.wtf(currentLocationName);
    locController.text = currentLocationName;
    rebuildUi();
  }

  getPlaceAddressDetails(String placeId) async {
    clearPredictionList();
    isLocationSearched = false;
    unFocusField();

    placeAddressResponse =
        await _locationService.getPlaceAddressDetails(placeId);
    log.wtf("PlaceAddressResponse : ${placeAddressResponse?.toJson()}");
    final lat = placeAddressResponse?.locationBody?.lat ?? 0;
    final lng = placeAddressResponse?.locationBody?.lng ?? 0;
    currentLatLng = LatLng(lat, lng);
    // locationBody = placeAddressResponse?.locationBody;

    log.wtf("CURRENT_LAT_lONG: $currentLatLng");

    rebuildUi();
    log.wtf(
        "@getPlaceAddressDetails======> ${placeAddressResponse!.locationBody?.id}");
    fetchCurrentLocationName(currentLatLng!);
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
    log.wtf("@updateLocationBody ======> ${body?.id}");
    int? id = locationBody!.id;
    // if (id != null) {}
    locationBody = body;
    locationBody?.id = id;

    log.wtf(locationBody?.id);
    // updateType();
  }

  void showBottomSheet() {
    log.wtf("@updateFromPreviousData ======> ${locationBody?.toJson()}");

    _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.mapAddress,
        isScrollControlled: true,
        data: locationBody);
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    super.dispose();
  }
}
