// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:city_customer_app/app/app.dialogs.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:city_customer_app/ui/views/new_password/new_password_view.form.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NewPasswordViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final log = getLogger("NewPasswordViewModel");

  String otp = '';
  bool isForgotPressed = false;

  final _dbService = locator<DatabaseService>();

  late BuildContext context;
  final _dialogService = locator<DialogService>();
  String email = '';
  String newPass = '';
  String cNewPass = '';

  bool passwordHidden = true;
  bool cPasswordHidden = true;
  NewPasswordViewModel(this.context, this.email);

  togglePassVisibility() {
    passwordHidden = !passwordHidden;
    rebuildUi();
  }

  toggleCPassVisibility() {
    cPasswordHidden = !cPasswordHidden;
    rebuildUi();
  }

  _navigateToLogin() {
    navigationService.replaceWithLoginView();
  }

  ///login (email and password)
  Future<void> requestNewPassword() async {
    log.wtf(newPassValue);
    setBusy(true);
    try {
      final response =
          await _dbService.resetPassword(otp, email, newPass.trim());
      if (response.success) {
        showSnackBar(context, message: "Password reset successfully!");
        _navigateToLogin();
      } else {
        showDialog(response.error ?? "");
      }
    } catch (e) {
      log.e(e);
    }
    setBusy(false);
  }

  onChangeOTP(value) {
    otp = value;
    rebuildUi();
  }

  showDialog(String error) {
    _dialogService.showCustomDialog(
      variant: DialogType.error,
      title: 'Error',
      description: error,
    );
  }
}
