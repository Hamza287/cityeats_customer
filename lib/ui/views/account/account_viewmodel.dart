import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/models/user_profile.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  NavigationService get navigationService => _navigationService;
  final autService = locator<AuthService>();
  late UserProfile userProfile =
      userProfile = autService.userProfile ?? UserProfile.dummyObj();
  UserProfile get user => userProfile;

  final myContext = StackedService.navigatorKey?.currentContext;

  AccountViewModel() {
    getProfile();
  }

  getProfile() async {
    if (autService.userProfile == null) {
      await _authService.doSetup();
      userProfile = autService.userProfile ?? UserProfile.dummyObj();
    } else {
      userProfile = autService.userProfile ?? UserProfile.dummyObj();
    }
    rebuildUi();
  }

  navigateToOrders() {
    _navigationService.navigateToMyOrdersView();
  }

  logout() async {
    setBusy(true);
    await _authService.logout();

    // Clear selected address in GlobalLocationViewModel
    if (myContext != null) {
      try {
        final locationProvider =
            Provider.of<GlobalLocationViewModel>(myContext!, listen: false);
        locationProvider.selectedAddress = null;
        locationProvider.addressList.clear();
      } catch (e) {
        // If context is not available, ignore
      }
    }

    // Navigate to login screen after logout
    _navigationService.clearStackAndShow(Routes.loginView);
    setBusy(false);
  }

  deleteAccount() async {
    setBusy(true);
    await _authService.deleteAccount();
    _navigationService.clearStackAndShow(Routes.loginView);
    setBusy(false);
  }

  Future<void> navigateToEditProfile() async {
    await _navigationService.navigateToEditProfileView();
    setBusy(true);
    await autService.doSetup();
    setBusy(false);
    rebuildUi();
  }

  navigateToCartView() {
    _navigationService.navigateToCartView();
  }

  List<Map<String, dynamic>> list = [
    {"item": "Order History", "icon": Icons.assignment},
    // {"item": "Save Card", "icon": Icons.card_travel_rounded},
    {"item": "Promo & Deals", "icon": Icons.local_offer},
    {"item": "Favorite Restaurants", "icon": Icons.favorite},
    {"item": "Help & Support", "icon": Icons.help_outlined},
    {"item": "Privacy Policy", "icon": Icons.privacy_tip_sharp},
    {"item": "Delete Account", "icon": Icons.delete},
    {"item": "Logout", "icon": Icons.logout},
  ];

  onItemTap(int index) {
    switch (index) {
      case 0:
        _navigationService.navigateToMyOrdersView();

        break;
      case 1:
        _navigationService.navigateToDealsView(showBackButton: true);
        break;
      case 2:
        _navigationService.navigateToFavoriteView();
        break;
      case 3:
        _navigationService.navigateToSupportHelpView();
        break;
      case 4:
        privacyPolicy();
        // privacy policy
        // _navigationService.navigateToSupportHelpView();
        break;
      case 5:
        deleteAccount();
        break;
      case 6:
        logout();
        break;
    }
  }

  privacyPolicy() async {
    if (await canLaunchUrl(
        Uri.parse("https://city-eats.co.uk/privacy-policy"))) {
      await launchUrl(Uri.parse("https://city-eats.co.uk/privacy-policy"));
    } else {
      throw 'Could not launch $url';
    }
  }
}
