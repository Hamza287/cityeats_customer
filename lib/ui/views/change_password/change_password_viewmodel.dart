import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/ui/views/change_password/change_password_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChangePasswordViewModel extends FormViewModel {
  final _dbService = locator<DatabaseService>();
  final _navigationService = locator<NavigationService>();

  bool isButtonPressed = false;
  bool oldPasswordHidden = true;
  bool newPasswordHidden = true;
  bool cPasswordHidden = true;

  toggleOldPassVisibility() {
    oldPasswordHidden = !oldPasswordHidden;
    rebuildUi();
  }

  buttonPressed() {
    isButtonPressed = true;
    rebuildUi();
  }

  toggleNewPassVisibility() {
    newPasswordHidden = !newPasswordHidden;
    rebuildUi();
  }

  toggleCPassVisibility() {
    cPasswordHidden = !cPasswordHidden;
    rebuildUi();
  }

  Future<void> requestPasswordChange() async {
    setBusy(true);
    final res = await _dbService.changeMyPassword(
        passwordValue ?? "", newPasswordValue ?? "");
    if (res['success']) {
      _routeToLogin();
    } else {}

    setBusy(false);
  }

  _routeToLogin() {
    _navigationService.clearStackAndShow(Routes.loginView);
  }
}
