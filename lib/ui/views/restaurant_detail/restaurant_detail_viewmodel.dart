// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:city_customer_app/app/app.bottomsheets.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';
import 'package:city_customer_app/responses/single_restaurant_response.dart';
import 'package:city_customer_app/responses/specific_food_response.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/services/local_storage_service.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RestaurantDetailViewModel extends BaseViewModel {
  final log = getLogger("RestaurantDetailViewModel");
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final authService = locator<AuthService>();
  final _dbService = locator<DatabaseService>();
  final localStorageService = locator<LocalStorageService>();
  int restaurantId;
  List<RestaurantCategory> restaurantCat = [];
  Restaurant? restaurant;
  // Res? singleRestaurant;
  double? customerCharges;
  double? customerRadius;
  double? chargePerKm;

  /// --- CUSTOM TIME PICKER FEATURE ---
  List<CustomDate> weeklyDates = [];
  List<CustomTime> todayTimeRanges = [];
  List<CustomTime> generalTimeRange = [];
  // DateTime currentTime = DateTime.now();
  DateTime choosenDate = DateTime.now();
  String? choseTimeRange;
  DateTime? chosenDate;
  String? chosenTime;
  int? foodID;

  late SpecificFoodResponse foodDetailResponse =
      SpecificFoodResponse(false, '');
  late Foods specificFoodDetails;

  bool isButtonPressed = false;

  // GlobalLocationViewModel _locationViewModel = GlobalLocationViewModel();

  RestaurantDetailViewModel(this.restaurantId, this.foodID) {
    // getSpecificFoodDetails(foodID);
//
    getRestaurantCat();
    getCustomerCharges();

    // checkClosingTime();
  }

  void navigateToFoodDetail() {
    if (foodID != null) {
      log.wtf("FoodID in constructor $foodID");
      _navigationService.navigateToProductDescriptionView(
          foodId: foodID ?? 0, restaurantId: restaurantId);
    }
  }

  // Future<void> getSpecificFoodDetails(int? foodId) async {
  //   log.wtf("FoodId: $foodId");
  //   foodDetailResponse = await _dbService.specificFoodDetails(foodId ?? 0);

  //   if (foodDetailResponse.success) {
  //     specificFoodDetails = foodDetailResponse.body?.food ?? Foods();
  //     log.wtf("SpecificDetailsName ${specificFoodDetails.name}");
  //   } else {}
  //   notifyListeners();
  // }

  checkClosingTime(RestaurantCategoriesResponse restCarRes) {
    if (restCarRes.restaurantCat!.first.status != 1) {
      _navigationService.back();
      // showSnackBar(context, message: "");
    }
  }

  loginView() {
    _navigationService.navigateToLoginView();
  }

  back() {
    _navigationService.back();
  }

  navigateToRestaurantInfo(Restaurant restaurant) {
    _navigationService.navigateToRestaurantInfoView(
      restaurant: restaurant,
      customerCharge: customerCharges,
      customerRadius: customerRadius,
      chargePerKm: chargePerKm,
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.restaurantMenu,
      title: "Hello",
      description: "This is description",
      data: restaurantCat,
    );
  }

  void showDraggableSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.scheduleSheet,
      title: "Choose Timings",
      description: "This is description",
      data: restaurantCat,
    );
  }

  generateWeeklyDates() {
    for (int i = 0; i < 7; i++) {
      weeklyDates.add(
        CustomDate(
          date: DateTime.now().add(
            Duration(days: i),
          ),
          isSelected: chosenDate == null
              ? i == 0
                  ? true
                  : false
              : chosenDate!.weekday ==
                  DateTime.now().add(Duration(days: i)).weekday,
        ),
      );
    }
  }

  ///
  navigateToCartView() {
    _navigationService.navigateToCartView();
    // if (authService.checkLogin()) {

    // } else {
    //   loginView();
    // }
  }

  // getSelectedAddressId() {
  //   if (_locationViewModel.getSelectedAddress != null) {
  //     return _locationViewModel.getSelectedAddress?.id;
  //   }
  // }

  getCustomerCharges() async {
    SingleRestaurantResponse response =
        await _dbService.fetchsingleRestaurant(restaurantId, 375);
    if (response.success) {
      customerCharges = response.restaurant?.charge;
      customerRadius = response.restaurant?.radius;
      chargePerKm = response.restaurant?.chargePerKm;
      log.d(
          "@getCustomerCharges: Charge:${customerCharges},Radius: ${customerRadius}, chargeperKm:${chargePerKm}");
    }
  }

  ///get cat
  Future<void> getRestaurantCat() async {
    setBusy(true);
    log.d(
        "@getRestaurantCategory: AccessToken:::${localStorageService.accessToken}");

    RestaurantCategoriesResponse restCatRes =
        await _dbService.fetchRestaurantCat(restaurantId);

    if (restCatRes.success) {
      restaurant = restCatRes.restaurant;
      restaurantCat = [];

      ///
      restCatRes.restaurantCat?.forEach((element) {
        if (element.id != null) {
          restaurantCat.add(element);
        }
      });
    } else {}
    setBusy(false);
  }
}

class CustomDate {
  CustomDate({
    required this.date,
    required this.isSelected,
  });

  DateTime date;
  bool isSelected;
}

class CustomTime {
  CustomTime({
    required this.timeRange,
    required this.isSelected,
  });

  String timeRange;
  bool isSelected;
}
