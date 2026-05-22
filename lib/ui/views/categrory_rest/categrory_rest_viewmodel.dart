import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CategroryRestViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  final int catId;
  final _navigationService = locator<NavigationService>();

  List<Restaurant> restaurantList = [];
  late bool isGrocery;

  CategroryRestViewModel(this.catId, this.isGrocery) {
    if (isGrocery) {
      getAllGroceries();
    } else {
      getCatRestaurants(catId);
    }
  }
//  get specific Restaurant Products"
//  getSingleRestaurantItems(int id) async {
//     setBusy(true);
//     final response = await _dbService.fetchCategoryRestaurants(id);
//     if (response.success) {
//       restaurantList = response.restaurantList ?? [];
//     } else {}
//     setBusy(false);
//   }

  void navigateToDetail(Restaurant res) {
    _navigationService.navigateToRestaurantDetailView(
        restaurantId: res.id, restaurant: res);
  }

  getCatRestaurants(int id) async {
    setBusy(true);
    final response = await _dbService.fetchCategoryRestaurants(id);
    if (response.success) {
      restaurantList = response.restaurantList ?? [];
    } else {}
    setBusy(false);
  }

  List<Restaurant> groceriesList = [];

  ///get All groceries
  Future<void> getAllGroceries() async {
    setBusy(true);
    RestaurantsResponse response = await _dbService.getAllGroceries();
    if (response.success) {
      ///
      groceriesList = response.restaurantList ?? [];
    } else {
      ///
    }
    setBusy(false);
  }
}
