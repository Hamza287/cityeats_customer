import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/models/order_model.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/services/local_storage_service.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:city_customer_app/ui/views/account/account_view.dart';
import 'package:city_customer_app/ui/views/cart/cart_viewmodel.dart';
import 'package:city_customer_app/ui/views/deals/deals_view.dart';
import 'package:city_customer_app/ui/views/home/home_view.dart';
import 'package:city_customer_app/ui/views/search/search_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RootViewModel extends BaseViewModel {
  int currentIndex = 0;
  Order? orderObj;
  BuildContext context;

  RootViewModel(this.currentIndex, this.context) {
    _log.w("PnedingOderdata: ${_localStroage.getOrderData()}");

    // Allow guest browsing - run background tasks only if logged in
    if (authService.isLogin) {
      runInBackground();
    }
    // Guest users can browse, but background tasks (like pending orders) only run when logged in
  }
  final authService = locator<AuthService>();
  final navigationSErvice = locator<NavigationService>();
  final _localStroage = locator<LocalStorageService>();
  final _dbService = locator<DatabaseService>();
  final _log = Logger();

  final List<Widget> _pages = const [
    HomeView(),
    SearchView(),
    DealsView(),
    AccountView(),
  ];

  get getPages => _pages;

  togglePage(index, context) {
    // print("index $index");
    if (index == 3) {
      if (authService.checkLogin()) {
        currentIndex = index;
      } else {
        showSnackBar(context, message: "Please Login First");
        navigationSErvice.navigateToLoginView();
      }
    } else {
      currentIndex = index;
    }
    rebuildUi();
  }

  void clearCartData() {
    final cartProvider = Provider.of<CartViewModel>(context, listen: false);
    cartProvider.clearCarOnOrderCreation();
  }

  createPendingOrder() async {
    Map<String, dynamic>? orderData = _localStroage.getOrderData();

    if (orderData != null) {
      Order? orderObj = Order(
          addressId: orderData['addressId'],
          paymentStatus: orderData['paymentStatus'],
          paymentMethod: orderData['paymentMethod'],
          cartId: orderData['cartId'],
          orderType: orderData['orderType'],
          orderNote: orderData['orderNote'],
          transactionId: orderData['transactionId']);

      final res = await _dbService.createOrder(orderObj);
      if (res['success'] ?? false) {
        _localStroage.clearOrderData();
        clearCartData();
      } else {
        if (res['error'].toString().contains("not taking")) {
        } else {
          Future.delayed(const Duration(seconds: 60), (() {}));
        }
      }
    }
    rebuildUi();
  }

  Future<bool> checkInternet() async {
    // /
    // / If not connected to internet, show an alert dialog
    // / to activate the network connection.
    // /
    final connectivityResult = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      // _showDialog();
      // showSnackBar(context,
      //     message:
      //         "You have no internet connection or weak internet connection!");
      return false;
    }
    return true;
  }

  void runInBackground() {
    Future.delayed(Duration(milliseconds: 30000), () async {
      // This code will run in the background after 2500 ms

      bool isInternetConnected = await checkInternet();
      if (_localStroage.getOrderData() != null && isInternetConnected) {
        createPendingOrder();
      }
      runInBackground();
      createPendingOrder();
    });
  }
}
