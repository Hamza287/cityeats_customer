import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/models/location_body.dart';
import 'package:city_customer_app/responses/maps_api_response/place_address.dart';
import 'package:city_customer_app/responses/maps_api_response/places_response.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  final log = getLogger('LocationService');

  Position? currentLocation;
  double? latitude;
  double? longitude;
  Future<Position?> getCurrentLocation() async {
    // Test if location services are enabled.
    LocationPermission permission = await Geolocator.checkPermission();
    // Location services are not enabled don't continue
    // accessing the position and request users
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
          Exception('Location permissions are permanently denied.'),
        );
      }
    }

    // ignore: unrelated_type_equality_checks
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error(Exception('Location permissions are denied.'));
    }

    currentLocation = await Geolocator.getCurrentPosition();
    log.d(
        'Latitude: ${currentLocation!.latitude}, Longitude: ${currentLocation!.longitude}');
    return currentLocation;
  }

  Future<LocationBody?> getAddressFromLatLng(LatLng? location) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          location!.latitude, location.longitude);

      Placemark place = placeMarks[0];

      String address = '';
      if (place.thoroughfare != null && place.thoroughfare != '') {
        address += '${place.thoroughfare}, ';
      }
      if (place.subLocality != null && place.subLocality != '') {
        address += '${place.subLocality}, ';
      }
      if (place.locality != null && place.locality != '') {
        address += '${place.locality}, ';
      }
      if (place.country != null && place.country != '') {
        address += '${place.country}';
      }

      // Remove any trailing commas or whitespace
      address = address.replaceAll(RegExp(r',\s*$'), '');

      LocationBody locationBody = LocationBody(
        postalCode: place.postalCode,
        lat: location.latitude,
        lng: location.longitude,
        streetAddress: place.street,
        name: place.locality,
      );
      locationBody.fullAddress = address;

      return locationBody;
    } catch (e) {
      log.d("@getAddressFromLatLng Error $e");
      return null;
    }
  }

  Future<PlaceApiResponse> placeAutoComplete(String placeName) async {
    final dio = Dio();
    String autocompleteUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=AIzaSyBz6PIQnN_1FRE1s93NxI0g_unNRzPJf_s";
    // ${Env.mapApiKey}
    final response = await dio.get(autocompleteUrl);
    log.wtf(response);
    return PlaceApiResponse.fromJson(response.data);
  }

  Future<PlaceAddressResponse> getPlaceAddressDetails(String placeId) async {
    log.wtf("@getPlaceAddressDetails");

    late LocationBody locationBody;

    PlaceAddressResponse? placeAddressResponse;
    final dio = Dio();
    try {
      String placeAddressUrl =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyBz6PIQnN_1FRE1s93NxI0g_unNRzPJf_s";
      log.wtf(placeAddressUrl);
      final response = await dio.get(placeAddressUrl);

      placeAddressResponse = PlaceAddressResponse.fromJson(response.data);

      String postalCode = getPostalCode(placeAddressResponse);
      String locality = getLocality(placeAddressResponse);
      String subLocality = getSubLocality(placeAddressResponse);
      final location = placeAddressResponse.result?.geometry?.location;

      locationBody = LocationBody(
        postalCode: postalCode,
        lat: location?.lat,
        lng: location?.lng,
        streetAddress: subLocality,
        name: locality,
      );
      placeAddressResponse.locationBody = locationBody;
    } catch (e) {
      log.e("Exception in LocationService/getPlaceAddressDetails");
    }
    return placeAddressResponse!;
  }

  String getPostalCode(PlaceAddressResponse data) {
    String postalCode = '';

    List<AddressComponents> addressComponents =
        data.result?.addressComponents ?? [];

    for (var component in addressComponents) {
      log.wtf(component.types);
      if (component.types!.contains("postal_code")) {
        postalCode =
            component.longName ?? ""; // or use "short_name" if preferred
        break;
      }
    }
    log.wtf(postalCode);

    return postalCode;
  }

  String getLocality(PlaceAddressResponse data) {
    String locality = '';

    List<AddressComponents> addressComponents =
        data.result?.addressComponents ?? [];

    for (var component in addressComponents) {
      log.wtf(component.types);
      if (component.types!.contains("route")) {
        locality = component.longName ?? ""; // or use "short_name" if preferred
        break;
      }
    }
    log.wtf(locality);

    return locality;
  }

  String getSubLocality(PlaceAddressResponse data) {
    String subLocality = '';

    List<AddressComponents> addressComponents =
        data.result?.addressComponents ?? [];

    for (var component in addressComponents) {
      log.wtf(component.types);
      if (component.types!.contains("sub_locality")) {
        subLocality =
            component.longName ?? ""; // or use "short_name" if preferred
        break;
      }
    }
    log.wtf(subLocality);

    return subLocality;
  }

  LocationSearch? getLatLng(PlaceAddressResponse data) {
    String locality = '';

    Geometry geometry = data.result!.geometry!;

    geometry.location;
    log.wtf(locality);

    return geometry.location;
  }
}
