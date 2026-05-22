import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/models/coupon_model.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class DealsViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  final log = getLogger('DealsViewModel');
  List<CouponBody> couponList = [];
  BuildContext context;
  DealsViewModel(this.context) {
    getAllCoupons();
  }
  getAllCoupons() async {
    setBusy(true);
    final addressProvider =
        Provider.of<GlobalLocationViewModel>(context, listen: false);
    log.wtf("Selected Address ID: ${addressProvider.getSelectedAddress?.id}");
    CouponModel res = await _dbService
        .fetchAllCoupons(addressProvider.getSelectedAddress?.id ?? 0);
    if (res.success) {
      //
      couponList = res.body;
    } else {
      //
    }
    setBusy(false);
  }

  // void copyToClipboard(String textToCopy) {
  //   Clipboard.setData(ClipboardData(text: textToCopy));
  //   // You can show a confirmation or perform other actions after copying.
  //   // ScaffoldMessenger.of(context).showSnackBar(
  //   //   SnackBar(
  //   //     content: Text('Text copied to clipboard'),
  //   //   ),
  //   // );
  // }
}
