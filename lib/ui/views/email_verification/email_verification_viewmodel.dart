// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:city_customer_app/app/app.dialogs.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/responses/auth_response.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EmailVerificationViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  final userProfile = locator<AuthService>().userProfile;
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _dialogService = locator<DialogService>();
  late Timer timer;
  final String email;
  final bool isRoutedFromForgotView;

  String _otp = '';
  int counter = 59;
  late BuildContext context;

  bool get isOtpComplete => _otp.length == 4;
  bool get isCounterZero => counter == 0;

  EmailVerificationViewModel(
    this.context, {
    required this.email,
    required this.isRoutedFromForgotView,
  }) {
    _startTimer();
  }

  routeToLogin() {
    _authService.logout();
    _navigationService.replaceWithLoginView();
  }

  _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      counter--;
      rebuildUi();
      if (counter == 0) {
        timer.cancel();
      }
    });
  }

  onChangeOTP(value) {
    _otp = value;
    rebuildUi();
  }

  verifyOTP() async {
    setBusy(true);
    
    // Log what we're sending
    print("📧 Email Verification - Email: $email");
    print("🔢 Email Verification - OTP Entered: $_otp (length: ${_otp.length})");
    
    AuthResponse response = await _dbService.verifyOTP(email, _otp);
    
    // Log the response
    print("✅ Email Verification - Response Success: ${response.success}");
    print("❌ Email Verification - Response Error: ${response.error}");
    
    if (response.success) {
      _navigationService.clearStackAndShow(Routes.enableLocationView);
    } else {
      // Extract detailed error message
      String errorMessage = _extractErrorMessage(response);
      
      // Log the extracted error message
      print("📋 Email Verification - Extracted Error Message: $errorMessage");
      
      // Log the full raw response data for debugging
      print("📋 Email Verification - Full Raw Response Data: ${response.rawData}");
      
      // Show error Dialogs.
      _dialogService.showCustomDialog(
        variant: DialogType.error,
        title: 'Error',
        description: errorMessage,
      );
    }
    setBusy(false);
  }

  String _extractErrorMessage(AuthResponse response) {
    try {
      // Get the raw response data
      final rawData = response.rawData;
      
      if (rawData != null) {
        print("🔍 Error Extraction - Raw Data Type: ${rawData.runtimeType}");
        print("🔍 Error Extraction - Raw Data: $rawData");
        
        // rawData is already Map<String, dynamic>? from AuthResponse
          // Check for Laravel validation errors in 'errors' field
          final errors = rawData['errors'];
          if (errors != null) {
            print("🔍 Error Extraction - Found 'errors' field: $errors");
            if (errors is Map && errors.isNotEmpty) {
              // Extract first error message from validation errors
              final firstError = errors.values.first;
              print("🔍 Error Extraction - First Error: $firstError");
              if (firstError is List && firstError.isNotEmpty) {
                final errorMsg = firstError.first.toString();
                print("🔍 Error Extraction - Extracted from List: $errorMsg");
                return errorMsg;
              } else if (firstError is String) {
                print("🔍 Error Extraction - Extracted String: $firstError");
                return firstError;
              }
            }
          }
          
          // Check for detailed error in 'body' field
          final body = rawData['body'];
          if (body != null) {
            print("🔍 Error Extraction - Found 'body' field: $body");
            if (body is Map) {
              final bodyMessage = body['message'];
              if (bodyMessage != null) {
                print("🔍 Error Extraction - Body message: $bodyMessage");
                return bodyMessage.toString();
              }
              // Check if body contains error details
              final bodyErrors = body['errors'];
              if (bodyErrors != null) {
                print("🔍 Error Extraction - Body errors: $bodyErrors");
                if (bodyErrors is Map && bodyErrors.isNotEmpty) {
                  final firstError = bodyErrors.values.first;
                  if (firstError is List && firstError.isNotEmpty) {
                    final errorMsg = firstError.first.toString();
                    print("🔍 Error Extraction - Extracted from body.errors: $errorMsg");
                    return errorMsg;
                  } else if (firstError is String) {
                    print("🔍 Error Extraction - Extracted body error string: $firstError");
                    return firstError;
                  }
                }
              }
            }
          }
          
          // Check for 'message' field (common in Laravel validation)
          final message = rawData['message'];
          if (message != null) {
            print("🔍 Error Extraction - Found 'message' field: $message");
            return message.toString();
          }
          
          // Check all keys in the response for debugging
          print("🔍 Error Extraction - All keys in rawData: ${rawData.keys.toList()}");
        }
    } catch (e) {
      // If accessing rawData fails, continue to fallback
      print("⚠️ Error Extraction - Exception: $e");
    }
    
    // Fallback to the error field or a default message
    final error = response.error;
    print("🔍 Error Extraction - Using fallback error: $error");
    if (error != null && error.isNotEmpty && error != 'Validation Error.') {
      return error;
    }
    
    return 'Invalid OTP. Please check the code and try again. If the problem persists, please contact support.';
  }

  generateOTP() async {
    setBusy(true);
    final response = await _dbService.generateOTP(email);
    if (response['success'] ?? false) {
      showSnackBar(context, 
          message: "OTP has been sent to your registered email ($email).");
      _resetTimer();
      // Handle this case..
    } else {
      
      _dialogService.showCustomDialog(
        variant: DialogType.error,
        title: 'Error',
        description: response['error'] ?? 'Failed to send OTP. Please try again or contact support.',
      );
    }
    setBusy(false);
  }

  _resetTimer() {
    counter = 59;
    _startTimer();
    rebuildUi();
  }

  @override
  void dispose() {
    if (timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }
}
