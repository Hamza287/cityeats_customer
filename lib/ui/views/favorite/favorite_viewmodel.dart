import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/services/local_storage_service.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FavoriteViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dbService = locator<DatabaseService>();
  final GlobalLocationViewModel _locationViewModel = GlobalLocationViewModel();
  final localStorageService = locator<LocalStorageService>();

  List<Restaurant> favRestaurantList = [];

  FavoriteViewModel() {
    getFavRestaurants();
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
    favRestaurantList.removeWhere((element) => res.id == element.id);
    toggleFavRestaurant(res.id);
  }

  //restaurant detail view
  Future<void> navigateToDetail(Restaurant res) async {
    await _navigationService.navigateToRestaurantDetailView(
        restaurantId: res.id, restaurant: res);
    // init();
  }

  getSelectedAddressId() {
    if (_locationViewModel.getSelectedAddress != null) {
      return _locationViewModel.getSelectedAddress?.id;
    }
  }

  ///get fav res
  Future<void> getFavRestaurants() async {
    setBusy(true);
    RestaurantsResponse favRestaurantRes =
        await _dbService.fetchFavoriteRestaurants(
            getSelectedAddressId() ?? localStorageService.addressId);
    if (favRestaurantRes.success) {
      ///
      favRestaurantList = favRestaurantRes.restaurantList ?? [];

      // doubleList(favRestaurantRes.restaurantList ?? []);
    } else {
      ///
    }
    setBusy(false);
  }

  doubleList(List<Restaurant> favList) {
    // favList[3] = favList.first;
    // favList[4] = favList.last;
    for (var element in favList) {
      favRestaurantList.add(element);
    }
    // for (int i = 0; i < 10; i++) {
    //   favRestaurantList.add(favList[1]);
    // }
    rebuildUi();
  }
}
