import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../views/startup/startup_view.dart';

class NoInternetDialogModel extends BaseViewModel {
  final _navService = locator<NavigationService>();

  navigateToStartup() {
    _navService.clearTillFirstAndShowView(const StartupView());
  }
}
