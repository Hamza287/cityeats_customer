// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, deprecated_member_use, unrelated_type_equality_checks
import 'dart:async';
import 'package:city_customer_app/app/app.bottomsheets.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/models/coupon_model.dart';
import 'package:city_customer_app/models/order_model.dart';
import 'package:city_customer_app/responses/addresses_response.dart';
import 'package:city_customer_app/responses/order_response.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';
import 'package:city_customer_app/services/date_time_service.dart';
import 'package:city_customer_app/services/local_storage_service.dart';
import 'package:city_customer_app/services/payment_service.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:city_customer_app/ui/views/cart/cart_viewmodel.dart';
import 'package:city_customer_app/ui/views/checkout/checkout_view.dart';
import 'package:city_customer_app/ui/views/restaurant_detail/restaurant_detail_viewmodel.dart';
import 'package:city_customer_app/viewModels/create_order_view_model.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../responses/cart_response.dart';
import '../../../services/auth_service.dart';
import '../../../services/database_service.dart';

class CheckoutViewModel extends BaseViewModel {
  DeliveryMood dMood = DeliveryMood.delivery;
  final log = getLogger("");
  final _localStorage = locator<LocalStorageService>();

  final List<CartProducts> cartProducts;
  double totalPrice = 0;
  double subTotal = 0;
  double discount = 0;
  TextEditingController voucherController = TextEditingController();
  PaymentMethod paymentMethod = PaymentMethod.cash;
  List<CouponBody> couponList = [];
  String transactionId = '';
  String paymentIntentId = '';
  Map<String, dynamic>? transactionData;
  Map<String, dynamic>? paymentIntent;
  String? currentCouponType; // Store the current applied coupon type

  /// Get the title of the currently applied coupon
  String? get appliedCouponTitle {
    if (voucherController.text.isEmpty) return null;
    try {
      final appliedCoupon = couponList.firstWhere(
        (coupon) =>
            coupon.couponCode.toLowerCase() ==
            voucherController.text.trim().toLowerCase(),
      );
      return appliedCoupon.couponTitle;
    } catch (e) {
      return null;
    }
  }

  /// Get items subtotal (only product prices + side items, no fees)
  double get itemsSubtotal {
    double total = 0;
    for (var element in cartProducts) {
      total += (element.totalPrice ?? 0);
    }
    for (var element in cartProducts) {
      double sideItemsPrice = 0;
      for (var sideItem in element.sideItems) {
        sideItemsPrice += double.parse(sideItem.sideItemPrice.toString());
      }
      total += sideItemsPrice;
    }
    return total;
  }

  final _navService = locator<NavigationService>();
  final _dbService = locator<DatabaseService>();
  final _authService = locator<AuthService>();
  final localStorageService = locator<LocalStorageService>();
  String note;
  int restaurantId;
  Cart cart;
  BuildContext context;
  LocationAddress? selectedAddress;
  List<OrderModel>? body;
  bool dataLoaded = true;
  bool isDeliveryOffCoupon = false;
  bool _hasShownCouponDialog = false; // Track if dialog has been shown once
  Timer? _dialogAutoDismissTimer; // Track the auto-dismiss timer
  //  final Slots scheduledDate;
  // final bool isScheduled;
  // final int scheduledId;

  final _bottomSheetService = locator<BottomSheetService>();
  final dateTimeService = locator<DateTimeService>();
  List<CustomDate> weeklyDates = [];
  DateTime? chosenDate;
  DateTime choosenDate = DateTime.now();
  String? chosenTime;
  List<Slots> todayTimeRanges = [];
  List<Slots> generalTimeRange = [];
  List<RestaurantAvailableSlots> restaurantAvailableSlots = [];
  Slots? chosenSlot;

  CheckoutViewModel(this.context, this.cartProducts, this.note,
      this.restaurantId, this.cart, this.restaurantAvailableSlots) {
    // log.wtf("isScheduled:$isScheduled, scheduledId:$scheduledId");
    log.wtf("RESTURANTAVAILABLE_SLOTS: ${restaurantAvailableSlots.length}");

    localStorageService.init();
    discount = cart.discounts ?? 0;
    paymentMethod = cart.restaurant?.isRestaurantOwnDelivery != 1
        ? PaymentMethod.paypal
        : PaymentMethod.cash;

    final addressProvider =
        Provider.of<GlobalLocationViewModel>(context, listen: false);

    if (restaurantAvailableSlots != null &&
        restaurantAvailableSlots.isNotEmpty) {
      generateWeeklyDates(restaurantAvailableSlots);
      getGeneralTimeRange();
    } else {
      log.wtf("RESTURANTAVAILABLE_SLOTS: null or empty");
    }

    // todayTimeRanges = res.body!.restaurantAvailableSlots?. ?? [];

    // log.wtf("RESTURANTAVAILABLE_SLOTS: ${restaurantAvailableSlots.length}");
    log.wtf("TODAYTIMERANGES: ${todayTimeRanges.length}");
    log.wtf("chosenDate: ${chosenDate}");

    // Defer async operations to avoid setState during build
    Future.microtask(() {
      initLocation(addressProvider.getSelectedAddress);
      getAllCoupons(addressProvider.getSelectedAddress?.id ?? 0);
      calculateTotal();
    });
  }

  bool areAllSlotsEmpty(
      List<RestaurantAvailableSlots> restaurantAvailableSlots) {
    return restaurantAvailableSlots.every(
      (slot) => slot.slots == null || slot.slots!.isEmpty,
    );
  }

  initLocation(LocationAddress? address) {
    log.d("checkout: initLocation");

    updateLocation(address);
    // await updateDeliveryCharges(localStorageService.addressId);
  }

  getAllCoupons(int addressId) async {
    // Defer setBusy to avoid calling during build phase
    Future.microtask(() => setBusy(true));

    log.wtf("Selected Address ID: ${addressId}");
    CouponModel res = await _dbService.fetchAllCoupons(addressId);
    if (res.success) {
      //
      couponList = res.body;
      log.wtf(
          "getAllCoupons - couponList populated with ${couponList.length} coupons");
    } else {
      log.wtf("getAllCoupons - failed to fetch coupons");
    }
    rebuildUi();
    Future.microtask(() => setBusy(false));
  }

  Future<void> _showCouponAvailableDialog() async {
    // Show custom dialog - removed auto-dismiss to prevent auto-navigation
    final completer = Completer<void>();
    bool dialogDismissed = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          // Cancel any existing timer
          _dialogAutoDismissTimer?.cancel();

          // No auto-dismiss timer - user must click "Got it" to close
          // This prevents any auto-navigation issues

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title and description without star icon
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Coupons Available! 🎉',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Great news! You can now use coupons to save money on your order. Check out the available coupons in the voucher section.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: kcMediumGrey,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 5,
                        softWrap: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Got it button
                  GestureDetector(
                    onTap: () {
                      if (!dialogDismissed && dialogContext.mounted) {
                        try {
                          // Cancel any timer before closing
                          _dialogAutoDismissTimer?.cancel();
                          Navigator.of(dialogContext).pop();
                          dialogDismissed = true;
                          // Mark that dialog has been shown and dismissed
                          _hasShownCouponDialog = true;
                          if (!completer.isCompleted) {
                            completer.complete();
                          }
                        } catch (e) {
                          // Context might be deactivated, complete anyway
                          _hasShownCouponDialog = true;
                          if (!completer.isCompleted) {
                            completer.complete();
                          }
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: kcPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Got it',
                        style: TextStyle(
                          color: kcWhitColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).then((_) {
        // Dialog was closed (either by button or other means)
        _dialogAutoDismissTimer?.cancel();
        // Mark that dialog has been shown and dismissed
        _hasShownCouponDialog = true;
        if (!completer.isCompleted) {
          completer.complete();
        }
      });
    });

    return completer.future;
  }

  deliveryOffCouponAppplied(List<CouponBody> couponList) async {
    for (int i = 0; i < couponList.length; i++) {
      final spendValue = couponList[i].couponValue;
      final minSpend = double.tryParse(spendValue.toString()) ?? 0.0;

      if (couponList[i].couponType == 'delivery_off' && subTotal >= minSpend) {
        log.wtf(
            "couponType: ${couponList[i].couponType}, checking for delivery_off");

        voucherController.text = couponList[i].couponCode;
        await applyCoupon(false);
        isDeliveryOffCoupon = true;
        // updateCartData();
        // calculateTotal();
        // notifyListeners();
        // rebuildUi();
        showSnackBar(context, message: "Coupon applied successfully");
        break;
      }
    }
  }

  getProductSubmod(CartProducts product) {
    List<SubModifiers> cartSubModifiers = [];
    for (int i = 0; i < product.modifiers!.length; i++) {
      for (int j = 0; j < product.modifiers![i].subModifiers!.length; j++) {
        cartSubModifiers.add(product.modifiers![i].subModifiers![j]);
      }
    }

    return cartSubModifiers;
  }

  updateLocation(LocationAddress? address) {
    selectedAddress = address;
    rebuildUi();
    if (selectedAddress != null) {
      // Defer these calls to avoid setState during build
      Future.microtask(() {
        updateDeliveryCharges(selectedAddress!.id!);
        voucherController.clear();
        // Reset discount when address changes
        discount = 0;
        currentCouponType = null;
        getAllCoupons(selectedAddress!.id!);
        updateCartData();
      });
    }
    rebuildUi();
  }

  Future<void> updateDeliveryCharges(int id) async {
    Future.microtask(() => setBusy(true));
    try {
      final res = await _dbService.getDeliveryCharges(cart.id!, id);
      if (res.success) {
        await updateCartData();
        calculateTotal();
      }
      // If API fails (e.g., 500 error), silently continue - cart data is already loaded
    } catch (e) {
      log.e('Error updating delivery charges: $e');
      // Continue execution even if delivery charges update fails
    } finally {
      Future.microtask(() => setBusy(false));
    }
  }

  updateCartData() async {
    Future.microtask(() => setBusy(true));
    final cartProvider = Provider.of<CartViewModel>(context, listen: false);
    await cartProvider.getMyCart();

    if (cartProvider.cart != null) {
      cart = cartProvider.cart!;
      log.wtf(cart.toJson());
      // Recalculate total after updating cart data to ensure consistency
      calculateTotal();
    }
    Future.microtask(() => setBusy(false));
  }

  void toggleMood(DeliveryMood dMood) {
    this.dMood = dMood;
    rebuildUi();
    calculateTotal();
    if (voucherController.text.isNotEmpty) {
      applyCoupon(true);
    } else {
      discount = 0;
      currentCouponType = null;
      rebuildUi();
    }
  }

  toggleShowMore(int index) {
    log.w('@toggleShowMore');

    if (cartProducts != null) {
      for (int i = 0; i < cartProducts.length; i++) {
        if (i == index) {
          cartProducts[index].showMore = !cartProducts[index].showMore;
        } else {
          cartProducts[i].showMore = false;
        }
      }
    }

    rebuildUi();
  }

  Future<LocationAddress?> routeToSaveAddress() async {
    // Check if user is logged in - if guest, navigate to login
    if (!_authService.checkLogin()) {
      _navService.navigateToLoginView();
      return null;
    }
    LocationAddress address = await _navService.navigateToSaveAddressesView();
    return address;
  }

  ///find total locally
  calculateTotal() {
    double total = 0;
    for (var element in cartProducts) {
      total += (element.totalPrice ?? 0);
    }

    for (var element in cartProducts) {
      double sideItemsPrice = 0;
      for (var element in element.sideItems) {
        sideItemsPrice += double.parse(element.sideItemPrice.toString());
      }
      total += sideItemsPrice;
    }
    // Calculate subtotal (without discount) - includes product prices + all fees
    subTotal = total + calculateOtherExpenses();

    // Calculate total: SubTotal - NewUserDiscount - CouponDiscount
    final newUserDiscount = cart.newUserDiscount;
    totalPrice = subTotal - newUserDiscount - discount;

    // Ensure total is not negative (minimum is 0)
    if (totalPrice < 0) {
      totalPrice = 0;
    }

    log.wtf(
        "calculateTotal - subTotal: $subTotal, newUserDiscount: $newUserDiscount, discount: $discount, totalPrice: $totalPrice");
    notifyListeners();
  }

  ///calculate vat, delivery changes, bag fee, service charges
  calculateOtherExpenses() {
    log.d("@calculateOtherexpenses");
    log.wtf("========================================");
    log.wtf("CALCULATING OTHER EXPENSES");
    log.wtf("========================================");
    log.wtf(
        "Delivery Mode: ${dMood == DeliveryMood.takeAway ? 'Take Away' : 'Delivery'}");
    log.wtf("VAT: ${cart.vat ?? 0}");
    log.wtf("Bag Fee: ${cart.bagFee ?? 0}");
    log.wtf("Service Charges: ${cart.serviceCharges ?? 0}");
    log.wtf("Delivery Fee: ${cart.deliveryFee ?? 0}");

    final expenses = dMood == DeliveryMood.takeAway
        ? (cart.vat ?? 0) + (cart.bagFee ?? 0) + (cart.serviceCharges ?? 0)
        : (cart.vat ?? 0) +
            (cart.bagFee ?? 0) +
            (cart.deliveryFee ?? 0) +
            (cart.serviceCharges ?? 0);

    log.wtf("Total Other Expenses: $expenses");
    log.wtf("========================================");
    return expenses;
  }

  foodIds() {
    List<int> foodIds = [];
    for (var element in cartProducts) {
      foodIds.add(element.productId!);
    }
    return foodIds;
  }

  priceProducts() {
    List<double> priceList = [];
    for (var element in cartProducts) {
      priceList.add(double.parse(element.productPrice.toString()));
    }
    return priceList;
  }

  ///implement stripe here
  Future<void> proceedToPayment() async {
    final hasCouponSelected = voucherController.text.trim().isNotEmpty;
    final hasCouponApplied = discount > 0;

    log.wtf(
        "proceedToPayment - couponList.length: ${couponList.length}, discount: $discount, hasCouponSelected: $hasCouponSelected, _hasShownCouponDialog: $_hasShownCouponDialog");

    if (couponList.isNotEmpty &&
        !hasCouponApplied &&
        !hasCouponSelected &&
        !_hasShownCouponDialog) {
      log.wtf("Showing coupon available dialog (first time)");
      await _showCouponAvailableDialog();
      // After dialog is dismissed, _hasShownCouponDialog will be set to true
      // Return early to prevent automatic payment flow - user must click "Proceed to Payment" again
      return;
    } else {
      log.wtf(
          "NOT showing dialog - couponList.isEmpty: ${couponList.isEmpty}, hasCouponApplied: $hasCouponApplied, hasCouponSelected: $hasCouponSelected, _hasShownCouponDialog: $_hasShownCouponDialog");
    }

    // Proceed with payment flow (either no dialog needed, or dialog was already shown)
    setBusy(true);
    Cart myCart = cart;
    localStorageService.clearOrderData();

    bool connected = await checkInternet();
    if (!connected) {
      setBusy(false);
      return;
    }

    bool paySuccess = false;

    ///
    ///STEP 1:
    ///CHECK PAYMENT METHOD (if stripe is selected)
    if (paymentMethod == PaymentMethod.stripe) {
      // STEP:1.1 request stripe
      paySuccess = await requestStripePayment() ?? false;
      log.wtf("PaySuccess:$paySuccess");
      if (paySuccess == true) {
        log.wtf("PaySuccessTrue:$paySuccess");

        log.wtf(paypalTransactionInfo['message']);

        // STEP:1.2 CLEAR CART
        clearCartData();

        // STEP:1.3 CREATE ORDER
        createOrder();

        // STEP:1.4 NAVIGATE
        navigateToProceed(myCart);

        //
      } else {
        setBusy(false);
        // showSnackBar(context, message: "Transaction failed");
      }
    } else if (paymentMethod == PaymentMethod.cash) {
      clearCartData();

      // STEP:1.3 CREATE ORDER
      createOrder();
      await Future.delayed(Duration(seconds: 5));
      setBusy(false);

      // STEP:1.4 NAVIGATE
      navigateToProceed(myCart);
    } else {
      ///
      /// STEP:2 OTHER WISE (PAYPAL)
      ///
      // PayPal payment is handled asynchronously in requestPayPalPayment()
      // The onSuccess/onError/onCancel callbacks handle the flow
      // Don't call setBusy(false) here as PayPal screen will handle navigation
      requestPayPalPayment();
      // Note: setBusy(false) is NOT called here because PayPal handles its own navigation
      // in the callbacks (onSuccess, onError, onCancel)
    }
  }

  void navigateToProceed(Cart myCart) {
    _navService.back();
    // _navService.back();
    _navService.replaceWithOrderConfirmedView(cart: myCart);
  }

  void clearCartData() {
    final cartProvider = Provider.of<CartViewModel>(context, listen: false);
    cartProvider.clearCarOnOrderCreation();
  }

  isAddressNotSelected() {
    final locationVm =
        Provider.of<GlobalLocationViewModel>(context, listen: false);
    if (locationVm.getSelectedAddress?.id == null &&
        dMood == DeliveryMood.delivery) {
      return true;
    }

    return false;
  }

  createOrder() async {
    setBusy(true);
    //get transactionId here
    final createOrderProvider =
        Provider.of<CreateOrderViewModel>(context, listen: false);

    await createOrderProvider.createOrder(initOrderObject(), paymentIntent,
        paypalTransactionInfo: paypalTransactionInfo);

    setBusy(false);
  }

  requestPayPalPayment() async {
    // Format amounts as strings with exactly 2 decimal places for PayPal
    // PayPal requires amounts to be strings in format "XX.XX"
    final formattedTotal = totalPrice.toStringAsFixed(2);
    final formattedSubtotal = totalPrice.toStringAsFixed(2);

    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: false,
        clientId: '${dotenv.env['PAYPAL_PUBLISH']}',
        secretKey: '${dotenv.env['PAYPAL_SECRET']}',
        transactions: [
          {
            "amount": {
              "total": formattedTotal,
              "currency": "GBP",
              "details": {
                "subtotal":
                    formattedSubtotal, // Use totalPrice as subtotal to match PayPal's requirement: subtotal + shipping - shipping_discount = total
                "shipping": '0.00',
                "shipping_discount": '0.00'
              }
            },
            "description": "The payment transaction description.",
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          paypalTransactionInfo = params;
          Navigator.pop(context, true);
          setBusy(false);
          Cart myCart = cart;
          //clear cart data
          clearCartData();

          //create order
          createOrder();

          ///navigate
          navigateToProceed(myCart);
          return true;
        },
        onError: (error) {
          Navigator.pop(context, false);
          setBusy(false);
          log.e("PayPal payment error: $error");
          showSnackBar(context, message: "Payment failed. Please try again.");
          return false;
        },
        onCancel: () {
          Navigator.pop(context, false);
          setBusy(false);
          return false;
        },
      ),
    ));

    // If user pressed back button (result is null), reset busy state
    // The callbacks (onSuccess, onError, onCancel) handle setBusy(false) for their cases
    if (result == null) {
      setBusy(false);
    }
  }

  Map<dynamic, dynamic> paypalTransactionInfo = {};

  Future<bool> checkInternet() async {
    // /
    // / If not connected to internet, show an alert dialog
    // / to activate the network connection.
    // /
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // _showDialog();
      showSnackBar(context,
          message:
              "You have no internet connection or weak internet connection!");
      return false;
    }
    return true;
  }

  applyCoupon(bool isMessage) async {
    setBusy(true);

    // Store previous total to calculate discount difference
    final previousTotal = totalPrice;

    CartResponse res =
        await _dbService.applyCoupons(voucherController.text, cart.id!);
    if (res.success) {
      cart = res.body!.cart!;

      // Get discount from cart response first
      discount = cart.discounts ?? 0;

      log.wtf(
          "Coupon Applied - coupon_id: ${cart.couponId}, discounts from API: $discount");

      // Reset delivery off flag - will be set to true only for delivery_off coupons
      isDeliveryOffCoupon = false;

      // Store current coupon type for later use
      currentCouponType = null;

      // If discount is 0 but coupon_id is set, calculate discount from coupon details
      if (discount == 0 && cart.couponId != null) {
        // Find the applied coupon in the coupon list
        final appliedCoupon = couponList.firstWhere(
          (coupon) => coupon.couponCode == voucherController.text.trim(),
          orElse: () => CouponBody(
            couponId: 0,
            couponCode: '',
            couponTitle: '',
            couponValue: '',
            couponType: '',
            couponDiscount: '0',
            couponStartDate: '',
            couponEndDate: '',
            couponQuantity: '',
            couponMaximumSpend: '',
            couponMinimumSpend: '',
            couponPerCustomer: '',
            couponStatus: 0,
            createdAt: '',
            updatedAt: '',
            couponImage: '',
            deletedAt: null,
          ),
        );

        // Store coupon type for use in total calculation
        currentCouponType = appliedCoupon.couponType;

        log.wtf(
            "Applied Coupon Details - Type: ${appliedCoupon.couponType}, Discount: ${appliedCoupon.couponDiscount}, Value: ${appliedCoupon.couponValue}");

        if (appliedCoupon.couponCode.isNotEmpty) {
          // Use cart's subtotal from API (more accurate)
          final cartSubTotal = cart.subTotal ?? 0.0;

          // Parse coupon discount value
          final couponDiscountValue =
              double.tryParse(appliedCoupon.couponDiscount) ?? 0.0;
          final couponValue = double.tryParse(appliedCoupon.couponValue) ?? 0.0;

          // Calculate discount based on coupon type
          if (appliedCoupon.couponType == 'percent' &&
              couponDiscountValue > 0) {
            // Percentage discount: calculate from cart subtotal
            discount = (cartSubTotal * couponDiscountValue) / 100;
            log.wtf(
                "Calculated percentage discount: $discount (${couponDiscountValue}% of $cartSubTotal)");
          }
          // If coupon type is fixed amount, use the discount value directly
          else if (appliedCoupon.couponType == 'fixed' ||
              appliedCoupon.couponType == 'fixed_cart') {
            discount =
                couponDiscountValue > 0 ? couponDiscountValue : couponValue;
            log.wtf("Fixed discount: $discount");
          }
          // For delivery_off type, discount should ONLY equal the delivery fee
          // This ensures delivery_off coupons only affect delivery fees, not other charges
          else if (appliedCoupon.couponType == 'delivery_off') {
            log.wtf("========================================");
            log.wtf("DELIVERY_OFF COUPON CALCULATION");
            log.wtf("========================================");
            log.wtf("Coupon Code: ${appliedCoupon.couponCode}");
            log.wtf("Coupon Type: ${appliedCoupon.couponType}");
            log.wtf("Coupon Discount Value: $couponDiscountValue");
            log.wtf("Coupon Value: $couponValue");
            log.wtf("Cart Delivery Fee: ${cart.deliveryFee ?? 0}");
            log.wtf("Cart SubTotal: $cartSubTotal");

            // For delivery_off coupons, discount should ONLY be the delivery fee amount
            // If delivery fee is 0, discount must be 0 (no delivery fee to discount)
            if (cart.deliveryFee != null && cart.deliveryFee! > 0) {
              discount = cart.deliveryFee!;
              isDeliveryOffCoupon =
                  true; // Set flag for strikethrough on delivery fee
              log.wtf("✓ Using delivery fee as discount: $discount");
              log.wtf(
                  "  → This means free delivery (delivery fee will be subtracted)");
            } else {
              // Delivery fee is 0 or null, so no discount applies
              // This ensures delivery_off only subtracts delivery fees, not other charges
              discount = 0;
              log.wtf("✗ No discount applied");
              log.wtf("  → Delivery fee is ${cart.deliveryFee ?? 0}");
              log.wtf("  → For delivery_off coupons, discount = delivery fee");
              log.wtf("  → Since delivery fee is 0, discount must be 0");
              log.wtf(
                  "  → This ensures delivery_off only affects delivery fees, not other charges");
            }
            log.wtf("Final Discount Amount: $discount");
            log.wtf("========================================");
          }
          // Try using couponValue as discount if couponDiscount is 0
          else if (couponValue > 0) {
            discount = couponValue;
            log.wtf("Using couponValue as discount: $discount");
          }
          // If still 0, try to calculate from total difference
          else if (previousTotal > 0) {
            final newTotal =
                double.parse((res.body?.cart?.total ?? 0).toString());
            discount = previousTotal - newTotal;
            if (discount < 0) discount = 0; // Ensure non-negative
            log.wtf(
                "Calculated discount from total difference: $discount (Previous: $previousTotal, New: $newTotal)");
          }
        }
      }

      // Recalculate subtotal locally to ensure all fees are included
      // SubTotal = Product Prices + Side Items + Delivery Fee + Service Charges + Bag Fee + VAT
      double productTotal = 0;
      for (var element in cartProducts) {
        productTotal += (element.totalPrice ?? 0);
      }

      for (var element in cartProducts) {
        double sideItemsPrice = 0;
        for (var sideItem in element.sideItems) {
          sideItemsPrice += double.parse(sideItem.sideItemPrice.toString());
        }
        productTotal += sideItemsPrice;
      }

      // Add all other expenses (delivery fee, service charges, bag fee, VAT)
      final otherExpenses = calculateOtherExpenses();
      subTotal = productTotal + otherExpenses;

      // Calculate total: SubTotal - NewUserDiscount - CouponDiscount
      // For delivery_off coupons, discount only affects delivery fees, not other calculations
      final newUserDiscount = cart.newUserDiscount;

      // Log calculation details
      log.wtf("========================================");
      log.wtf("TOTAL CALCULATION");
      log.wtf("========================================");
      log.wtf("Product Total: $productTotal");
      log.wtf("Other Expenses: $otherExpenses");
      log.wtf("  → Delivery Fee: ${cart.deliveryFee ?? 0}");
      log.wtf("  → Service Charges: ${cart.serviceCharges ?? 0}");
      log.wtf("  → Bag Fee: ${cart.bagFee ?? 0}");
      log.wtf("  → VAT: ${cart.vat ?? 0}");
      log.wtf("SubTotal: $subTotal");
      log.wtf("New User Discount: $newUserDiscount");
      log.wtf("Coupon Discount: $discount");

      // If coupon is delivery_off type, discount is already set correctly in applyCoupon
      // (discount = delivery fee, or 0 if delivery fee is 0)
      // So we can apply it normally - it will only subtract the delivery fee amount
      if (currentCouponType == 'delivery_off') {
        log.wtf("Coupon Type: delivery_off");
        log.wtf("  → Discount should only affect delivery fees");
        log.wtf("  → Current discount amount: $discount");
        log.wtf("  → Delivery fee in cart: ${cart.deliveryFee ?? 0}");
        log.wtf("  → Discount is already set correctly in applyCoupon");
        log.wtf(
            "  → For delivery_off: discount = delivery fee (or 0 if delivery fee is 0)");
        totalPrice = subTotal - newUserDiscount - discount;
        log.wtf(
            "  → Total Price: $totalPrice (SubTotal: $subTotal - NewUserDiscount: $newUserDiscount - Discount: $discount)");
      } else if (currentCouponType != null) {
        log.wtf("Coupon Type: $currentCouponType");
        log.wtf("  → Applying discount normally to total");
        // For other coupon types (percent, fixed, fixed_cart), apply discount normally
        totalPrice = subTotal - newUserDiscount - discount;
        log.wtf(
            "  → Total Price: $totalPrice (SubTotal: $subTotal - NewUserDiscount: $newUserDiscount - Discount: $discount)");
      } else {
        // No coupon applied or coupon type not determined
        totalPrice = subTotal - newUserDiscount - discount;
        log.wtf("Coupon Type: Not determined or no coupon");
        log.wtf(
            "  → Total Price: $totalPrice (SubTotal: $subTotal - NewUserDiscount: $newUserDiscount - Discount: $discount)");
      }
      log.wtf("========================================");

      // Ensure total is not negative (minimum is 0)
      if (totalPrice < 0) {
        totalPrice = 0;
      }

      log.wtf(
          "Final values - ProductTotal: $productTotal, OtherExpenses: $otherExpenses, SubTotal: $subTotal, NewUserDiscount: $newUserDiscount, Discount: $discount, Total: $totalPrice");

      if (isMessage) {
        showSnackBar(context, message: "Coupon applied successfully");
      }
    } else {
      // Reset discount if coupon application failed
      discount = 0;
      currentCouponType = null;
      // Clear the text field if coupon application failed
      voucherController.clear();
      showSnackBar(context, message: "${res.error}");
    }
    // updateCartData();
    rebuildUi();
    setBusy(false);
  }

  Order initOrderObject() {
    log.wtf("initOrderObject");
    log.w("isScheduled: ${isScheduled()}");
    // log.w("chosenSlotID: ${chosenSlot?.id ?? 0} ");
    final locationVm =
        Provider.of<GlobalLocationViewModel>(context, listen: false);
    Order order = Order(
      addressId: dMood == DeliveryMood.delivery
          ? locationVm.getSelectedAddress!.id!
          : 0,
      paymentStatus: '',
      paymentMethod: paymentMethod.name,
      cartId: cart.id!,
      orderType: dMood.name,
      orderNote: note,
      transactionId: '',
      isScheduled: isScheduled() ? 1 : 0,
      scheduleSlotId: isScheduled() ? chosenSlot?.id ?? 0 : 0,
    );

    return order;
  }

  bool isScheduled() {
    if (chosenDate != null && chosenSlot != null) {
      return true;
    }
    return false;
  }

  Future<bool>? requestStripePayment() async {
    paymentIntent = await PaymentService().makePayment(totalPrice, context);
    setBusy(false);
    log.wtf(paymentIntent);
    //save payment intent id locally
    savePaymentIntentLocally();
    savePaymentIntentIdLocally(paymentIntent?['id']);

    bool pay = await PaymentService().displayPaymentSheet();

    log.wtf(pay);
    log.wtf("your data");
    return pay;
  }

  saveCardInfoToSql() {
    ///
    ///USE DATABASE HELPER TO SAVE CARD INFORMATION INTO LOCAL
    ///
    // Example of inserting a card
    // CardInfo card = CardInfo(
    //   cardNumber: '1234567812345678',
    //   cardHolderName: 'John Doe',
    //   expiryDate: '12/24',
    //   cvv: '123',
    // );

    // DatabaseHelper databaseHelper = DatabaseHelper();
    // await databaseHelper.insertCard(card);

    /// Example of getting all cards
    // List<CardInfo> cards = await databaseHelper.getCards();
  }

  savePaymentIntentIdLocally(String id) {
    _localStorage.setPaymentIntentId = id;
  }

  // saveTransactionIdLocally(String id) {
  //   _localStorage.setTransactionId = id;
  // }

  // Future<Map<String, dynamic>?> retrieveTxnId(
  //     {required String paymentIntent}) async {
  //   log.wtf(paymentIntent);
  //   try {
  //     http.Response response = await http.get(
  //         Uri.parse(
  //             'https://api.stripe.com/v1/charges?payment_intent=$paymentIntent'),
  //         headers: {
  //           'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
  //           "Content-Type": "application/x-www-form-urlencoded"
  //         });
  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.body);
  //       log.wtf(data['data']);
  //       transactionData = data['data'][0];
  //       transactionId = data['data'][0]['balance_transaction'];
  //       log.wtf("Transaction Id ${data['data'][0]['balance_transaction']}");
  //       return transactionData;
  //     }
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  //   return null;
  // }

  // void _failureDialog() {
  //   const AlertDialog(
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(
  //               Icons.cancel,
  //               color: Colors.red,
  //             ),
  //             Text("Payment Failed"),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _successDialog(context) {
  //   showDialog(
  //       context: context,
  //       builder: (_) => const AlertDialog(
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Icon(
  //                   Icons.check_circle,
  //                   color: Colors.green,
  //                   size: 100.0,
  //                 ),
  //                 SizedBox(height: 10.0),
  //                 Text("Payment Successful!"),
  //               ],
  //             ),
  //           ));
  // }

  ///save to local
  void savePaymentIntentLocally() {
    _localStorage.setPaymentIntent = "";
    _localStorage.setPaymentIntent = paymentIntent;
  }

  Future<void> openScheduleSheet() async {
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.scheduleSheet,
      title: "Choose Timings",
      description: "Choose your preferred date and time",
      data: {
        "cartProducts": cartProducts,
        "notes": note,
        "restaurantId": restaurantId,
        "cart": cart,
        "restaurantAvailableSlots": restaurantAvailableSlots,
      },
    );

    if (response != null && response.confirmed) {
      final selectedDate = response.data?["date"] as DateTime?;
      final selectedSlot = response.data?["slot"] as Slots?;

      if (selectedDate != null) {
        assignDate(selectedDate);
      }
      if (selectedSlot != null) {
        assignTime(selectedSlot);
      }

      log.w("Scheduled Date: $selectedDate, Slot: $selectedSlot");
    }
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

  generateWeeklyDates(List<RestaurantAvailableSlots>? availableSlots) {
    if (availableSlots != null || availableSlots!.isNotEmpty) {
      weeklyDates = [];
      for (int i = 0; i < availableSlots.length; i++) {
        if (availableSlots[i].slots!.isNotEmpty) {
          weeklyDates.add(
            CustomDate(
              date: availableSlots.isNotEmpty
                  ? availableSlots[i].date!
                  : DateTime.now().add(
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

      if (weeklyDates != null && weeklyDates.isNotEmpty) {
        chosenDate = weeklyDates[0].date;
        weeklyDates[0].isSelected = true;
      } else {
        chosenDate = DateTime.now();
      }
    } else {
      weeklyDates = [];
      chosenDate = null;
    }
    notifyListeners();
  }

  void selectDate(int selectedDateIndex) {
    for (CustomDate date in weeklyDates) {
      date.isSelected = (date.date == weeklyDates[selectedDateIndex].date);
      if (date.isSelected) {
        choosenDate = weeklyDates[selectedDateIndex].date;
      }
    }
    log.w('Selected date: $choosenDate');
    notifyListeners();
  }

  bool isTodaysDateSelected({required DateTime date}) {
    DateTime todayDate = DateTime(date.year, date.month, date.day);
    DateTime selectedDate =
        DateTime(choosenDate.year, choosenDate.month, choosenDate.day);

    log.w(
        '@isTodaysDateSelected todayDate: $todayDate selectedDate: $selectedDate');
    if (todayDate.year == selectedDate.year &&
        todayDate.month == selectedDate.month &&
        todayDate.day == selectedDate.day) {
      return true;
    }

    return false;
  }

  bool isDateAndTimeRangeChoosen() {
    log.wtf('@isDateAndTimeRangeChoosen');
    log.wtf('chosenDate: $chosenDate, chosenSlot: $chosenSlot');
    if (chosenDate != null && chosenSlot != null) {
      return true;
    }
    return false;
  }

  assignDate(
    DateTime date,
  ) {
    chosenDate = date;
    log.w('@assignDate $chosenDate');
    notifyListeners();
  }

  assignTime(Slots time) {
    chosenSlot = time;
    log.w('@assignTime $chosenSlot');
    notifyListeners();
  }

  void selectTime(
    int selectedTimeIndex,
    Slots customTime,
  ) {
    getGeneralTimeRange();
    for (int i = 0; i < generalTimeRange.length; i++) {
      if (i == selectedTimeIndex) {
        log.wtf("choosen slot matches: ${i == selectedTimeIndex}");
        generalTimeRange[i].isSelected = true;
        log.wtf("isSelected: ${generalTimeRange[i].isSelected}");
        chosenSlot = generalTimeRange[i];
      } else {
        generalTimeRange[i].isSelected = false;
      }
    }
    // clearTodaysTimingsSelection(customTime);
    // }

    notifyListeners();
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
}

enum DeliveryMood {
  delivery,
  takeAway,
}
