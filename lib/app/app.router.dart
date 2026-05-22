// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:city_customer_app/responses/addresses_response.dart' as _i38;
import 'package:city_customer_app/responses/cart_response.dart' as _i40;
import 'package:city_customer_app/responses/restaurant_response.dart' as _i39;
import 'package:city_customer_app/ui/views/account/account_view.dart' as _i13;
import 'package:city_customer_app/ui/views/add_to_cart/add_to_cart_view.dart'
    as _i21;
import 'package:city_customer_app/ui/views/cart/cart_view.dart' as _i18;
import 'package:city_customer_app/ui/views/categrory_rest/categrory_rest_view.dart'
    as _i19;
import 'package:city_customer_app/ui/views/change_password/change_password_view.dart'
    as _i27;
import 'package:city_customer_app/ui/views/checkout/checkout_view.dart' as _i20;
import 'package:city_customer_app/ui/views/deals/deals_view.dart' as _i25;
import 'package:city_customer_app/ui/views/edit_profile/edit_profile_view.dart'
    as _i26;
import 'package:city_customer_app/ui/views/email_verification/email_verification_view.dart'
    as _i14;
import 'package:city_customer_app/ui/views/enable_location/enable_location_view.dart'
    as _i10;
import 'package:city_customer_app/ui/views/favorite/favorite_view.dart' as _i31;
import 'package:city_customer_app/ui/views/filter/filter_view.dart' as _i24;
import 'package:city_customer_app/ui/views/forgot_password/forgot_password_view.dart'
    as _i8;
import 'package:city_customer_app/ui/views/home/home_view.dart' as _i2;
import 'package:city_customer_app/ui/views/location/location_view.dart' as _i11;
import 'package:city_customer_app/ui/views/login/login_view.dart' as _i6;
import 'package:city_customer_app/ui/views/my_orders/my_orders_view.dart'
    as _i22;
import 'package:city_customer_app/ui/views/new_password/new_password_view.dart'
    as _i9;
import 'package:city_customer_app/ui/views/order_confirmed/order_confirmed_view.dart'
    as _i30;
import 'package:city_customer_app/ui/views/order_detail/order_detail_view.dart'
    as _i23;
import 'package:city_customer_app/ui/views/product_description/product_description_view.dart'
    as _i16;
import 'package:city_customer_app/ui/views/restaurant_detail/restaurant_detail_view.dart'
    as _i15;
import 'package:city_customer_app/ui/views/restaurant_detail/widgets/custom_date_picker_view.dart'
    as _i36;
import 'package:city_customer_app/ui/views/restaurant_info/restaurant_info_view.dart'
    as _i17;
import 'package:city_customer_app/ui/views/root/root_view.dart' as _i12;
import 'package:city_customer_app/ui/views/save_addresses/save_addresses_view.dart'
    as _i29;
import 'package:city_customer_app/ui/views/search/search_view.dart' as _i32;
import 'package:city_customer_app/ui/views/select_map_location/select_map_location_view.dart'
    as _i35;
import 'package:city_customer_app/ui/views/showfilerdata/showfilerdata_view.dart'
    as _i33;
import 'package:city_customer_app/ui/views/sign_up/sign_up_view.dart' as _i7;
import 'package:city_customer_app/ui/views/startup/startup_view.dart' as _i3;
import 'package:city_customer_app/ui/views/support_help/support_help_view.dart'
    as _i28;
import 'package:city_customer_app/ui/views/update.dart' as _i34;
import 'package:city_customer_app/ui/views/walkthrough/walkthrough_view.dart'
    as _i4;
import 'package:city_customer_app/ui/views/welcome/welcome_view.dart' as _i5;
import 'package:flutter/material.dart' as _i37;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i41;

class Routes {
  static const homeView = '/home-view';

  static const startupView = '/startup-view';

  static const walkthroughView = '/walkthrough-view';

  static const welcomeView = '/welcome-view';

  static const loginView = '/login-view';

  static const signUpView = '/sign-up-view';

  static const forgotPasswordView = '/forgot-password-view';

  static const newPasswordView = '/new-password-view';

  static const enableLocationView = '/enable-location-view';

  static const locationView = '/location-view';

  static const rootView = '/root-view';

  static const accountView = '/account-view';

  static const emailVerificationView = '/email-verification-view';

  static const restaurantDetailView = '/restaurant-detail-view';

  static const productDescriptionView = '/product-description-view';

  static const restaurantInfoView = '/restaurant-info-view';

  static const cartView = '/cart-view';

  static const categroryRestView = '/categrory-rest-view';

  static const checkoutView = '/checkout-view';

  static const addToCartView = '/add-to-cart-view';

  static const myOrdersView = '/my-orders-view';

  static const orderDetailView = '/order-detail-view';

  static const filterView = '/filter-view';

  static const dealsView = '/deals-view';

  static const editProfileView = '/edit-profile-view';

  static const changePasswordView = '/change-password-view';

  static const supportHelpView = '/support-help-view';

  static const saveAddressesView = '/save-addresses-view';

  static const orderConfirmedView = '/order-confirmed-view';

  static const favoriteView = '/favorite-view';

  static const searchView = '/search-view';

  static const showfilerdataView = '/showfilerdata-view';

  static const updateScreen = '/update-screen';

  static const selectMapLocationView = '/select-map-location-view';

  static const customDatePickerView = '/custom-date-picker-view';

  static const all = <String>{
    homeView,
    startupView,
    walkthroughView,
    welcomeView,
    loginView,
    signUpView,
    forgotPasswordView,
    newPasswordView,
    enableLocationView,
    locationView,
    rootView,
    accountView,
    emailVerificationView,
    restaurantDetailView,
    productDescriptionView,
    restaurantInfoView,
    cartView,
    categroryRestView,
    checkoutView,
    addToCartView,
    myOrdersView,
    orderDetailView,
    filterView,
    dealsView,
    editProfileView,
    changePasswordView,
    supportHelpView,
    saveAddressesView,
    orderConfirmedView,
    favoriteView,
    searchView,
    showfilerdataView,
    updateScreen,
    selectMapLocationView,
    customDatePickerView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      Routes.startupView,
      page: _i3.StartupView,
    ),
    _i1.RouteDef(
      Routes.walkthroughView,
      page: _i4.WalkthroughView,
    ),
    _i1.RouteDef(
      Routes.welcomeView,
      page: _i5.WelcomeView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i6.LoginView,
    ),
    _i1.RouteDef(
      Routes.signUpView,
      page: _i7.SignUpView,
    ),
    _i1.RouteDef(
      Routes.forgotPasswordView,
      page: _i8.ForgotPasswordView,
    ),
    _i1.RouteDef(
      Routes.newPasswordView,
      page: _i9.NewPasswordView,
    ),
    _i1.RouteDef(
      Routes.enableLocationView,
      page: _i10.EnableLocationView,
    ),
    _i1.RouteDef(
      Routes.locationView,
      page: _i11.LocationView,
    ),
    _i1.RouteDef(
      Routes.rootView,
      page: _i12.RootView,
    ),
    _i1.RouteDef(
      Routes.accountView,
      page: _i13.AccountView,
    ),
    _i1.RouteDef(
      Routes.emailVerificationView,
      page: _i14.EmailVerificationView,
    ),
    _i1.RouteDef(
      Routes.restaurantDetailView,
      page: _i15.RestaurantDetailView,
    ),
    _i1.RouteDef(
      Routes.productDescriptionView,
      page: _i16.ProductDescriptionView,
    ),
    _i1.RouteDef(
      Routes.restaurantInfoView,
      page: _i17.RestaurantInfoView,
    ),
    _i1.RouteDef(
      Routes.cartView,
      page: _i18.CartView,
    ),
    _i1.RouteDef(
      Routes.categroryRestView,
      page: _i19.CategroryRestView,
    ),
    _i1.RouteDef(
      Routes.checkoutView,
      page: _i20.CheckoutView,
    ),
    _i1.RouteDef(
      Routes.addToCartView,
      page: _i21.AddToCartView,
    ),
    _i1.RouteDef(
      Routes.myOrdersView,
      page: _i22.MyOrdersView,
    ),
    _i1.RouteDef(
      Routes.orderDetailView,
      page: _i23.OrderDetailView,
    ),
    _i1.RouteDef(
      Routes.filterView,
      page: _i24.FilterView,
    ),
    _i1.RouteDef(
      Routes.dealsView,
      page: _i25.DealsView,
    ),
    _i1.RouteDef(
      Routes.editProfileView,
      page: _i26.EditProfileView,
    ),
    _i1.RouteDef(
      Routes.changePasswordView,
      page: _i27.ChangePasswordView,
    ),
    _i1.RouteDef(
      Routes.supportHelpView,
      page: _i28.SupportHelpView,
    ),
    _i1.RouteDef(
      Routes.saveAddressesView,
      page: _i29.SaveAddressesView,
    ),
    _i1.RouteDef(
      Routes.orderConfirmedView,
      page: _i30.OrderConfirmedView,
    ),
    _i1.RouteDef(
      Routes.favoriteView,
      page: _i31.FavoriteView,
    ),
    _i1.RouteDef(
      Routes.searchView,
      page: _i32.SearchView,
    ),
    _i1.RouteDef(
      Routes.showfilerdataView,
      page: _i33.ShowfilerdataView,
    ),
    _i1.RouteDef(
      Routes.updateScreen,
      page: _i34.UpdateScreen,
    ),
    _i1.RouteDef(
      Routes.selectMapLocationView,
      page: _i35.SelectMapLocationView,
    ),
    _i1.RouteDef(
      Routes.customDatePickerView,
      page: _i36.CustomDatePickerView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.HomeView(),
        settings: data,
      );
    },
    _i3.StartupView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.StartupView(),
        settings: data,
      );
    },
    _i4.WalkthroughView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.WalkthroughView(),
        settings: data,
      );
    },
    _i5.WelcomeView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.WelcomeView(),
        settings: data,
      );
    },
    _i6.LoginView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.LoginView(),
        settings: data,
      );
    },
    _i7.SignUpView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.SignUpView(),
        settings: data,
      );
    },
    _i8.ForgotPasswordView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i8.ForgotPasswordView(),
        settings: data,
      );
    },
    _i9.NewPasswordView: (data) {
      final args = data.getArgs<NewPasswordViewArguments>(nullOk: false);
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i9.NewPasswordView(key: args.key, email: args.email),
        settings: data,
      );
    },
    _i10.EnableLocationView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.EnableLocationView(),
        settings: data,
      );
    },
    _i11.LocationView: (data) {
      final args = data.getArgs<LocationViewArguments>(
        orElse: () => const LocationViewArguments(),
      );
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i11.LocationView(key: args.key, address: args.address),
        settings: data,
      );
    },
    _i12.RootView: (data) {
      final args = data.getArgs<RootViewArguments>(
        orElse: () => const RootViewArguments(),
      );
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => _i12.RootView(key: args.key, index: args.index),
        settings: data,
      );
    },
    _i13.AccountView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.AccountView(),
        settings: data,
      );
    },
    _i14.EmailVerificationView: (data) {
      final args = data.getArgs<EmailVerificationViewArguments>(nullOk: false);
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => _i14.EmailVerificationView(
            key: args.key,
            email: args.email,
            isRoutedFromForgotView: args.isRoutedFromForgotView),
        settings: data,
      );
    },
    _i15.RestaurantDetailView: (data) {
      final args = data.getArgs<RestaurantDetailViewArguments>(nullOk: false);
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => _i15.RestaurantDetailView(
            key: args.key,
            restaurantId: args.restaurantId,
            restaurant: args.restaurant,
            foodId: args.foodId),
        settings: data,
      );
    },
    _i16.ProductDescriptionView: (data) {
      final args = data.getArgs<ProductDescriptionViewArguments>(nullOk: false);
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => _i16.ProductDescriptionView(
            key: args.key,
            restaurantId: args.restaurantId,
            foodId: args.foodId,
            isNavigatedFromBanner: args.isNavigatedFromBanner),
        settings: data,
      );
    },
    _i17.RestaurantInfoView: (data) {
      final args = data.getArgs<RestaurantInfoViewArguments>(nullOk: false);
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => _i17.RestaurantInfoView(
            key: args.key,
            restaurant: args.restaurant,
            chargePerKm: args.chargePerKm,
            customerCharge: args.customerCharge,
            customerRadius: args.customerRadius),
        settings: data,
      );
    },
    _i18.CartView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i18.CartView(),
        settings: data,
      );
    },
    _i19.CategroryRestView: (data) {
      final args = data.getArgs<CategroryRestViewArguments>(nullOk: false);
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => _i19.CategroryRestView(
            key: args.key,
            catId: args.catId,
            catName: args.catName,
            isGrocery: args.isGrocery),
        settings: data,
      );
    },
    _i20.CheckoutView: (data) {
      final args = data.getArgs<CheckoutViewArguments>(nullOk: false);
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => _i20.CheckoutView(
            key: args.key,
            cartProducts: args.cartProducts,
            note: args.note,
            restaurantId: args.restaurantId,
            cart: args.cart,
            scheduledDate: args.scheduledDate,
            restaurantAvailableSlots: args.restaurantAvailableSlots),
        settings: data,
      );
    },
    _i21.AddToCartView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i21.AddToCartView(),
        settings: data,
      );
    },
    _i22.MyOrdersView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i22.MyOrdersView(),
        settings: data,
      );
    },
    _i23.OrderDetailView: (data) {
      final args = data.getArgs<OrderDetailViewArguments>(nullOk: false);
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i23.OrderDetailView(key: args.key, orderId: args.orderId),
        settings: data,
      );
    },
    _i24.FilterView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i24.FilterView(),
        settings: data,
      );
    },
    _i25.DealsView: (data) {
      final args = data.getArgs<DealsViewArguments>(
        orElse: () => const DealsViewArguments(),
      );
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i25.DealsView(key: args.key, showBackButton: args.showBackButton),
        settings: data,
      );
    },
    _i26.EditProfileView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i26.EditProfileView(),
        settings: data,
      );
    },
    _i27.ChangePasswordView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i27.ChangePasswordView(),
        settings: data,
      );
    },
    _i28.SupportHelpView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i28.SupportHelpView(),
        settings: data,
      );
    },
    _i29.SaveAddressesView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i29.SaveAddressesView(),
        settings: data,
      );
    },
    _i30.OrderConfirmedView: (data) {
      final args = data.getArgs<OrderConfirmedViewArguments>(nullOk: false);
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i30.OrderConfirmedView(key: args.key, cart: args.cart),
        settings: data,
      );
    },
    _i31.FavoriteView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i31.FavoriteView(),
        settings: data,
      );
    },
    _i32.SearchView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i32.SearchView(),
        settings: data,
      );
    },
    _i33.ShowfilerdataView: (data) {
      final args = data.getArgs<ShowfilerdataViewArguments>(nullOk: false);
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i33.ShowfilerdataView(key: args.key, response: args.response),
        settings: data,
      );
    },
    _i34.UpdateScreen: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i34.UpdateScreen(),
        settings: data,
      );
    },
    _i35.SelectMapLocationView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i35.SelectMapLocationView(),
        settings: data,
      );
    },
    _i36.CustomDatePickerView: (data) {
      return _i37.MaterialPageRoute<dynamic>(
        builder: (context) => const _i36.CustomDatePickerView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class NewPasswordViewArguments {
  const NewPasswordViewArguments({
    this.key,
    required this.email,
  });

  final _i37.Key? key;

  final String email;

  @override
  String toString() {
    return '{"key": "$key", "email": "$email"}';
  }

  @override
  bool operator ==(covariant NewPasswordViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.email == email;
  }

  @override
  int get hashCode {
    return key.hashCode ^ email.hashCode;
  }
}

class LocationViewArguments {
  const LocationViewArguments({
    this.key,
    this.address,
  });

  final _i37.Key? key;

  final _i38.LocationAddress? address;

  @override
  String toString() {
    return '{"key": "$key", "address": "$address"}';
  }

  @override
  bool operator ==(covariant LocationViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.address == address;
  }

  @override
  int get hashCode {
    return key.hashCode ^ address.hashCode;
  }
}

class RootViewArguments {
  const RootViewArguments({
    this.key,
    this.index = 0,
  });

  final _i37.Key? key;

  final int index;

  @override
  String toString() {
    return '{"key": "$key", "index": "$index"}';
  }

  @override
  bool operator ==(covariant RootViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.index == index;
  }

  @override
  int get hashCode {
    return key.hashCode ^ index.hashCode;
  }
}

class EmailVerificationViewArguments {
  const EmailVerificationViewArguments({
    this.key,
    required this.email,
    this.isRoutedFromForgotView = false,
  });

  final _i37.Key? key;

  final String email;

  final bool isRoutedFromForgotView;

  @override
  String toString() {
    return '{"key": "$key", "email": "$email", "isRoutedFromForgotView": "$isRoutedFromForgotView"}';
  }

  @override
  bool operator ==(covariant EmailVerificationViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.email == email &&
        other.isRoutedFromForgotView == isRoutedFromForgotView;
  }

  @override
  int get hashCode {
    return key.hashCode ^ email.hashCode ^ isRoutedFromForgotView.hashCode;
  }
}

class RestaurantDetailViewArguments {
  const RestaurantDetailViewArguments({
    this.key,
    required this.restaurantId,
    required this.restaurant,
    this.foodId,
  });

  final _i37.Key? key;

  final int restaurantId;

  final _i39.Restaurant restaurant;

  final int? foodId;

  @override
  String toString() {
    return '{"key": "$key", "restaurantId": "$restaurantId", "restaurant": "$restaurant", "foodId": "$foodId"}';
  }

  @override
  bool operator ==(covariant RestaurantDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.restaurantId == restaurantId &&
        other.restaurant == restaurant &&
        other.foodId == foodId;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        restaurantId.hashCode ^
        restaurant.hashCode ^
        foodId.hashCode;
  }
}

class ProductDescriptionViewArguments {
  const ProductDescriptionViewArguments({
    this.key,
    required this.restaurantId,
    this.foodId = 0,
    this.isNavigatedFromBanner = false,
  });

  final _i37.Key? key;

  final int restaurantId;

  final int foodId;

  final bool isNavigatedFromBanner;

  @override
  String toString() {
    return '{"key": "$key", "restaurantId": "$restaurantId", "foodId": "$foodId", "isNavigatedFromBanner": "$isNavigatedFromBanner"}';
  }

  @override
  bool operator ==(covariant ProductDescriptionViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.restaurantId == restaurantId &&
        other.foodId == foodId &&
        other.isNavigatedFromBanner == isNavigatedFromBanner;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        restaurantId.hashCode ^
        foodId.hashCode ^
        isNavigatedFromBanner.hashCode;
  }
}

class RestaurantInfoViewArguments {
  const RestaurantInfoViewArguments({
    this.key,
    required this.restaurant,
    this.chargePerKm = 0.0,
    this.customerCharge = 0.0,
    this.customerRadius = 0.0,
  });

  final _i37.Key? key;

  final _i39.Restaurant restaurant;

  final double? chargePerKm;

  final double? customerCharge;

  final double? customerRadius;

  @override
  String toString() {
    return '{"key": "$key", "restaurant": "$restaurant", "chargePerKm": "$chargePerKm", "customerCharge": "$customerCharge", "customerRadius": "$customerRadius"}';
  }

  @override
  bool operator ==(covariant RestaurantInfoViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.restaurant == restaurant &&
        other.chargePerKm == chargePerKm &&
        other.customerCharge == customerCharge &&
        other.customerRadius == customerRadius;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        restaurant.hashCode ^
        chargePerKm.hashCode ^
        customerCharge.hashCode ^
        customerRadius.hashCode;
  }
}

class CategroryRestViewArguments {
  const CategroryRestViewArguments({
    this.key,
    required this.catId,
    required this.catName,
    this.isGrocery = false,
  });

  final _i37.Key? key;

  final int catId;

  final String catName;

  final bool isGrocery;

  @override
  String toString() {
    return '{"key": "$key", "catId": "$catId", "catName": "$catName", "isGrocery": "$isGrocery"}';
  }

  @override
  bool operator ==(covariant CategroryRestViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.catId == catId &&
        other.catName == catName &&
        other.isGrocery == isGrocery;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        catId.hashCode ^
        catName.hashCode ^
        isGrocery.hashCode;
  }
}

class CheckoutViewArguments {
  const CheckoutViewArguments({
    this.key,
    required this.cartProducts,
    required this.note,
    required this.restaurantId,
    required this.cart,
    required this.scheduledDate,
    required this.restaurantAvailableSlots,
  });

  final _i37.Key? key;

  final List<_i40.CartProducts> cartProducts;

  final String note;

  final int restaurantId;

  final _i40.Cart cart;

  final _i40.Slots scheduledDate;

  final List<_i40.RestaurantAvailableSlots> restaurantAvailableSlots;

  @override
  String toString() {
    return '{"key": "$key", "cartProducts": "$cartProducts", "note": "$note", "restaurantId": "$restaurantId", "cart": "$cart", "scheduledDate": "$scheduledDate", "restaurantAvailableSlots": "$restaurantAvailableSlots"}';
  }

  @override
  bool operator ==(covariant CheckoutViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.cartProducts == cartProducts &&
        other.note == note &&
        other.restaurantId == restaurantId &&
        other.cart == cart &&
        other.scheduledDate == scheduledDate &&
        other.restaurantAvailableSlots == restaurantAvailableSlots;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        cartProducts.hashCode ^
        note.hashCode ^
        restaurantId.hashCode ^
        cart.hashCode ^
        scheduledDate.hashCode ^
        restaurantAvailableSlots.hashCode;
  }
}

class OrderDetailViewArguments {
  const OrderDetailViewArguments({
    this.key,
    required this.orderId,
  });

  final _i37.Key? key;

  final int orderId;

  @override
  String toString() {
    return '{"key": "$key", "orderId": "$orderId"}';
  }

  @override
  bool operator ==(covariant OrderDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.orderId == orderId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ orderId.hashCode;
  }
}

class DealsViewArguments {
  const DealsViewArguments({
    this.key,
    this.showBackButton = false,
  });

  final _i37.Key? key;

  final bool showBackButton;

  @override
  String toString() {
    return '{"key": "$key", "showBackButton": "$showBackButton"}';
  }

  @override
  bool operator ==(covariant DealsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.showBackButton == showBackButton;
  }

  @override
  int get hashCode {
    return key.hashCode ^ showBackButton.hashCode;
  }
}

class OrderConfirmedViewArguments {
  const OrderConfirmedViewArguments({
    this.key,
    required this.cart,
  });

  final _i37.Key? key;

  final _i40.Cart cart;

  @override
  String toString() {
    return '{"key": "$key", "cart": "$cart"}';
  }

  @override
  bool operator ==(covariant OrderConfirmedViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.cart == cart;
  }

  @override
  int get hashCode {
    return key.hashCode ^ cart.hashCode;
  }
}

class ShowfilerdataViewArguments {
  const ShowfilerdataViewArguments({
    this.key,
    required this.response,
  });

  final _i37.Key? key;

  final _i39.RestaurantsResponse response;

  @override
  String toString() {
    return '{"key": "$key", "response": "$response"}';
  }

  @override
  bool operator ==(covariant ShowfilerdataViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.response == response;
  }

  @override
  int get hashCode {
    return key.hashCode ^ response.hashCode;
  }
}

extension NavigatorStateExtension on _i41.NavigationService {
  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToWalkthroughView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.walkthroughView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToWelcomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.welcomeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSignUpView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.signUpView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForgotPasswordView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.forgotPasswordView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewPasswordView({
    _i37.Key? key,
    required String email,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newPasswordView,
        arguments: NewPasswordViewArguments(key: key, email: email),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEnableLocationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.enableLocationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLocationView({
    _i37.Key? key,
    _i38.LocationAddress? address,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.locationView,
        arguments: LocationViewArguments(key: key, address: address),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRootView({
    _i37.Key? key,
    int index = 0,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.rootView,
        arguments: RootViewArguments(key: key, index: index),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAccountView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.accountView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEmailVerificationView({
    _i37.Key? key,
    required String email,
    bool isRoutedFromForgotView = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.emailVerificationView,
        arguments: EmailVerificationViewArguments(
            key: key,
            email: email,
            isRoutedFromForgotView: isRoutedFromForgotView),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRestaurantDetailView({
    _i37.Key? key,
    required int restaurantId,
    required _i39.Restaurant restaurant,
    int? foodId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.restaurantDetailView,
        arguments: RestaurantDetailViewArguments(
            key: key,
            restaurantId: restaurantId,
            restaurant: restaurant,
            foodId: foodId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProductDescriptionView({
    _i37.Key? key,
    required int restaurantId,
    int foodId = 0,
    bool isNavigatedFromBanner = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.productDescriptionView,
        arguments: ProductDescriptionViewArguments(
            key: key,
            restaurantId: restaurantId,
            foodId: foodId,
            isNavigatedFromBanner: isNavigatedFromBanner),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRestaurantInfoView({
    _i37.Key? key,
    required _i39.Restaurant restaurant,
    double? chargePerKm = 0.0,
    double? customerCharge = 0.0,
    double? customerRadius = 0.0,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.restaurantInfoView,
        arguments: RestaurantInfoViewArguments(
            key: key,
            restaurant: restaurant,
            chargePerKm: chargePerKm,
            customerCharge: customerCharge,
            customerRadius: customerRadius),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCartView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.cartView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCategroryRestView({
    _i37.Key? key,
    required int catId,
    required String catName,
    bool isGrocery = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.categroryRestView,
        arguments: CategroryRestViewArguments(
            key: key, catId: catId, catName: catName, isGrocery: isGrocery),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCheckoutView({
    _i37.Key? key,
    required List<_i40.CartProducts> cartProducts,
    required String note,
    required int restaurantId,
    required _i40.Cart cart,
    required _i40.Slots scheduledDate,
    required List<_i40.RestaurantAvailableSlots> restaurantAvailableSlots,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.checkoutView,
        arguments: CheckoutViewArguments(
            key: key,
            cartProducts: cartProducts,
            note: note,
            restaurantId: restaurantId,
            cart: cart,
            scheduledDate: scheduledDate,
            restaurantAvailableSlots: restaurantAvailableSlots),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddToCartView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addToCartView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMyOrdersView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.myOrdersView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderDetailView({
    _i37.Key? key,
    required int orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.orderDetailView,
        arguments: OrderDetailViewArguments(key: key, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToFilterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.filterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDealsView({
    _i37.Key? key,
    bool showBackButton = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.dealsView,
        arguments: DealsViewArguments(key: key, showBackButton: showBackButton),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEditProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.editProfileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToChangePasswordView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.changePasswordView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSupportHelpView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.supportHelpView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSaveAddressesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.saveAddressesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderConfirmedView({
    _i37.Key? key,
    required _i40.Cart cart,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.orderConfirmedView,
        arguments: OrderConfirmedViewArguments(key: key, cart: cart),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToFavoriteView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.favoriteView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSearchView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.searchView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToShowfilerdataView({
    _i37.Key? key,
    required _i39.RestaurantsResponse response,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.showfilerdataView,
        arguments: ShowfilerdataViewArguments(key: key, response: response),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToUpdateScreen([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.updateScreen,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSelectMapLocationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.selectMapLocationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCustomDatePickerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.customDatePickerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithWalkthroughView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.walkthroughView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithWelcomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.welcomeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSignUpView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.signUpView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithForgotPasswordView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.forgotPasswordView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewPasswordView({
    _i37.Key? key,
    required String email,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.newPasswordView,
        arguments: NewPasswordViewArguments(key: key, email: email),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEnableLocationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.enableLocationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLocationView({
    _i37.Key? key,
    _i38.LocationAddress? address,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.locationView,
        arguments: LocationViewArguments(key: key, address: address),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRootView({
    _i37.Key? key,
    int index = 0,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.rootView,
        arguments: RootViewArguments(key: key, index: index),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAccountView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.accountView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEmailVerificationView({
    _i37.Key? key,
    required String email,
    bool isRoutedFromForgotView = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.emailVerificationView,
        arguments: EmailVerificationViewArguments(
            key: key,
            email: email,
            isRoutedFromForgotView: isRoutedFromForgotView),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRestaurantDetailView({
    _i37.Key? key,
    required int restaurantId,
    required _i39.Restaurant restaurant,
    int? foodId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.restaurantDetailView,
        arguments: RestaurantDetailViewArguments(
            key: key,
            restaurantId: restaurantId,
            restaurant: restaurant,
            foodId: foodId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProductDescriptionView({
    _i37.Key? key,
    required int restaurantId,
    int foodId = 0,
    bool isNavigatedFromBanner = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.productDescriptionView,
        arguments: ProductDescriptionViewArguments(
            key: key,
            restaurantId: restaurantId,
            foodId: foodId,
            isNavigatedFromBanner: isNavigatedFromBanner),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRestaurantInfoView({
    _i37.Key? key,
    required _i39.Restaurant restaurant,
    double? chargePerKm = 0.0,
    double? customerCharge = 0.0,
    double? customerRadius = 0.0,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.restaurantInfoView,
        arguments: RestaurantInfoViewArguments(
            key: key,
            restaurant: restaurant,
            chargePerKm: chargePerKm,
            customerCharge: customerCharge,
            customerRadius: customerRadius),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCartView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.cartView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCategroryRestView({
    _i37.Key? key,
    required int catId,
    required String catName,
    bool isGrocery = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.categroryRestView,
        arguments: CategroryRestViewArguments(
            key: key, catId: catId, catName: catName, isGrocery: isGrocery),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCheckoutView({
    _i37.Key? key,
    required List<_i40.CartProducts> cartProducts,
    required String note,
    required int restaurantId,
    required _i40.Cart cart,
    required _i40.Slots scheduledDate,
    required List<_i40.RestaurantAvailableSlots> restaurantAvailableSlots,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.checkoutView,
        arguments: CheckoutViewArguments(
            key: key,
            cartProducts: cartProducts,
            note: note,
            restaurantId: restaurantId,
            cart: cart,
            scheduledDate: scheduledDate,
            restaurantAvailableSlots: restaurantAvailableSlots),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddToCartView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addToCartView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMyOrdersView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.myOrdersView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderDetailView({
    _i37.Key? key,
    required int orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.orderDetailView,
        arguments: OrderDetailViewArguments(key: key, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithFilterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.filterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDealsView({
    _i37.Key? key,
    bool showBackButton = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.dealsView,
        arguments: DealsViewArguments(key: key, showBackButton: showBackButton),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEditProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.editProfileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithChangePasswordView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.changePasswordView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSupportHelpView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.supportHelpView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSaveAddressesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.saveAddressesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderConfirmedView({
    _i37.Key? key,
    required _i40.Cart cart,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.orderConfirmedView,
        arguments: OrderConfirmedViewArguments(key: key, cart: cart),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithFavoriteView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.favoriteView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSearchView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.searchView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithShowfilerdataView({
    _i37.Key? key,
    required _i39.RestaurantsResponse response,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.showfilerdataView,
        arguments: ShowfilerdataViewArguments(key: key, response: response),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithUpdateScreen([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.updateScreen,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSelectMapLocationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.selectMapLocationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCustomDatePickerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.customDatePickerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
