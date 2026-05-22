import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RiderReviewDialogModel extends BaseViewModel {
  double rating = 0.0;
  final _dbService = locator<DatabaseService>();
  final _navigationService = locator<NavigationService>();

  final controller = TextEditingController();

  submitReview(context, int orderId, int riderId) async {
    setBusy(true);
    final res = await _dbService.submitReview(
        orderId, riderId, rating, controller.text);
    if (res.success) {
      showSnackBar(context, message: res.data['body']);
      _navigationService.back();
    } else {}
    setBusy(false);
  }
}
