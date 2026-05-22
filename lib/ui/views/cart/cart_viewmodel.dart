// ignore_for_file: deprecated_member_use

import 'package:city_customer_app/app/app.bottomsheets.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/services/date_time_service.dart';
import 'package:city_customer_app/ui/views/restaurant_detail/restaurant_detail_viewmodel.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../responses/cart_response.dart';

class CartViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  final _navService = locator<NavigationService>();

  final _bottomSheetService = locator<BottomSheetService>();
  final dateTimeService = locator<DateTimeService>();

  List<CartProducts> cartProducts = [];
  bool isExpanded = false;
  bool isRefresh = false;
  int incrementQuantity = 0;
  // List<bool> isExpandedList = [];
  Cart? cart;
  bool dataLoaded = false;

  List<CustomDate> weeklyDates = [];
  DateTime? chosenDate;
  DateTime choosenDate = DateTime.now();
  String? chosenTime;
  List<Slots> todayTimeRanges = [];
  List<Slots> generalTimeRange = [];
  List<RestaurantAvailableSlots> restaurantAvailableSlots = [];
  Slots? chosenSlot;

  CartViewModel() {
    getMyCart();
  }

  TextEditingController noteController = TextEditingController();

  final log = getLogger("CartViewModel");

////////////////
  /// API'S SECTION
  /////////////////
  ///get my cart
  Future<void> getMyCart({isRefresh = false}) async {
    setBusy(true);
    isRefresh = !isRefresh;
    try {
      CartResponse res = await _dbService.fetchMyCart();
      log.wtf(res);
      if (res.success) {
        dataLoaded = true;
        updateCart(res.body?.cart);
        updateCarProductList(res.body?.cart?.cartProducts ?? []);
        restaurantAvailableSlots = res.body?.restaurantAvailableSlots ?? [];
        log.wtf("restaurantAvailableSlots: $restaurantAvailableSlots");
        log.wtf(cartProducts.length);
      } else {}
    } catch (e, stackTrace) {
      log.e("Error fetching cart: $e\n$stackTrace");
    }
    setBusy(false);
  }

  getGeneralTimeRange() {
    generalTimeRange = restaurantAvailableSlots
            .firstWhere(
                (element) =>
                    element.date?.day == (chosenDate ?? DateTime.now()).day,
                orElse: () => RestaurantAvailableSlots(slots: []))
            .slots ??
        [];

    notifyListeners();
  }

  void updateCart(Cart? cart) {
    this.cart = cart;
    rebuildUi();
  }

  toggleShowMore(int index) {
    log.w('@toggleShowMore');

    for (int i = 0; i < cartProducts.length; i++) {
      if (i == index) {
        cartProducts[index].showMore = !cartProducts[index].showMore;
      } else {
        cartProducts[i].showMore = false;
      }
    }

    rebuildUi();
  }

  void updateCarProductList(List<CartProducts> pList) {
    cartProducts = pList;
    rebuildUi();
  }

  getProductSubmodIds(CartProducts product) {
    List<int> subModIds = [];
    for (int i = 0; i < product.modifiers!.length; i++) {
      for (int j = 0; j < product.modifiers![i].subModifiers!.length; j++) {
        subModIds.add(product.modifiers![i].subModifiers![j].submodifierId!);
      }
    }
    log.wtf("subModIDS: $subModIds}");
    return subModIds;
  }

  getProductSubmodTotalPrices(CartProducts product) {
    double subModTotalPrice = 0.0;
    for (int i = 0; i < product.modifiers!.length; i++) {
      for (int j = 0; j < product.modifiers![i].subModifiers!.length; j++) {
        subModTotalPrice += product.modifiers![i].subModifiers![j].price!;
      }
    }
    log.wtf("subModTotalPrice: $subModTotalPrice}");
    return subModTotalPrice;
  }

  getProductSubmod(CartProducts product) {
    List<SubModifiers> cartSubModifiers = [];
    for (int i = 0; i < product.modifiers!.length; i++) {
      for (int j = 0; j < product.modifiers![i].subModifiers!.length; j++) {
        cartSubModifiers.add(product.modifiers![i].subModifiers![j]);
      }
    }
    log.wtf("cartSubMmodifers:$cartSubModifiers");
    return cartSubModifiers;
  }

  ///update Product count
  Future<void> updateProductCount(
    int cartProductId,
    int count,
    bool isVariantAdded,
    int variantId,
    List<int> subModIDs,
  ) async {
    log.wtf("@getMyCart");
    try {
      CartResponse res = await _dbService.incrementProductCount(
          cartProductId, count, variantId, isVariantAdded, subModIDs);
      log.wtf(res);
      if (res.success) {
        log.wtf(cartProducts.length);
      } else {}
    } catch (e) {
      log.e(e);
    }
    rebuildUi();
  }

  ///clear cart
  Future<void> clearCart() async {
    setBusy(true);
    cartProducts.clear();
    cart = null;
    try {
      final res = await _dbService.clearCart();
      log.wtf(res);
      if (res['success'] ?? false) {
      } else {}
    } catch (e) {
      log.e(e);
    }

    setBusy(false);
    getMyCart();
  }

  ///remove item from cart
  Future<void> removeItemFromCart(int id) async {
    setBusy(true);
    try {
      CartResponse res = await _dbService.removeItemFromCart(id);
      log.wtf(res);
      if (res.success) {
        updateCart(res.body!.cart!);
        updateCarProductList(res.body?.cart?.cartProducts ?? []);
      } else {}
    } catch (e) {
      log.e(e);
    }
    setBusy(false);
  }

  ///////////////////////////////
  /// NAVIGATION SECTION
  //////////////////////////////
  ///navigate to check out
  void navigateToCheckout() {
    _navService.navigateToCheckoutView(
        cartProducts: cartProducts,
        restaurantId: cart!.restaurantId!,
        note: noteController.text,
        cart: cart!,
        scheduledDate: chosenSlot ?? Slots(),
        restaurantAvailableSlots: restaurantAvailableSlots);
  }

  String getDayOfWeek(DateTime date) {
    DateTime todaysDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime apiDate = DateTime(date.year, date.month, date.day);

    if (todaysDate.isAtSameMomentAs(apiDate)) {
      return 'Today';
    }

    if (todaysDate.add(Duration(days: 1)).isAtSameMomentAs(apiDate)) {
      return 'Tomorrow';
    }

    String dayOfWeek = DateFormat('EEEE').format(date);
    if (dayOfWeek.length > 6) {
      return dayOfWeek.substring(0, 3);
    }
    return dayOfWeek;
  }

  //navigate to home
  void navigateToHome() {
    _navService.clearStackAndShow(Routes.rootView);
  }

  ///////////////////////////
  /// LOCAL CALCULATION
  ///////////////////////////
  ///increment Item Locally
  void incrementItem(CartProducts product) {
    // incrementQuantity = incrementQuantity + 1;
    product.productCount = (product.productCount ?? 1) + 1;
    product.discountAdded =
        product.discountOnSingleproduct * (product.productCount ?? 1);

    product.totalPrice = (getProductSubmodTotalPrices(product) +
            product.productPrice -
            product.discount) *
        (product.productCount ?? 1);

    // product.totalPrice =
    //     (product.totalPrice?? 1) * (product.productCount ?? 1);

    calculateTotal();

    rebuildUi();
    bool isVariant = false;
    int variantId = 0;
    if (product.variants!.isNotEmpty && product.variants != null) {
      isVariant = true;
      variantId = product.variants!.first.variantId ?? 0;
    }

    updateProductCount(
      product.id!,
      product.productCount!,
      isVariant,
      variantId,
      getProductSubmodIds(product),
    );
  }

  ///decrement Item Locally
  void decrementItem(CartProducts product) {
    product.productCount = product.productCount! - 1;
    product.discountAdded =
        product.discountOnSingleproduct * (product.productCount ?? 1);

    product.totalPrice = (getProductSubmodTotalPrices(product) +
            product.productPrice -
            product.discount) *
        (product.productCount ?? 1);

    calculateTotal();
    rebuildUi();
    bool isVariant = false;
    int variantId = 0;
    if (product.variants!.isNotEmpty && product.variants != null) {
      isVariant = true;
      variantId = product.variants!.first.variantId ?? 0;
    }
    updateProductCount(
      product.id!,
      product.productCount!,
      isVariant,
      variantId,
      getProductSubmodIds(product),
    );
  }

  ///find total locally
  calculateTotal() {
    double total = 0;
    for (var element in cartProducts) {
      double sideItemPrice = 0;
      for (var element in element.sideItems) {
        sideItemPrice +=
            double.parse((element.sideItemPrice ?? '0').toString());
      }

      // print("sideItemPrice $sideItemPrice");
      total += (element.totalPrice ?? 0) + sideItemPrice;
      // print("total $total");
    }
    // cart?.total = total + calculateOtherExpenses();
    cart?.subTotal = total;
    rebuildUi();
  }

  ///calculate vat, delivery changes, bag fee, service charges
  calculateOtherExpenses() {
    return (cart?.vat ?? 0) +
        (cart?.bagFee ?? 0) +
        // (cart?.deliveryFee ?? 0) +
        (cart?.serviceCharges ?? 0);
  }

  ///dismissed
  removeItem(CartProducts product) {
    cartProducts.removeWhere((element) => element.id == product.id);
    removeItemFromCart(product.productId!);
    rebuildUi();
  }

  ///
  //
  clearCarOnOrderCreation() {
    cartProducts.clear();
    cart = null;
    rebuildUi();
  }

  // schedule order
}
