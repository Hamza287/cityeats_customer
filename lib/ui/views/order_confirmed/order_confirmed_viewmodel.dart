import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OrderConfirmedViewModel extends BaseViewModel {
  final _navService = locator<NavigationService>();

  ///
  navigateToOrderView() {
    // _navService.back();
    _navService.replaceWithMyOrdersView();
  }
}
