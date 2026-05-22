import 'package:city_customer_app/app/app.dialogs.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';
import 'package:city_customer_app/responses/specific_order_response.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/services/date_time_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailViewModel extends BaseViewModel {
  final int orderId;
  final _dialogService = locator<DialogService>();
  final dateTimeService = locator<DateTimeService>();
  final log = getLogger("OrderDetailViewModel");
  OrderDetailViewModel(this.orderId) {
    getSpecificOrder();
  }
  final _dbService = locator<DatabaseService>();
  SpecificOrderResponse? res;
  bool isLoaded = false;

  getSpecificOrder() async {
    setBusy(true);
    res = await _dbService.fetchOrderDetails(orderId);
    log.wtf(res?.body?.orders?.toJson());
    if (res?.success ?? false) {
      isLoaded = true;
    } else {}

    setBusy(false);
  }

  getOrderStatus(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'completed';
      case 'cancel_request':
        return "cancelled";

      default:
        return "pending";
    }
  }

  void navigateToMap(latitude, longitude) async {
    double lat = double.parse("${latitude?.toString() ?? 0.0}");
    double lng = double.parse("${longitude?.toString() ?? 0.0}");
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  getProductSubmod(OrderDetail product) {
    List<SubModifiers> cartSubModifiers = [];
    for (int i = 0; i < product.modifiers!.length; i++) {
      for (int j = 0; j < product.modifiers![i].subModifiers!.length; j++) {
        cartSubModifiers.add(product.modifiers![i].subModifiers![j]);
      }
    }
    log.wtf("cartSubMmodifers:${cartSubModifiers.length}");
    return cartSubModifiers;
  }

  toggleShowMore(int index) {
    int length = res?.body?.orders?.orderDetail!.length ?? 0;
    log.w('@toggleShowMore');

    if (res?.body?.orders?.orderDetail != null) {
      for (int i = 0; i < length; i++) {
        if (i == index) {
          res?.body?.orders?.orderDetail![index].showMore =
              !res!.body!.orders!.orderDetail![index].showMore;
        } else {
          res!.body!.orders!.orderDetail![i].showMore = false;
        }
      }
    }

    rebuildUi();
  }

  getPrice(int index) {
    double price = res?.body?.orders?.orderDetail?[index].price! ?? 0;
    int count = res?.body?.orders?.orderDetail![index].quantity! ?? 1;
    return price / count;
  }

  showRiderReviewDialog(int orderId, int restaurantId, int riderId) async {
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
    getSpecificOrder();
  }

  showRestReviewDialog(int orderId, int restaurantId, int riderId) async {
    await _dialogService.showCustomDialog(
      variant: DialogType.restReview,
      title: "",
      description: "",
      data: {
        "restaurant_id": restaurantId,
        "order_id": orderId,
        "rider_id": riderId,
      },
    );
    getSpecificOrder();
  }
}
