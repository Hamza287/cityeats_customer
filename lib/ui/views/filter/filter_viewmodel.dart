import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/models/filter.dart';
import 'package:city_customer_app/responses/categories_response.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/services/database_service.dart';

import 'package:city_customer_app/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FilterViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _locationService = locator<LocationService>();
  final _dbService = locator<DatabaseService>();

  int selectedSort = 0;
  // double lowerPriceValue = 0.0;
  // double upperPriceValue = 100.0;
  double lowerRatingValue = 0;
  double upperRatingValue = 5;
  // double lowerDistanceValue = 0;
  // double upperDistanceValue = 15;
  FilterBody filterBody = FilterBody(
      // category: '',
      // minPrice: 0,
      // maxPrice: 0,
      // minDistance: 0,
      // maxDistance: 0,
      // minRating: 0,
      // maxRating: 0,
      // lat: 0,
      // lng: 0
      );

  List<int> offers = [];

  List<String> listOfSorting = [
    "Category",
    "Price Range",
    "Distance",
    "Rating"
  ];

  List<String> offersList = [
    "Accept Offer",
    "Free Offer",
  ];

  FilterViewModel() {
    // lowerPriceValue = filterBody.minPrice ?? 0;
    // upperPriceValue = filterBody.maxPrice ?? 0;
    // if (filterBody.lat == 0) {
    //   ///get current location lat lng
    getCurrentLocation();
    getCategories();
    // }
  }

  getCurrentLocation() async {
    Position? position = await _locationService.getCurrentLocation();
    if (position != null) {
      filterBody.lat = position.latitude;
      filterBody.lng = position.longitude;
    }
    rebuildUi();
  }

  updatePrice(min, max) {
    filterBody.maxPrice = max;
    filterBody.minPrice = min;
    // lowerPriceValue = min;
    // upperPriceValue = max;
    rebuildUi();
  }

  updateRating(min, max) {
    filterBody.minRating = min;
    filterBody.maxRating = max;
    lowerRatingValue = min;
    upperRatingValue = max;
    rebuildUi();
  }

  navigateToHomeBack() {
    _navigationService.back();
  }

  List<Category> categoryList = [];

  ///get Categories
  Future<void> getCategories() async {
    setBusy(true);
    CategoriesResponse categoriesResponse = await _dbService.fetchCategories();
    if (categoriesResponse.success) {
      ///
      categoryList = categoriesResponse.categoryList;
    } else {
      ///
    }
    setBusy(false);
  }

  Future<void> filter() async {
    setBusy(true);
    RestaurantsResponse response = await _dbService.filter(filterBody);
    if (response.success) {
      ///
      navigateToFilterShowData(response);
    } else {}

    setBusy(false);
  }

  navigateToFilterShowData(RestaurantsResponse response) {
    _navigationService.navigateToShowfilerdataView(response: response);
  }
}
