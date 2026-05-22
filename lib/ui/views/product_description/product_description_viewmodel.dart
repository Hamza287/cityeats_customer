// ignore_for_file: unnecessary_null_comparison

import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/models/add_to_cart.dart';
import 'package:city_customer_app/models/guest_user.dart';
import 'package:city_customer_app/models/guest_user_body.dart';
import 'package:city_customer_app/models/location_body.dart';
import 'package:city_customer_app/models/product_cart_model.dart';
import 'package:city_customer_app/responses/add_to_cart_response.dart';
// import 'package:city_customer_app/responses/cart_response.dart' as cartRes;
import 'package:city_customer_app/responses/restaurant_response.dart';
// import 'package:city_customer_app/responses/restaurant_response.dart';
// import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';
import 'package:city_customer_app/responses/single_restaurant_response.dart';
import 'package:city_customer_app/responses/specific_food_response.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/services/local_storage_service.dart';
import 'package:city_customer_app/ui/dialogs/confirmation_dialogue.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:city_customer_app/ui/views/cart/cart_viewmodel.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:provider/provider.dart';
import 'package:city_customer_app/ui/views/cart/cart_viewmodel.dart';

class ProductDescriptionViewModel extends FormViewModel {
  //services//
  final _navigationService = locator<NavigationService>();
  final _dbService = locator<DatabaseService>();
  final localStorageService = locator<LocalStorageService>();
  final _authService = locator<AuthService>();
  final log = getLogger("ProductDescriptionViewModel");

//models//
  ProductCartModel productCartModel = ProductCartModel();
  List<SideItem> sideItems = [];
  List<SideItem> selectedSideItems = [];
  List<SubModifiers> selectedSubModifiers = [];
  GuestUserBody body = GuestUserBody();
  AddToCartBody addToCartModel = AddToCartBody();
  LocationBody? locationBody = LocationBody();
  // Variants? selectedVariants;
  SubModifiers? chozensubModifier;
  Foods food = Foods();
  List<Modifiers> _modifiers = [];
  late Restaurant restaurantObj;

  //fields//
  int itemQuantity = 1;
  int selectedDrink = -1;
  List<int> sideList = [];
  late double toTalPrice;
  late double originalPrice;
  late int restaurantId;
  late int foodId;
  bool isButtonPressed = false;
  bool isCartHasItem = false;
  bool isTapped = false;
  bool isDeliveryDetailsAdded = false;
  bool isdataLoaded = false;

  //TextEditingControllers//
  TextEditingController locationController = TextEditingController();
  TextEditingController phoneControllers = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //constructor//
  ProductDescriptionViewModel(
    this.restaurantId,
    this.foodId,
  ) {
    originalPrice = double.parse(food.price ?? '0');
    init();
    getSingleResturant();
    log.wtf("Variants List: ");

    defaultSelectedModifiers();
    localStorageService.init();
    if (isDeliveryDetailsAdded) {
      addToCart(context);
    }
  }
  Future<void> init() async {
    setBusy(true);
    localStorageService.init();
    await getSpecificFoodDetails(foodId);

    setBusy(false);
    notifyListeners();
  }

  Future<void> getSpecificFoodDetails(int foodId) async {
    log.wtf("FoodId: $foodId");
    log.wtf("AccessToken:::: ${localStorageService.accessToken}");
    setBusy(true);

    SpecificFoodResponse foodDetailResponse =
        await _dbService.specificFoodDetails(foodId);
    log.wtf("API Called:::: $foodId");

    if (foodDetailResponse.success) {
      food = foodDetailResponse.body?.food ?? Foods();
      originalPrice = double.parse(food.price ?? '0');
      toTalPrice = originalPrice;
      sideItems = food.sideItems ?? [];
      _modifiers = food.modifiers ?? [];
      log.wtf("API Sucessfull::::: ${food.name},${originalPrice}");
      notifyListeners();
      setBusy(false);

      // log.wtf("SpecificDetailsName ${specificFoodDetails.name}");
    } else {
      log.wtf("API failed:::: $foodId");
    }
    notifyListeners();
  }

  getSingleResturant() async {
    setBusy(true);
    final SingleRestaurantResponse response =
        await _dbService.fetchsingleRestaurant(restaurantId, 0);

    if (response.success) {
      setBusy(false);
      restaurantObj = response.restaurant!; // assign to class field
    }

    notifyListeners();
  }

  defaultSelectedModifiers() {
    for (int i = 0; i < modifiers.length; i++) {
      if (modifiers[i].optionStatus == "mandatory") {
        selectedSubModifiers.add(modifiers[i].subModifiers![0]);
      }
    }
    log.wtf("defaultSelectedModifiers: ${selectedSubModifiers.length}");
    findTotal();
    rebuildUi();
  }

  List<Modifiers> get modifiers => _modifiers;

  navigateToCartView() {
    _navigationService.navigateToCartView();
  }

  discountApplicable(double discount) {
    if (discount != 0) {
      return true;
    }
    return false;
  }

  getDiscountedPrice(double price, double percentDiscount) {
    double discountedPrice = price - (price * (percentDiscount / 100));
    return discountedPrice;
  }

  navigateToAddressScreen() async {
    final LocationBody? locationBody =
        await _navigationService.navigateToSelectMapLocationView();
    log.d("LocationBodyparams: ${locationBody!.toJson()}");
    if (locationBody != null) {
      locationController.text = locationBody.fullAddress ?? "";
      body.address = locationBody.fullAddress ?? '';
      body.addressType = locationBody.label ?? '';
      body.latitude = locationBody.lat;
      body.longitude = locationBody.lng;
      body.zipCode = locationBody.postalCode;
      body.street = locationBody.streetAddress;
      log.w('body========>: ${body.toJson()}');
    } else {
      log.w('No address is retruned.');
    }

    return locationBody;
  }

  onPressed() {
    isButtonPressed = true;
    rebuildUi();
  }

  onTapped() {
    isTapped = true;
    rebuildUi();
  }

  getUserInfo(context) async {
    log.wtf("@getUserInfo");
    setBusy(true);
    GuestUserProfileResponse? response =
        await _dbService.getGuestUserInfo(body);

    if (response.success) {
      localStorageService.accessToken = response.body!.token!;

      isDeliveryDetailsAdded = true;
      isButtonPressed = false;
      addToCart(context);
      _authService.userProfile = response.body?.user;
      _authService.updateFcmToken();
      Provider.of<GlobalLocationViewModel>(context, listen: false)
          .selectedAddress = response.body?.user?.address?.first;
    } else {
      showSnackBar(context, message: response.error ?? "Request Failed");
    }
    setBusy(false);
    rebuildUi();
  }

  addSideItem(SideItem item) {
    if (selectedSideItems.contains(item)) {
      selectedSideItems.removeWhere((element) => element.id == item.id);
    } else {
      // if (selectedSideItems.length > 2) {
      //   return;
      // } else {
      selectedSideItems.add(item);
      // }
    }
    rebuildUi();
    findTotal();
  }

  // addItemVariants(Variants variants) {
  //   log.wtf("OriginalPrice: $originalPrice");
  //   originalPrice = variants.price!.toDouble();
  //   rebuildUi();
  //   findTotal();
  //   log.wtf("ShowVariants: $selectedVariants");
  //   log.d("TotalPrice: $toTalPrice");
  // }

  incrementQuantity() {
    itemQuantity++;
    rebuildUi();
    findTotal();
  }

  decrementQuantity() {
    if (itemQuantity > 1) itemQuantity--;
    rebuildUi();
    findTotal();
  }

  goBack() {
    _navigationService.back();
  }

  back(context) {
    Provider.of<CartViewModel>(context, listen: false).getMyCart();
    _navigationService.back();
  }

  findTotal() {
    log.w("SelectedSubModLength:${selectedSubModifiers.length}");
    // toTalPrice = originalPrice * itemQuantity;

    // if (selectedSubModifiers.isNotEmpty) {
    log.w('modifierAdded');
    double modifersTotal = getSelectedModifiersTotalPrice();
    log.w('ModifiersTotal: $modifersTotal');

    // if (discountApplicable(food.percentDiscount ?? 0)) {
    //   log.w("beforeDriscount: ${toTalPrice}");
    //   toTalPrice = getDiscountedPrice(
    //       (originalPrice + modifersTotal) * itemQuantity,
    //       food.percentDiscount ?? 0);
    //   log.w("totalPrice after discount : ${toTalPrice}");
    // } else {
    //   log.w("totalPrice no discount ");
    // }
    // }
    // else {
    //   log.d("noModifiersadded");
    //   if (discountApplicable(food.percentDiscount ?? 0)) {
    //     log.w("totalPrice before discount : ${toTalPrice} ");
    //     toTalPrice = getDiscountedPrice(
    //         (originalPrice * itemQuantity), food.percentDiscount ?? 0);
    //     log.w("totalPrice after discount :${toTalPrice} ");
    //   } else {
    //     toTalPrice = (originalPrice * itemQuantity);
    //   }
    // }
    toTalPrice = (originalPrice + modifersTotal) * itemQuantity;

    rebuildUi();
  }

  getSelectedModifiersTotalPrice() {
    double modifierPrice = 0.0;

    for (int i = 0; i < selectedSubModifiers.length; i++) {
      modifierPrice += selectedSubModifiers[i].price!;
    }

    return modifierPrice;
  }

  getSideItemsPrice() {
    double sidePrice = 0.0;
    for (int i = 0; i < selectedSideItems.length; i++) {
      sidePrice += selectedSideItems[i].price!;
      // side[sideList[i]]['price'];
    }
    return sidePrice;
  }

  bool addTocartValidation(context) {
    log.d("Validation: ${modifierValidation(context)}");
    return modifierValidation(context);
  }

  Future<void> addToCart(context) async {
    // Prevent duplicate calls
    if (isBusy) {
      return;
    }

    addToCartModel.subModifiers = [];

    for (var element in selectedSubModifiers) {
      addToCartModel.subModifiers?.add(element.id!);
    }

    addToCartModel.subModifiers?.sort();

    addToCartModel.sideItems = [];
    for (var element in selectedSideItems) {
      addToCartModel.sideItems?.add(CartSideItem(id: element.id));
    }
    // addToCartModel.variants = [];
    // if (food.variants!.isNotEmpty) {
    //   if (selectedVariants?.id == null) {
    //     addToCartModel.variants?.add(CartVariants(
    //         variantId: food.variants![0].id, quantity: itemQuantity));
    //   } else {
    //     addToCartModel.variants?.add(CartVariants(
    //         variantId: selectedVariants?.id, quantity: itemQuantity));
    //   }
    // } else {
    //   addToCartModel.variants = null;
    // }

    initBody();
    setBusy(true);
    // try {
    log.wtf("ADDTOCART:  ${addToCartModel.toJson()}");
    AddToCartResponse res = await _dbService.addToCart(addToCartModel);
    log.wtf(res.body);
    if (res.success) {
      // Refresh global cart state to update price in UI
      Provider.of<CartViewModel>(context, listen: false)
          .getMyCart(isRefresh: true);
      back(context);
    } else {
      // Check for specific "clear the cart" error and empty local cart
      if (res.error != null &&
          res.error!.toLowerCase().contains("clear the cart") &&
          !isCartHasItem) {
        log.w(
            "⚠️ Backend cart mismatch detected. Auto-clearing backend cart...");

        // Auto-clear backend cart
        try {
          final clearRes = await _dbService.clearCart();
          if (clearRes['success'] == true) {
            log.i("✅ Backend cart cleared. Retrying addToCart...");

            // Retry adding to cart
            AddToCartResponse retryRes =
                await _dbService.addToCart(addToCartModel);
            if (retryRes.success) {
              back(context);
              return;
            } else {
              showSnackBar(context,
                  message: retryRes.error ?? "Failed to add item to cart");
            }
          } else {
            showSnackBar(context,
                message: res.error ?? "Failed to add item to cart");
          }
        } catch (e) {
          log.e("Failed to auto-clear cart: $e");
          showSnackBar(context,
              message: res.error ?? "Failed to add item to cart");
        }
      } else {
        showSnackBar(context,
            message: res.error ?? "Failed to add item to cart");
      }
    }

    setBusy(false);
  }

  initBody() {
    addToCartModel.restaurantId = restaurantId;
    addToCartModel.products = [];
    addToCartModel.products?.add(
      Products(id: foodId, quantity: itemQuantity),
    );
  }

  navigateToLogin() {
    _navigationService.navigateToLoginView();
  }

  navigateToRestaurantDetail(BuildContext context) {
    setBusy(true);
    // log.wtf("restaurantObj: ${restaurantObj}");
    log.wtf("Navigating to restaurant detail view");
    log.wtf("restaurantId: $restaurantId");
    Navigator.pop(context);
    _navigationService.navigateToRestaurantDetailView(
      restaurantId: restaurantId,
      restaurant: restaurantObj,
    );
  }

  modifierValidation(BuildContext context) {
    bool flag = true;
    List<int>? selectedSubModID = [];
    for (int i = 0; i < selectedSubModifiers.length; i++) {
      selectedSubModID.add(selectedSubModifiers[i].id!);
    }
    log.wtf("SelectedSunModID:  $selectedSubModID");

    for (int i = 0; i < modifiers.length; i++) {
      // Safety check for modifiers list bounds
      if (i >= modifiers.length) {
        break;
      }

      if (modifiers[i].optionStatus == "mandatory") {
        // Check if subModifiers is not null and not empty
        final subModifiers = modifiers[i].subModifiers;
        if (subModifiers == null || subModifiers.isEmpty) {
          flag = false;
          showSnackBar(context, message: "${modifiers[i].name} is required!");
          break;
        }

        log.wtf("submodlenght:${subModifiers.length}");
        bool foundSelected = false;

        // Use a safer iteration method
        for (int j = 0; j < subModifiers.length; j++) {
          // Additional safety check before accessing
          if (j >= subModifiers.length) {
            break;
          }

          final subModifier = subModifiers[j];
          if (subModifier.id == null) {
            continue;
          }

          log.wtf("SubModifierID:  ${subModifier.id}");
          if (selectedSubModID.contains(subModifier.id)) {
            log.wtf("SubModifierID Exists:  ${subModifier.id}");
            foundSelected = true;
            break;
          }
        }

        if (!foundSelected) {
          flag = false;
          showSnackBar(context, message: "${modifiers[i].name} is required!");
          break;
        }
      }
    }
    return flag;
  }

  void showAgeRestrictionDialog(BuildContext context) {
    // Capture the outer context
    final parentContext = context;
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: MediaQuery.of(parentContext).size.width * 0.8,
            child: ConfirmationDialog(
              title: "Age Restricted Item",
              subTitle:
                  "You will be required to show your ID document for age verification. Do you want to add it to the cart?",
              onPressed: () {
                //
                if (locator<AuthService>().isLogin) {
                  addToCart(parentContext);
                } else {
                  onPressed();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
