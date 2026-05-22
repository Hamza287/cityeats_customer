// ignore_for_file: use_build_context_synchronously

import 'package:city_customer_app/app/app.dialogs.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/models/auth_models/login_body.dart';
import 'package:city_customer_app/responses/auth_response.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:city_customer_app/ui/views/cart/cart_viewmodel.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends FormViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  LoginBody loginObj = LoginBody();
  bool isLoginPressed = false;
  late BuildContext context;
  final _dialogService = locator<DialogService>();
  final _dbService = locator<DatabaseService>();
  final log = getLogger("LoginViewModel");
  bool passwordHidden = true;

  onLoginPressed() {
    log.d("isLoggedInpressed: $isLoginPressed");
    isLoginPressed = true;
    log.d("isLoggedInpressed: $isLoginPressed");
    rebuildUi();
  }

  LoginViewModel(this.context);

  /// Clear login form fields
  void clearForm() {
    loginObj = LoginBody();
    isLoginPressed = false;
    passwordHidden = true;
    // Clear form data
    setData({});
    rebuildUi();
  }

  navigateToSignUp() {
    _navigationService.navigateToSignUpView();
  }

  navigateToForgot() {
    _navigationService.navigateToForgotPasswordView();
  }

  /// Navigate to Guest Mode (RootView)
  navigateToGuestMode() {
    _navigationService.clearStackAndShow(Routes.rootView);
  }

  togglePassVisibility() {
    passwordHidden = !passwordHidden;
    rebuildUi();
  }

  chooseRoute() {
    if (_authService.userProfile?.verified == 0) {
      _navigationService.navigateToEmailVerificationView(
          email: _authService.userProfile?.email ?? "");
      generateOTP();
    } else {
      _navigationService.clearStackAndShow(Routes.rootView);
    }
  }

  Future<void> subscribeToCustomerTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic("customer");
  }

  ///login (email and password)
  loginWithEmailAndPassword() async {
    setBusy(true);
    try {
      AuthResponse response =
          await _authService.loginWithEmailAndPassword(loginObj);
      if (response.success) {
        // Fetch addresses and cart after successful login
        try {
          final locationProvider =
              Provider.of<GlobalLocationViewModel>(context, listen: false);
          await locationProvider.getAddresses();

          // Refresh cart so existing items show up immediately
          final cartProvider =
              Provider.of<CartViewModel>(context, listen: false);
          cartProvider.getMyCart(isRefresh: true);
        } catch (e) {
          // If context is not available, ignore
          log.e('Failed to fetch data after login: $e');
        }

        chooseRoute();
        subscribeToCustomerTopic();
        showSnackBar(context,
            message:
                "Welcome Back! ${response.authResponseModel?.user?.name ?? ""}");
      } else {
        // Log the error for debugging
        log.e('Login failed - Error: ${response.error}');
        showDialog(response);
      }
    } catch (e, stackTrace) {
      log.e('Login exception: $e\n$stackTrace');
      // Show error dialog for exceptions too
      _dialogService.showCustomDialog(
        variant: DialogType.error,
        title: 'Error',
        description: 'An unexpected error occurred. Please try again.',
      );
    }
    setBusy(false);
  }

  generateOTP() async {
    final email = loginObj.email ?? "";
    final response = await _dbService.generateOTP(email);
    if (response['success']) {
      showSnackBar(context,
          message: "OTP has been sent to your registered email ($email).");
      // Handle this case..
    } else {
      // Handle this case..
      // Show error Dialogs.
      _dialogService.showCustomDialog(
        variant: DialogType.error,
        title: 'Error',
        description: response['error'] ??
            'Failed to send OTP. Please try again or contact support.',
      );
    }
  }

  showDialog(AuthResponse response) {
    // Ensure we always show a meaningful error message
    final errorMessage = response.error?.isNotEmpty == true
        ? response.error!
        : 'An error occurred. Please try again.';

    _dialogService.showCustomDialog(
      variant: DialogType.error,
      title: 'Error',
      description: errorMessage,
    );
  }
}
