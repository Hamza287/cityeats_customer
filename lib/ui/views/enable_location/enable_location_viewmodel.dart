import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EnableLocationViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final log = getLogger("EnableLocationViewModel");

  _navigateToMapView() {
    _navigationService.navigateToLocationView();
  }

  enableLocation() async {
    _navigateToMapView();
  }

  doLater() {
    _navigationService.replaceWithRootView();
    // _navigateToMapView();
  }
}
