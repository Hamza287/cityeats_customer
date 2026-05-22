import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/services/local_storage_service.dart';
import 'package:city_customer_app/ui/views/walkthrough/walkthrough_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../constants/asesets.dart';
import 'package:city_customer_app/app/app.locator.dart';

class WalkthroughViewModel extends BaseViewModel {
  PageController pageController = PageController();
  int currentPage = 0;

  final _navigationService = locator<NavigationService>();
  final _localStorage = locator<LocalStorageService>();

  List<Widget> walkthroughScreens = const [
    WalkthroughScreen(
      image: "$kcWalkThroughPath/walk1.png",
      title: 'Explore Restaurant',
      description:
          'Savor the flavor, with each delivery call, Feast on delights, from near or far, your cravings enthrall.',
    ),
    WalkthroughScreen(
      image: "$kcWalkThroughPath/walk2.png",
      title: 'Place your order',
      description:
          'Embark on a culinary adventure, Discover diverse flavors from every corner, Explore a world of dining options at your fingertips.',
    ),
    WalkthroughScreen(
      image: "$kcWalkThroughPath/walk3.png",
      title: 'Collect your delivery',
      description:
          'Indulge in convenience with a simple tap, Choose from a plethora of culinary delights, Satisfy your cravings with just a few clicks.',
    ),
  ];

  togglePage(int page) {
    currentPage = page;
    rebuildUi();
  }

  navigateToWelcome() {
    // _navigationService.replaceWithWelcomeView();
    _navigationService.replaceWithRootView();
  }

  saveOnBoarding() {
    _localStorage.setOnBoarded = true;
  }

  saveFirsTimeDataInLocalDatabase() {}
}
