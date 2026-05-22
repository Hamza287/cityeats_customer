import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/ui/views/root/root_viewmodel.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  final _navigationService = locator<NavigationService>();
  final GlobalLocationViewModel _locationViewModel = GlobalLocationViewModel();
  SearchViewModel() {
    getFavRestaurants();
  }
  List<Restaurant> listRestaurant = [];
  List<Restaurant> favRestaurantList = [];

  Future<void> search(String key) async {
    RestaurantsResponse res = await _dbService.search(key);
    if (res.success) {
      listRestaurant = res.restaurantList ?? [];
    } else {}
    rebuildUi();
  }

  ///add to Fav
  Future<void> toggleFavRestaurant(int restId) async {
    final res = await _dbService.toggleFavorite(restId);
    if (res['success']) {
    } else {
      ///
    }
    rebuildUi();
  }

  String hygineRating(int rating) {
    if (rating == 0) {
      return '$kcStaticImagesPath/zero_rat.png';
    } else if (rating == 1) {
      return "$kcStaticImagesPath/one_rat.png";
    } else if (rating == 2) {
      return "$kcStaticImagesPath/two_rat.png";
    } else if (rating == 3) {
      return "$kcStaticImagesPath/three_rat.png";
    } else if (rating == 4) {
      return "$kcStaticImagesPath/four_rat.png";
    } else if (rating == 5) {
      return "$kcStaticImagesPath/five_rat.png";
    } else {
      return '$kcStaticImagesPath/zero_rat.png';
    }
  }

  //
  toggleFav(Restaurant res) {
    res.isFav = !(res.isFav ?? false);
    rebuildUi();
    checkIsFavRestaurant(res)
        ? favRestaurantList.removeWhere((element) => res.id == element.id)
        : favRestaurantList.add(res);
    toggleFavRestaurant(res.id);
  }

  //restaurant detail view
  Future<void> navigateToDetail(Restaurant res) async {
    await _navigationService.navigateToRestaurantDetailView(
        restaurantId: res.id, restaurant: res);
  }

  //restaurant detail view
  Future<void> back(BuildContext context) async {
    // Navigate to home view (index 0) in root view
    try {
      final rootViewModel = Provider.of<RootViewModel>(context, listen: false);
      rootViewModel.togglePage(0, context);
    } catch (e) {
      // If RootViewModel is not available via Provider, fallback to navigation
      _navigationService.back();
    }
  }

  getSelectedAddressId() {
    if (_locationViewModel.getSelectedAddress != null) {
      return _locationViewModel.getSelectedAddress?.id;
    }
  }

  ///get fav res
  Future<void> getFavRestaurants() async {
    RestaurantsResponse favRestaurantRes =
        await _dbService.fetchFavoriteRestaurants(getSelectedAddressId());
    if (favRestaurantRes.success) {
      ///
      favRestaurantList = favRestaurantRes.restaurantList ?? [];
    } else {
      ///
    }
    rebuildUi();
  }

  ///
  checkIsFavRestaurant(Restaurant restaurant) {
    bool isFound = false;
    for (var element in favRestaurantList) {
      if (element.id == restaurant.id) {
        isFound = true;
      }
    }
    return isFound;
  }
}
