// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:convert';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/services/local_storage_service.dart';
import 'package:city_customer_app/ui/views/checkout/checkout_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/models/order_model.dart';
import 'package:stacked/stacked.dart';
import 'package:city_customer_app/services/database_service.dart';

class CreateOrderViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  final log = getLogger("CreateOrderViewModel");
  final _localStorage = locator<LocalStorageService>();

  ///
  ///
  String transactionId = '';
  String paymentIntentId = '';
  Map<String, dynamic>? transactionData;
  Map<String, dynamic>? paymentIntent;
  Map<dynamic, dynamic>? paypalTransactionInfo = {};
  Order? orderObj;

  createOrder(Order orderObj, Map<String, dynamic>? paymentIntent,
      {Map<dynamic, dynamic>? paypalTransactionInfo}) async {
    this.orderObj = orderObj;

    ///paypal
    if (orderObj.paymentMethod == PaymentMethod.paypal.name) {
      this.paypalTransactionInfo = paypalTransactionInfo;
      orderObj.transactionId = paypalTransactionInfo?['data']['id'];
      orderObj.paymentStatus = "paid";
      setPendingOrder(orderObj);
    }

    ///stripe
    else if (orderObj.paymentMethod == PaymentMethod.stripe.name) {
      this.paymentIntent = paymentIntent;
      transactionId = paymentIntent?['id'];
      orderObj.transactionId = transactionId;
      orderObj.paymentStatus = "paid";
      setPendingOrder(orderObj);
      transactionData =
          await retrieveTxnId(paymentIntent: paymentIntent?['id']);

      //save transaction id locally
      saveTransactionLocally();
      saveTransactionIdLocally(transactionId);
      orderObj.transactionId = transactionId;
      orderObj.paymentStatus = "paid";
      setPendingOrder(orderObj);
    }

    // cash
    else {
      this.paymentIntent = paymentIntent;
      transactionId = paymentIntent?['id'] ?? 'null';
      orderObj.transactionId = transactionId;
    }

    orderObj.paymentStatus = "paid";

    setPendingOrder(orderObj);

    log.wtf(("create An Order"));

    final res = await _dbService.createOrder(orderObj);
    if (res['success'] ?? false) {
      removeTransactionIdFromLocal();
      removeTransactionDataFromLocal();
      removePaymentDataFromLocal();
      removePaymentIdFromLocal();
      _localStorage.clearOrderData();
    } else if (res['error'].toString().contains("not taking")) {}
  }

  Future<Map<String, dynamic>?> retrieveTxnId(
      {required String paymentIntent}) async {
    log.wtf(paymentIntent);
    try {
      http.Response response = await http.get(
          Uri.parse(
              'https://api.stripe.com/v1/charges?payment_intent=$paymentIntent'),
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
            "Content-Type": "application/x-www-form-urlencoded"
          });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log.wtf(data);
        transactionData = data['data'][0];
        transactionId = data['data'][0]['balance_transaction'];
        log.wtf("Transaction Id ${data['data'][0]['balance_transaction']}");

        return transactionData;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  void savePayPalTransactionData() {
    _localStorage.setTransaction = "";
    _localStorage.setTransaction = paypalTransactionInfo;
  }

  void saveTransactionLocally() {
    _localStorage.setTransaction = "";
    _localStorage.setTransaction = transactionData;
  }

  saveTransactionIdLocally(String id) {
    _localStorage.setTransactionId = id;
  }

  setPendingOrder(Order orderObj) {
    _localStorage.saveOrderData(
      orderObj.addressId,
      orderObj.cartId,
      orderObj.paymentStatus,
      orderObj.paymentMethod,
      orderObj.orderType,
      orderObj.orderNote,
      orderObj.transactionId,
      orderObj.isScheduled,
      orderObj.scheduleSlotId,
    );
  }

  removeTransactionIdFromLocal() {
    _localStorage.setTransactionId = null;
  }

  removeTransactionDataFromLocal() {
    _localStorage.setTransaction = null;
  }

  removePaymentDataFromLocal() {
    _localStorage.setPaymentIntent = null;
  }

  removePaymentIdFromLocal() {
    _localStorage.setPaymentIntentId = null;
  }
}
