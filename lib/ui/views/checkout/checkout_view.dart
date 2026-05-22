import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/responses/addresses_response.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/custom_widgets/coupin_tile.dart';
import 'package:city_customer_app/ui/custom_widgets/submodifiers_list.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../../../responses/cart_response.dart';
import 'checkout_viewmodel.dart';

class CheckoutView extends StackedView<CheckoutViewModel> {
  const CheckoutView({
    super.key,
    required this.cartProducts,
    required this.note,
    required this.restaurantId,
    required this.cart,
    required this.scheduledDate,
    required this.restaurantAvailableSlots,
  });
  final List<CartProducts> cartProducts;
  final Cart cart;
  final String note;
  final int restaurantId;
  final Slots scheduledDate;

  final List<RestaurantAvailableSlots> restaurantAvailableSlots;
  @override
  Widget builder(
      BuildContext context, CheckoutViewModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: kcWhiteColor,
          title: Text(
            "Checkout",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        backgroundColor: kcLightGreyColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///address
                      if (viewModel.dMood == DeliveryMood.delivery)
                        _address(context, viewModel),
                      12.verticalSpace,
                      //delivery

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text("Delivery Mode",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 16.sp, wordSpacing: 4)),
                      ),
                      12.verticalSpace,
                      GestureDetector(
                        onTap: () {
                          viewModel.toggleMood(DeliveryMood.delivery);
                        },
                        child: _deliveryOption(
                            context,
                            Icons.delivery_dining,
                            "Standard Delivery",
                            DeliveryMood.delivery,
                            viewModel.dMood),
                      ),
                      18.verticalSpace,
                      GestureDetector(
                        onTap: () {
                          viewModel.toggleMood(DeliveryMood.takeAway);
                        },
                        child: _deliveryOption(
                            context,
                            Icons.flight_takeoff_outlined,
                            "Collection",
                            DeliveryMood.takeAway,
                            viewModel.dMood),
                      ),
                      10.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text("Payment Method",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 16.sp, wordSpacing: 4)),
                      ),
                      10.verticalSpace,
                      const PaymentMethodSelection(),
                      10.verticalSpace,
                      _voucher(context, viewModel),
                      12.verticalSpace,
                      _paymentSummary(context, viewModel),
                      10.verticalSpace,
                      verticalSpaceSmall,
                      if (!viewModel
                          .areAllSlotsEmpty(restaurantAvailableSlots)) ...[
                        Container(
                          height: 128.h,
                          color: kcWhiteColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              20.verticalSpace,
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.h),
                                child: Text(" Order Schedule for:",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        )),
                              ),
                              verticalSpaceSmall,
                              _scheduleOrderField(context, viewModel),
                              verticalSpaceSmall,
                            ],
                          ),
                        ),
                      ],
                      20.verticalSpace,
                    ],
                  ),
                ),
              ),
              // Fixed button at bottom with SafeArea padding
              _paymentButton(context, viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentButton(context, CheckoutViewModel viewModel) {
    // final address = viewModel.routeToSaveAddress();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: kcLightGreyColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: CustomElevatedButton(
            text: "Proceed to Payment",
            onPressed: !viewModel.isAddressNotSelected()
                ? () {
                    (viewModel.cart.restaurant?.isBusy ?? false)
                        ? showSnackBar(context,
                            message: "Can't accept orders right now")
                        : viewModel.proceedToPayment();
                  }
                : () {
                    showSnackBar(context,
                        message: " Please select delivery address");
                  }),
      ),
    );
  }

  _scheduleOrderField(BuildContext context, CheckoutViewModel viewModel) {
    return InkWell(
        onTap: () {
          viewModel.openScheduleSheet();
        },
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            width: 1.sw,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 4.w),
                Container(
                  width: 1.sw - 60.w,
                  decoration: BoxDecoration(
                    color: Color(0xFFECF1F6),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0.h,
                      horizontal: 10.w,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          viewModel.chosenDate != null &&
                                  viewModel.chosenSlot != null
                              ? '${viewModel.getDayOfWeek(viewModel.chosenDate! ?? DateTime.now())}, '
                                  '${viewModel.dateTimeService.convertIntoAmPmDate(viewModel.chosenSlot?.startTime ?? " ")} - ${viewModel.dateTimeService.convertIntoAmPmDate(viewModel.chosenSlot?.endTime ?? " ")}'
                              : 'Now',
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w600),
                          overflow:
                              TextOverflow.ellipsis, // 🔥 Prevent overflow
                          maxLines: 1,
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: kcPrimaryColor,
                          size: 26.h,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )

            //
            ));
  }

  String _getDisplayAddress(
      GlobalLocationViewModel locationModel, CheckoutViewModel viewModel) {
    // If loading/busy state, show Loading...
    if (locationModel.isBusy || !locationModel.addressesLoaded) {
      return "Loading...";
    }

    // First check if there's a selected address in GlobalLocationViewModel
    if (locationModel.getSelectedAddress != null) {
      final displayAddress = locationModel
          .getDisplayAddressString(locationModel.getSelectedAddress);
      if (displayAddress != null && displayAddress.isNotEmpty) {
        return displayAddress;
      }
    }

    // Check localStorage address (could be LocationAddress object or string)
    final localStorageAddress = viewModel.localStorageService.address;
    if (localStorageAddress != null) {
      if (localStorageAddress is LocationAddress) {
        final address = localStorageAddress.address;
        if (address != null && address.isNotEmpty) {
          return address;
        }
      } else if (localStorageAddress is String &&
          localStorageAddress.isNotEmpty) {
        return localStorageAddress;
      }
    }

    // If no selected address, check if user has saved addresses in the list
    if (locationModel.addressList.isNotEmpty) {
      // Find the first address with a valid display string
      for (var address in locationModel.addressList) {
        final displayAddress = locationModel.getDisplayAddressString(address);
        if (displayAddress != null && displayAddress.isNotEmpty) {
          return displayAddress;
        }
      }
    }

    // If no selected address, check if user is logged in and has saved addresses
    final authService = locator<AuthService>();
    if (authService.checkLogin() &&
        authService.userProfile?.address != null &&
        authService.userProfile!.address!.isNotEmpty) {
      final profileAddress = authService.userProfile!.address!.first.address;
      if (profileAddress != null && profileAddress.isNotEmpty) {
        return profileAddress;
      }
    }

    // If addresses are loaded but empty/no valid address found
    if (locationModel.addressesLoaded) {
      return "No address";
    }

    // Fallback to "Loading..."
    return "Loading...";
  }

  bool _hasAddress(
      GlobalLocationViewModel locationModel, CheckoutViewModel viewModel) {
    // If still loading, return false (don't show as having address yet)
    if (locationModel.isBusy || !locationModel.addressesLoaded) {
      return false;
    }

    // Check if there's a selected address in GlobalLocationViewModel
    if (locationModel.getSelectedAddress != null) {
      final displayAddress = locationModel
          .getDisplayAddressString(locationModel.getSelectedAddress);
      if (displayAddress != null && displayAddress.isNotEmpty) {
        return true;
      }
    }

    // Check localStorage address
    final localStorageAddress = viewModel.localStorageService.address;
    if (localStorageAddress != null) {
      if (localStorageAddress is LocationAddress) {
        return localStorageAddress.address != null &&
            localStorageAddress.address!.isNotEmpty;
      } else if (localStorageAddress is String) {
        return localStorageAddress.isNotEmpty;
      }
    }

    // Check if user has saved addresses in the list
    if (locationModel.addressList.isNotEmpty) {
      for (var address in locationModel.addressList) {
        final displayAddress = locationModel.getDisplayAddressString(address);
        if (displayAddress != null && displayAddress.isNotEmpty) {
          return true;
        }
      }
    }

    // Check if user is logged in and has saved addresses in profile
    final authService = locator<AuthService>();
    if (authService.checkLogin() &&
        authService.userProfile?.address != null &&
        authService.userProfile!.address!.isNotEmpty) {
      return authService.userProfile!.address!.first.address != null &&
          authService.userProfile!.address!.first.address!.isNotEmpty;
    }

    return false;
  }

  _address(BuildContext context, CheckoutViewModel viewModel) {
    return Consumer<GlobalLocationViewModel>(
        builder: (context, locationModel, child) => Container(
              height: 116.h,
              color: kcWhiteColor,
              margin: EdgeInsets.only(top: 25.h),
              padding: EdgeInsets.all(20.h),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery Address",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: 16.sp),
                      ),
                      TextButton(
                        onPressed: () async {
                          LocationAddress? address =
                              await viewModel.routeToSaveAddress();

                          if (address != null) {
                            locationModel.selectedAddress = address;
                            viewModel.localStorageService.addressId =
                                address.id;
                            viewModel.updateLocation(address);
                          }
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            visualDensity: const VisualDensity(vertical: -4)),
                        child: Text(
                          _hasAddress(locationModel, viewModel)
                              ? "Change"
                              : "Add Address",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize: 14.sp, color: kcPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                // .verticalSpace,
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: kcPrimaryColor,
                    ),
                    Flexible(
                      child: Text(
                        _getDisplayAddress(locationModel, viewModel),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              ]),
            ));
  }

  Container _paymentSummary(BuildContext context, CheckoutViewModel viewModel) {
    return Container(
      // height: 128.h,
      width: screenWidth(context),
      color: kcWhiteColor,
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Payment Summary",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        12.verticalSpace,
        ListView.separated(
          itemCount: cartProducts.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => Stack(children: [
            Container(
              width: 500.w,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: _itemsAndPrice(
                    context,
                    cartProducts[index].productName ?? "",
                    viewModel.getProductSubmod(cartProducts[index]),
                    cartProducts[index],
                    viewModel,
                    index),
              ),
            ),
            if (cartProducts[index].discount != 0)
              Positioned(
                right: 0,
                child: Container(
                  height: 25.h,
                  width: 60.w,
                  alignment: Alignment
                      .center, // Wider banner for a better diagonal effect
                  padding: const EdgeInsets.symmetric(
                      vertical: 6), // Padding for better readability
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 237, 198, 3),
                    borderRadius: BorderRadius.circular(4), // Slight rounding
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: const Offset(2, 2), // Slight shadow for depth
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      " £${(cartProducts[index].discount).toStringAsFixed(2)} OFF", // Improved label for clarity
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
          ]),
          separatorBuilder: (BuildContext context, int index) =>
              12.verticalSpace,
        ),
        10.verticalSpace,
        const Divider(color: kcGreyColor),
        10.verticalSpace,
        // Subtotal first (only items price, no fees)
        _otherChargesFee(context, "Subtotal",
            viewModel.itemsSubtotal.toStringAsFixed(2), false),
        8.verticalSpace,
        // Discount row - show only for non-delivery-off coupons (free delivery shows on delivery line instead)
        if (viewModel.discount > 0 && !viewModel.isDeliveryOffCoupon) ...[
          _discountRow(context, viewModel),
          8.verticalSpace,
        ],
        // Delivery Charges with strikethrough if free delivery coupon
        if (viewModel.dMood == DeliveryMood.delivery) ...[
          _deliveryFeeRow(context, viewModel),
          8.verticalSpace,
        ],
        // VAT
        _otherChargesFee(context, "VAT", cart.vat.toString(), false),
        8.verticalSpace,
        // Service Charges
        _otherChargesFee(
            context, "Service Charges", cart.serviceCharges.toString(), false),
        8.verticalSpace,
        // Bag Fee
        _otherChargesFee(context, "Bag Fee", cart.bagFee.toString(), false),
        8.verticalSpace,
        // New User Discounts
        if (cart.newUserDiscount != 0) ...[
          _otherChargesFee(context, "New User Discount",
              cart.newUserDiscount.toString(), true),
          8.verticalSpace,
        ],
        if (cart.newUserDeliveryDiscount != 0) ...[
          _otherChargesFee(context, "Delivery Discount",
              cart.newUserDeliveryDiscount.toString(), true),
          8.verticalSpace,
        ],
        10.verticalSpace,
        const Divider(color: kcGreyColor),
        10.verticalSpace,
        _totalPrice(context, viewModel.totalPrice.toStringAsFixed(2)),
      ]),
    );
  }

  Container discountBannerWidget() {
    return Container(
      height: 25.h,
      width: 100.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Color.fromARGB(255, 247, 181, 15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          " Free Delivery! 🎉  ",
          style: TextStyle(
              color: kPureBlackColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Column _itemsAndPrice(
      BuildContext context,
      String name,
      List<SubModifiers> subModifers,
      CartProducts product,
      CheckoutViewModel viewModel,
      int index) {
    double price = (product.totalPrice!) / product.productCount!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              // "Basket Total",
              name,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              "£${price.toStringAsFixed(2)} x ${product.productCount.toString()}",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14.sp),
            ),
            Text(
              "£${product.totalPrice!.toStringAsFixed(2)}",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            subModifers.isNotEmpty
                ? showMoreButton(viewModel, index, product, context)
                : SizedBox(),
          ],
        ),
        product.showMore
            ? SubModifiersList(subModifers: subModifers)
            : const SizedBox(),
      ],
    );
  }

  GestureDetector showMoreButton(CheckoutViewModel viewModel, int index,
      CartProducts product, BuildContext context) {
    return GestureDetector(
        onTap: () {
          viewModel.toggleShowMore(index);
        },
        child: Wrap(
          children: [
            Text(
              product.showMore ? "View less" : " View more",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: kcPrimaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: kcPrimaryColor,
                  ),
            ),
            Icon(
              product.showMore
                  ? Icons.keyboard_arrow_up_outlined
                  : Icons.keyboard_arrow_down_outlined,
              color: kcPrimaryColor,
              size: 20.sp,
            )
          ],
        )

        //      Container(
        //       width: 120.w,
        //       decoration: BoxDecoration(color: kcPrimaryColor.withOpacity(0.1)),
        //       alignment: Alignment.topLeft,
        //       child: Wrap(
        //         // mainAxisAlignment: MainAxisAlignment.center,
        //         alignment: WrapAlignment.center,

        //         children: [
        //           Text(

        //             style: Theme.of(context).textTheme.bodySmall?.copyWith(
        //                   fontSize: 14.sp,
        //                   fontWeight: FontWeight.w600,
        //                   // decoration: TextDecoration.underline,
        //                   // decorationThickness: 1.2.h
        //                 ),
        //           ),
        //           Icon(
        //             product.showMore
        //                 ? Icons.keyboard_arrow_up_outlined
        //                 : Icons.keyboard_arrow_down_outlined,
        //             color: kcPrimaryColor,
        //             size: 20.sp,
        //           )
        //         ],
        //       ),
        //     ),
        );
  }

  Row _totalPrice(
    BuildContext context,
    String totalPrice,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total Amount",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        Text(
          "£$totalPrice",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Row _otherChargesFee(BuildContext context, String title, String totalPrice,
      bool isDiscountadded) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          5.horizontalSpace,
          if (isDiscountadded)
            Image.asset(
              "$kcStaticImagesPath/new_icon.png",
              height: 16.h,
              width: 16.w,
            ),
        ]),
        Text(
          " £$totalPrice",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  /// Discount row showing coupon name and discount amount
  Row _discountRow(BuildContext context, CheckoutViewModel viewModel) {
    final couponTitle = viewModel.appliedCouponTitle ?? "Discount";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(children: [
          Text(
            couponTitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
          ),
          5.horizontalSpace,
          Image.asset(
            "$kcStaticImagesPath/new_icon.png",
            height: 16.h,
            width: 16.w,
          ),
        ]),
        Text(
          "-£${viewModel.discount.toStringAsFixed(2)}",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
        )
      ],
    );
  }

  /// Delivery fee row with strikethrough when free delivery coupon is applied
  Row _deliveryFeeRow(BuildContext context, CheckoutViewModel viewModel) {
    final deliveryFee = viewModel.cart.deliveryFee ?? 0;
    final isFreeDelivery = viewModel.isDeliveryOffCoupon;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Delivery Charges",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
        Row(
          children: [
            Text(
              "£${deliveryFee.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    decoration:
                        isFreeDelivery ? TextDecoration.lineThrough : null,
                    decorationColor: Colors.red,
                    decorationThickness: 4.w,
                    color: isFreeDelivery ? kcMediumGrey : null,
                  ),
            ),
            if (isFreeDelivery) ...[
              8.horizontalSpace,
              Text(
                "Free",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Container _voucher(BuildContext context, CheckoutViewModel viewModel) {
    return Container(
      height: 128.h,
      color: kcWhiteColor,
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        children: [
          20.verticalSpace,
          Row(
            children: [
              const Icon(Icons.add_business, color: kcBlackColor),
              12.horizontalSpace,
              Text(
                "Voucher",
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          ),
          12.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,

                // height: 48.h, width: 147.w,
                child: CustomTextField(
                    suffix: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            enableDrag: true,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.r)),
                            ),
                            builder: (context) {
                              return Container(
                                height: 0.5.sh,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.r),
                                    topRight: Radius.circular(25.r),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    20.verticalSpace,
                                    // Add a handle for dragging
                                    Container(
                                      width: 80.w,
                                      height: 5.h,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    SizedBox(
                                        height: 10
                                            .h), // Space between handle and list

                                    // Wrap ListView.separated in Expanded
                                    viewModel.couponList.isEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 80.0),
                                            child: Center(
                                              child: Text(
                                                  "No coupins are available."),
                                            ),
                                          )
                                        : Expanded(
                                            child: ListView.separated(
                                              itemBuilder: (context, index) {
                                                var coupin =
                                                    viewModel.couponList[index];
                                                return CouponTile(
                                                  title: coupin.couponTitle,
                                                  value: coupin.couponValue,
                                                  discount:
                                                      coupin.couponDiscount,
                                                  couponType: coupin.couponType,
                                                  startDate:
                                                      coupin.couponStartDate,
                                                  endDate: coupin.couponEndDate,
                                                  imageUrl: coupin.couponImage,
                                                  onCouponRedeemed: () {
                                                    viewModel.voucherController
                                                            .text =
                                                        coupin.couponCode;
                                                    viewModel.rebuildUi();
                                                  },
                                                );
                                              },
                                              itemCount:
                                                  viewModel.couponList.length,
                                              separatorBuilder:
                                                  (context, index) =>
                                                      SizedBox(height: 5.h),
                                            ),
                                          ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.arrow_drop_down_rounded)),
                    hintText: "Select coupon",
                    controller: viewModel.voucherController,
                    readOnly: true,
                    onChanged: (val) {
                      viewModel.rebuildUi();
                    }),
              ),
              10.horizontalSpace,
              Expanded(
                flex: 1,
                child: CustomElevatedButton(
                  text: "Apply",
                  onPressed: (viewModel.voucherController.text.isEmpty ||
                          viewModel.discount > 0)
                      ? null
                      : () async {
                          if (viewModel.voucherController.text.isNotEmpty) {
                            await viewModel.applyCoupon(true);
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                  size: Size(112.w, 50.w),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _deliveryOption(BuildContext context, IconData icon, String subTitle,
      DeliveryMood mood, DeliveryMood selectedMood) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80.h,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          width: screenWidth(context),
          decoration: BoxDecoration(
              color: kcWhitColor, borderRadius: BorderRadius.circular(10.r)),
          child: Row(
            children: [
              10.horizontalSpace,
              Icon(
                  // Icons.pedal_bike,
                  icon,
                  color: kcPrimaryColor),
              10.horizontalSpace,
              Text(
                // "Standard Deliver",
                subTitle,
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          ),
        ),
        if (mood == selectedMood)
          Positioned(
            right: 10.w,
            top: -10.h,
            child: CircleAvatar(
              radius: 13.r,
              backgroundColor: kcPrimaryColor,
              child: const Icon(Icons.check, color: kcWhitColor, size: 15),
            ),
          ),
      ],
    );
  }

  @override
  CheckoutViewModel viewModelBuilder(BuildContext context) => CheckoutViewModel(
        context,
        cartProducts,
        note,
        restaurantId,
        cart,
        restaurantAvailableSlots ?? [],
      );
}

class PaymentMethodSelection extends StatefulWidget {
  const PaymentMethodSelection({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentMethodSelectionState createState() => _PaymentMethodSelectionState();
}

class _PaymentMethodSelectionState extends State<PaymentMethodSelection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutViewModel>(
      builder: (context, viewModel, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: kcWhiteColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModel.cart.restaurant?.isRestaurantOwnDelivery == 1)
              RadioListTile(
                activeColor: kcPrimaryColor,
                contentPadding: EdgeInsets.zero,
                title: const Text('Cash on Delivery'),
                // value: 'PayPal',
                value: PaymentMethod.cash,
                groupValue: viewModel.paymentMethod,
                onChanged: (value) {
                  setState(() {
                    // selectedPaymentMethod = value as String;
                    viewModel.paymentMethod = value as PaymentMethod;
                  });
                },
              ),
            if (viewModel.cart.restaurant?.isRestaurantOwnDelivery != 1)
              RadioListTile(
                activeColor: kcPrimaryColor,
                contentPadding: EdgeInsets.zero,
                title: const Text('PayPal'),
                // value: 'PayPal',
                value: PaymentMethod.paypal,
                groupValue: viewModel.paymentMethod,
                onChanged: (value) {
                  setState(() {
                    // selectedPaymentMethod = value as String;
                    viewModel.paymentMethod = value as PaymentMethod;
                  });
                },
              ),
            if (viewModel.cart.restaurant?.isRestaurantOwnDelivery != 1)
              RadioListTile(
                activeColor: kcPrimaryColor,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Credit / Debit Card',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                // value: 'Stripe',
                value: PaymentMethod.stripe,
                groupValue: viewModel.paymentMethod,
                onChanged: (value) {
                  setState(() {
                    viewModel.paymentMethod = value as PaymentMethod;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

enum PaymentMethod { stripe, paypal, cash }
