// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:city_customer_app/app/app.dialogs.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/responses/order_response.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/services/date_time_service.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:city_customer_app/ui/views/my_orders/my_orders_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MyOrdersViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dbService = locator<DatabaseService>();
  final _dialogService = locator<DialogService>();
  final dateTimeService = locator<DateTimeService>();
  final log = getLogger("MyOrdersViewModel");

  MyOrdersViewModel() {
    getMyOrders();
  }

  navigateToDetail(int orderId, String resName) {
    _navigationService.navigateToOrderDetailView(orderId: orderId);
  }

  OrderResponse? response;
  List<OrderModel> ordersList = [];

  Future<void> getMyOrders() async {
    setBusy(true);
    final res = await _dbService.fetchMyOrders();

    if (res.success) {
      //
      ordersList = res.body ?? [];
      if (ordersList.isNotEmpty) {
        ordersList.sort((a, b) => b.id!.compareTo(a.id!));
      }
      checkForCancelOption();
    } else {
      //
    }
    setBusy(false);
    rebuildUi();
  }

  void checkForCancelOption() {
    ///
    ordersList.forEach((element) {
      bool diffLessThanTwoMinute = getTimeComparison(element);
      if (diffLessThanTwoMinute) {
        element.canCancel = true;
        rebuildUi();
        Timer.periodic(const Duration(seconds: 1), (timer) {
          if (element.canCancel == true) {
            bool diffLessThanTwoMinute = getTimeComparison(element);
            if (!diffLessThanTwoMinute) {
              element.canCancel = false;
              timer.cancel();
              rebuildUi();
            }
          }
        });
      }
    });
  }

  bool getTimeComparison(OrderModel order) {
    // String? localTime = DateTimeHelper()
    //     .convertTimeToLocal(DateTime.parse(order.createdAt ?? ""));
    // log.wtf("local time======> $localTime");
    bool diffLessThanTwoMinute = DateTimeHelper()
        .differenceLessThanTwoMinutes(DateTime.parse(order.createdAt ?? ""));
    return diffLessThanTwoMinute;
  }

  Future<void> cancelOrder(context, int orderId) async {
    setBusy(true);
    final res = await _dbService.cancelOrder(orderId);
    if (res['success'] ?? false) {
      showSnackBar(context, message: res['body']);
    } else {
      //
    }
    setBusy(false);
  }

  showOrderFeedbackDialog(int orderId, int restaurantId, int riderId,
      bool isRiderReview, bool isRestReview) async {
    await _dialogService.showCustomDialog(
      variant: DialogType.reviewOption,
      title: "",
      description: "",
      data: {
        "restaurant_id": restaurantId,
        "order_id": orderId,
        "rider_id": riderId,
        "is_rider_review": isRiderReview,
        "is_rest_review": isRestReview,
      },
    );
    getMyOrders();
  }
}
