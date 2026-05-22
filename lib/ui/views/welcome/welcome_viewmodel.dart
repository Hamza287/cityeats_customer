import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class WelcomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  navigateToLogin() {
    _navigationService.replaceWithLoginView();
  }

  navigateToSignUp() {
    _navigationService.replaceWithSignUpView();
  }
}
