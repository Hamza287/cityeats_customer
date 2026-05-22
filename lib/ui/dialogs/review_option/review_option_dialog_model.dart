// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:city_customer_app/app/app.dialogs.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ReviewOptionDialogModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final log = getLogger("MyOrdersViewModel");

  showRiderReviewDialog(
    int orderId,
    int restaurantId,
    int riderId,
    // bool isRiderReview, bool isRestReview
  ) async {
    await _dialogService.showCustomDialog(
      variant: DialogType.riderReview,
      title: "",
      description: "",
      data: {
        "restaurant_id": restaurantId,
        "order_id": orderId,
        "rider_id": riderId,
      },
    );
  }

  showRestReviewDialog(int orderId, int restaurantId) async {
    await _dialogService.showCustomDialog(
      variant: DialogType.restReview,
      title: "",
      description: "",
      data: {
        "restaurant_id": restaurantId,
        "order_id": orderId,
      },
    );
  }
}
