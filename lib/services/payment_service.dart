// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../app/app.locator.dart';

class PaymentService {
  final log = getLogger("PaymentService");
  Map<String, dynamic>? paymentIntent;
  AuthService authSer = locator<AuthService>();
  String? customerStripeID;

  ///
  ///create Customer.

  Future<void> createCustomer() async {
    log.w("@CreateCustomer");
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/customers'),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'description': 'Customer for saving card details',
        'email': locator<AuthService>().userProfile?.email,
      },
    );

    if (response.statusCode == 200) {
      final customer = json.decode(response.body);
      log.d('Customer ID: ${customer['id']}');
      customerStripeID = customer['id'];
    } else {
      log.d('Failed to create customer: ${response.body}');
    }
  }

  ///
  makePayment(double price, BuildContext context) async {
    try {
      //STEP 1: Create Payment Intent
      paymentIntent = await createPaymentIntent(price, 'GBP');
      await createCustomer();
      log.d("clientSecrets: ${paymentIntent!['client_secret']}");
      log.d("CustomerID: ${customerStripeID}");
      log.d(
          "ephemeral_key: ek_test_YWNjdF8xTldrVm9DNUhKSVhsY0lILHl5T2xTd0QxRVZqQTBRUXhHMTZ5TVBhNEh1RnZVYkg_00nxIG08t6");
      //STEP 2: Initialize Payment Sheet
      // _initiateStripePayment();
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],

                  //Gotten from payment intent
                  // style: ThemeMode.light,

                  returnURL:
                      "https://cityeats.online/api/customer/v1/placeOrder",
                  billingDetails: BillingDetails(
                      name: authSer.userProfile?.name ?? "",
                      phone: authSer.userProfile?.contactNumber,
                      email: authSer.userProfile?.email ?? ""),
                  merchantDisplayName: 'display name',
                  appearance: const PaymentSheetAppearance(
                      colors: PaymentSheetAppearanceColors(
                          primary: kcPrimaryColor))))
          .then((value) {});

      //STEP 3: Display Payment sheet
    } catch (err) {
      throw Exception(err);
    }
    return paymentIntent;
  }

  // _initiateStripePayment() async {
  //   try {

  //     // busyPlacingOrder();
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntent!['client_secret'],
  //         customerEphemeralKeySecret: "pk_test_51L3z6CGkhzuf8C9WNAJwnZjpFQnoOo4NkfyJCpiVkgZkBlS6qzgBDmfZr5bh5HGpnI4TtjfsN3LJeEbIf1t9VAcx00UJdmTvnj",
  //         customerId: customerStripeID,
  //         returnURL: "https://cityeats.online/api/customer/v1/placeOrder",
  //         merchantDisplayName: 'Test User',
  //         billingDetailsCollectionConfiguration:
  //             BillingDetailsCollectionConfiguration(
  //           attachDefaultsToPaymentMethod: true,
  //         ),
  //           appearance: const PaymentSheetAppearance(
  //                     colors: PaymentSheetAppearanceColors(
  //                         primary: kcPrimaryColor))

  //       ),
  //     );
  //  PaymentSheetPaymentOption? paymentOption =
  //       await Stripe.instance.presentPaymentSheet();
  //     // await _placeTheOrder(
  //     //   clientSecret: response.stripePaymentData?.clientSecret,
  //     // );
  //   } catch (e, s) {
  //     log.d("@initiateStripePayment Exceptions : $e");
  //     log.d(s);
  //   }

  //   // log.w('@_initiateStripePayment END isPlacingOrder: $isPlacingOrder');
  // }

  ///
  createPaymentIntent(double amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': (amount * 100).toInt().toString(),
        //  calculateAmount(amount),
        'currency': currency,

        // 'country': "Uk",
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      log.d(" StripeJsonResponse:  ${json.decode(response.body)}");
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  ///
  Future<bool> displayPaymentSheet() async {
    bool isDone = false;

    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        paymentIntent = null;
        // getLogger("").wtf();

        isDone = true;
      }).onError((error, stackTrace) {
        isDone = false;

        throw Exception(error);
      });
    } on StripeException catch (e) {
      log.e(e);
      isDone = false;
    }
    // log.w('PAYMENT OPTION: $paymentOption');
    return isDone;
  }
}
