// ignore_for_file: use_build_context_synchronously

import 'package:city_customer_app/app/app.dialogs.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/models/auth_models/signup_body.dart';
import 'package:city_customer_app/responses/auth_response.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
class SignUpViewModel extends FormViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _dbService = locator<DatabaseService>();
  late BuildContext context;
  SignUpBody signUpBody = SignUpBody();
  final _dialogService = locator<DialogService>();
  bool isSignUpPressed = false;
  bool passwordHidden = true;
  bool cPasswordHidden = true;

  onSignUpPressed() {
    isSignUpPressed = true;
    rebuildUi();
  }

  SignUpViewModel(this.context);

  togglePassVisibility() {
    passwordHidden = !passwordHidden;
    rebuildUi();
  }

  toggleCPassVisibility() {
    cPasswordHidden = !cPasswordHidden;
    rebuildUi();
  }

  navigateToLogin() {
    _navigationService.replaceWithLoginView();
  }

  /// Navigate back
  void navigateBack() {
    _navigationService.back();
  }

  _navigateToEmailVerification() {
    _navigationService.replaceWithEmailVerificationView(
      email: signUpBody.email ?? "",
    );
  }

  Future<void> requestSignUp() async {
    setBusy(true);
    AuthResponse response =
        await _authService.signUpWithEmailAndPassword(signUpBody);

    if (response.success) {

      _navigateToEmailVerification();
      showSnackBar(context,
          message:
              " ${response.authResponseModel?.user?.name ?? ""} Your Account is Created Successfully!");
    } else {
      // Show dialogs when design is ready.
      showDialog(response);
    }
    setBusy(false);
  }

  generateOTP() async {
    final email = signUpBody.email ?? "";
    final response = await _dbService.generateOTP(email);
    if (response['success'] ?? false) {
      // OTP sent successfully
      showSnackBar(context,
          message:
              "OTP has been sent to your registered email ($email).");
    } else {
      // Handle error silently or show dialog if needed
      _dialogService.showCustomDialog(
        variant: DialogType.error,
        title: 'Error',
        description: response['error'] ?? 'Failed to send OTP. Please try again or contact support.',
      );
    }
  }

  showDialog(AuthResponse response) {
    _dialogService.showCustomDialog(
      variant: DialogType.error,
      title: 'Error',
      description: response.error,
    );
  }
}
