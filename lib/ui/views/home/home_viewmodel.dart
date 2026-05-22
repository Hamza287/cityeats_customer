// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'dart:convert';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/models/filter.dart';
import 'package:city_customer_app/responses/banners_response.dart';
import 'package:city_customer_app/responses/categories_response.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/responses/specific_food_response.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/services/local_storage_service.dart';
import 'package:city_customer_app/services/location_service.dart';
import 'package:city_customer_app/ui/views/cart/cart_viewmodel.dart';
import 'package:city_customer_app/ui/views/root/root_view.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../../responses/restaurent_cat_reesponse.dart';

class HomeViewModel extends BaseViewModel {
  ///services
  final _navigationService = locator<NavigationService>();
  final locationService = locator<LocationService>();
  final _dbService = locator<DatabaseService>();
  final authService = locator<AuthService>();
  final localStorageService = locator<LocalStorageService>();

  ///log
  final log = getLogger("HomeViewModel");

//////////////////////////////////////////////////////////////////////////
  ///LOCAL VARIABLES
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

  ///integers
  int current = 0;
  int currentPage = 0;
  FocusNode focusNode = FocusNode(canRequestFocus: false);

  final myContext = StackedService.navigatorKey?.currentContext;

  ///controllers
  final PageController pageController = PageController();
  CarouselSliderController controller = CarouselSliderController();
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

  ///lists
  List<BannerModel> bannerList = [];
  List<Category> categoryList = [];
  List<Restaurant> allRestaurantList = [];
  List<Restaurant> featureRestaurantList = [];
  List<Restaurant> favRestaurantList = [];
  List openRestList = [];
  late SpecificFoodResponse foodDetailResponse =
      SpecificFoodResponse(false, '');
  late Foods specificFoodDetails = Foods();

  int foodId = 0;

//////////////////////////////////////////////////////////////////////////
  ///Constructor
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
  ///Get banners,categories,all restaurants, feature restaurants
  HomeViewModel() {
    init(getSelectedAddressId());
  }
  bool isRefresh = false;
  int? addressId;

  init(
    addressId, {
    isRefresh = false,
  }) async {
    this.isRefresh = isRefresh;
    final selectedAddressId =
        addressId ?? getSelectedAddressId() ?? localStorageService.addressId;

    if (!isRefresh) setBusy(true);

    final addressRefresh =
        authService.isLogin ? refreshAddresses() : Future<void>.value();

    // Start secondary requests immediately so they run in parallel with the first batch!
    final secondaryRequests = <Future<void>>[
      getAllRestaurants(addressId: selectedAddressId, manageBusy: false),
      addressRefresh,
    ];

    if (authService.isLogin) {
      secondaryRequests.add(
          getFavRestaurants(addressId: selectedAddressId, manageBusy: false));
    } else {
      favRestaurantList = [];
    }

    final secondaryFuture = Future.wait(secondaryRequests);

    await Future.wait([
      getBanners(manageBusy: false),
      getCategories(manageBusy: false),
      getFeatureRestaurant(addressId: selectedAddressId, manageBusy: false),
    ]);

    this.isRefresh = false;
    setBusy(false);

    await secondaryFuture;
    rebuildUi();
  }

  /// Refresh addresses from API
  Future<void> refreshAddresses() async {
    if (myContext != null) {
      final locationProvider =
          Provider.of<GlobalLocationViewModel>(myContext!, listen: false);
      await locationProvider.getAddresses();
    }
  }

  //

//////////////////////////////////////////////////////////////////////////
  ///FUNCTIONS
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

  ///
  unFocus() {
    focusNode.canRequestFocus = false;
    focusNode.unfocus();
    rebuildUi();
  }

  togglePage(int page) {
    currentPage = page;
    rebuildUi();
  }

  onPageChange(index) {
    current = index;
    rebuildUi();
  }

  setCurrentPage(int page) {
    currentPage = page;
  }

//////////////////////////////////////////////////////////////////////////
  ///FETCH DATA FROM DB
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

  ///get Banners
  Future<void> getBanners({bool manageBusy = true}) async {
    if (manageBusy && !isRefresh) setBusy(true);
    BannersResponse bannersResponse = await _dbService.fetchBanners();
    if (bannersResponse.success) {
      bannerList = bannersResponse.bannerList;
    }
    if (manageBusy) setBusy(false);
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

  launchURL() async {
    StoreRedirect.redirect(
        androidAppId: "uk.co.cityeats.customers", iOSAppId: "6479355170");
  }

  ///get Categories
  Future<void> getCategories({bool manageBusy = true}) async {
    if (manageBusy && !isRefresh) setBusy(true);
    CategoriesResponse categoriesResponse = await _dbService.fetchCategories();
    if (categoriesResponse.success) {
      categoryList = categoriesResponse.categoryList;
    } else {
      ///
    }
    if (manageBusy) setBusy(false);
  }

  getSelectedAddressId() {
    if (myContext != null) {
      final locationProvider =
          Provider.of<GlobalLocationViewModel>(myContext!, listen: false);
      log.wtf("SelectedAddressId: ${locationProvider.getSelectedAddress?.id}");
      if (locationProvider.getSelectedAddress != null) {
        return locationProvider.getSelectedAddress?.id;
      }
    }
    return null;
  }

  ///get All Restaurants
  Future<void> getAllRestaurants(
      {int? addressId, bool manageBusy = true}) async {
    if (manageBusy && !isRefresh) setBusy(true);

    bool hasCache = false;
    try {
      final cachedData = localStorageService.allRestaurantsCache;
      if (cachedData != null) {
        Map<String, dynamic> jsonMap;
        if (cachedData is String) {
          jsonMap = jsonDecode(cachedData);
        } else {
          jsonMap = cachedData as Map<String, dynamic>;
        }
        RestaurantsResponse cachedResponse = RestaurantsResponse.fromJson(jsonMap);
        if (cachedResponse.success) {
          allRestaurantList = cachedResponse.restaurantList ?? [];
          hasCache = true;
          if (manageBusy) rebuildUi(); // Instant display
        }
      }
    } catch (e) {
      log.e("Cache error: $e");
    }

    Future<void> fetchFromApi() async {
      RestaurantsResponse response = await _dbService.fetchAllRestaurants(
          addressId ?? getSelectedAddressId() ?? localStorageService.addressId);
      if (response.success) {
        allRestaurantList = response.restaurantList ?? [];
        try {
          localStorageService.allRestaurantsCache = response.toJson();
        } catch(e) {}
      }
      if (manageBusy || hasCache) rebuildUi();
    }

    if (hasCache) {
      fetchFromApi(); // runs in background
    } else {
      await fetchFromApi(); // waits if no cache
    }

    if (manageBusy) setBusy(false);
  }

  ///get feature res
  Future<void> getFeatureRestaurant(
      {int? addressId, bool manageBusy = true}) async {
    if (manageBusy && !isRefresh) setBusy(true);
    RestaurantsResponse featureRestaurant =
        await _dbService.fetchFeatureRestaurants(addressId ??
            getSelectedAddressId() ??
            localStorageService.addressId);

    if (featureRestaurant.success) {
      featureRestaurantList = featureRestaurant.restaurantList ?? [];
    } else {}
    if (manageBusy) setBusy(false);
  }

  Future<void> getSpecificFoodDetails(int foodId) async {
    log.wtf("FoodId: $foodId");
    foodDetailResponse = await _dbService.specificFoodDetails(foodId);

    if (foodDetailResponse.success) {
      specificFoodDetails = foodDetailResponse.body?.food ?? Foods();
      log.wtf("SpecificDetailsName ${specificFoodDetails.name}");
    } else {}
    notifyListeners();
  }

  ///get fav res
  Future<void> getFavRestaurants(
      {int? addressId, bool manageBusy = true}) async {
    if (!authService.isLogin) {
      favRestaurantList = [];
      return;
    }

    if (manageBusy && !isRefresh) setBusy(true);
    RestaurantsResponse favRestaurantRes =
        await _dbService.fetchFavoriteRestaurants(addressId ??
            getSelectedAddressId() ??
            localStorageService.addressId);
    if (favRestaurantRes.success) {
      ///
      favRestaurantList = favRestaurantRes.restaurantList ?? [];
    } else {
      ///
    }
    if (manageBusy) setBusy(false);
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

//////////////////////////////////////////////////////////////////////////
  ///NAVIGATION VIEWS
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
  ///cart view
  void navigateToCartView() {
    _navigationService.navigateToCartView();
  }

  clearGuestUserCart() {
    log.d("@ClearGuestUserCart");
    if (locator<AuthService>().userProfile == null) {
      final cartProvider =
          Provider.of<CartViewModel>(myContext!, listen: false);
      cartProvider.clearCart();
    }
  }

  // void clearCartData( context) {
  //   if (locator<AuthService>().userProfile == null) {
  //     final cartProvider = Provider.of<CartViewModel>(context, listen: false);
  //     cartProvider.clearCarOnOrderCreation();
  //   }
  // }

  void navigateToUpdateView() {
    _navigationService.navigateToUpdateScreen();
  }

  ///account view
  void navigateToAccountView() {
    _navigationService.clearTillFirstAndShowView(const RootView(index: 3));
  }

  //addresses view
  navigateToSaveAddresses() async {
    // Check if user is logged in - if guest, navigate to login
    // if (!authService.checkLogin()) {
    //   _navigationService.navigateToLoginView();
    //   return null;
    // }
    final address = await _navigationService.navigateToSaveAddressesView();
    return address;
  }

  //restaurant detail view
  Future<void> navigateToDetail(Restaurant res, int? foodId) async {
    if (foodId == null || foodId == 0) {
      await _navigationService.navigateToRestaurantDetailView(
          restaurantId: res.id, restaurant: res);
    } else {
      await _navigationService.navigateToProductDescriptionView(
          // food: foodDetailResponse.body?.food ?? Foods(),
          restaurantId: res.id,
          foodId: foodId,
          isNavigatedFromBanner: true);
    }
    // init();
  }

  //filter view
  Future<void> navigateToFilterView() async {
    _navigationService.navigateToFilterView();
    // log.wtf(filterBody.maxPrice);
    // log.wtf(filterBody.minPrice);
    // if (filterBody.isPriceRange) {
    //   sortByPriceRange();
    // }
    // if (filterModel.sortBy.toLowerCase() == "rating") {
    //   sortByRating();
    //   log.wtf("rating");
    // }

    // if (filterModel.sortBy.toLowerCase() == "category") {
    //   sortByCategory();
    //   log.wtf("category");
    // }

    rebuildUi();
  }

  navigateToSearchView() {
    _navigationService.navigateToSearchView();
  }

////////////////////////////////////
//////////////////////////////
  sortByPriceRange() {
    // List<Restaurant> filteredProducts = allRestaurantList.
    // .where((product) => product >= minPrice && product.price <= maxPrice)
    // .toList();
  }

  sortByCategory() {
    categoryList.sort((a, b) => (a.name ?? "").compareTo((b.name ?? "")));
    rebuildUi();
  }

  sortByRating() {
    // Sort the productList by rating in descending order
    allRestaurantList
        .sort((a, b) => (b.rating ?? 0).compareTo((a.rating ?? 0)));
    featureRestaurantList
        .sort((a, b) => (b.rating ?? 0).compareTo((a.rating ?? 0)));
    favRestaurantList
        .sort((a, b) => (b.rating ?? 0).compareTo((a.rating ?? 0)));

    rebuildUi();
  }

  ////////////////////////////////////
  ///////////////////////////////////////
  //////////////////////////////
  //rest categories view
  void navigateToCatRestView(int index) {
    _navigationService.navigateToCategroryRestView(
        catId: categoryList[index].id, catName: categoryList[index].name ?? "");
  }

  //rest categories view for grocery
  void navigateToCatRestViewForGrocery() {
    _navigationService.navigateToCategroryRestView(
      catId: 0,
      catName: "Grocery",
      isGrocery: true,
    );
  }

  ///
  Restaurant? findRestaurantById(int restaurantId) {
    try {
      return allRestaurantList
          .firstWhere((element) => element.id == restaurantId);
    } catch (e) {
      return null; // Return null if the restaurant with the specified ID is not found
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

  loginView() {
    _navigationService.navigateToLoginView();
  }

//////////////////////////////////////////////////////////////////////////
  ///SAVE DATA LOCALLY
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
}
