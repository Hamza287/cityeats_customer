import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ShowfilerdataViewModel extends BaseViewModel {
  List<Restaurant> listRestaurant = [];
  List<Restaurant> favRestaurantList = [];
  final _dbService = locator<DatabaseService>();
  final _navigationService = locator<NavigationService>();
  final GlobalLocationViewModel _locationViewModel = GlobalLocationViewModel();

  final RestaurantsResponse response;

  ShowfilerdataViewModel(this.response) {
    listRestaurant = response.restaurantList ?? [];
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
  Future<void> back() async {
    _navigationService.back();
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
