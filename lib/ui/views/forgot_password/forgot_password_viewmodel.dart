// ignore_for_file: use_build_context_synchronously

import 'package:city_customer_app/app/app.dialogs.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
class ForgotPasswordViewModel extends FormViewModel {
  final _navigationService = locator<NavigationService>();
  String email = '';
  bool isForgotPressed = false;

  final _dbService = locator<DatabaseService>();
  bool isLoginPressed = false;
  late BuildContext context;
  final _dialogService = locator<DialogService>();

  onForgotPressed() {
    isForgotPressed = true;
    rebuildUi();
  }

  ForgotPasswordViewModel(this.context);

  _navigateToNewPassword(String addedEmail) {
    _navigationService.navigateToNewPasswordView(email: addedEmail);
  }

  back() {
    _navigationService.back();
  }

  ///login (email and password)
  Future<bool> requestForgotPassword() async {
    setBusy(true);
    final response = await _dbService.forgotPassword(email);

    if (response.success) {
      // email = ;
      showSnackBar(context,
          message:
              "We have sent you an OTP to your registered email ($email).");
      _navigateToNewPassword(email);
      setBusy(false);
      return true;
    } else {
      showDialog(response.error ?? "");
      email = '';
      setBusy(false);
      return false;
    }
  }

  showDialog(error) {
    _dialogService.showCustomDialog(
      variant: DialogType.error,
      title: 'Error',
      description: error,
    );
  }
}
