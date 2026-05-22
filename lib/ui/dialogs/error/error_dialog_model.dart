import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ErrorDialogModel extends BaseViewModel {
  final _navService = locator<NavigationService>();

  navigateToStartup() {
    _navService.clearTillFirstAndShowView(const StartupView());
  }
}
