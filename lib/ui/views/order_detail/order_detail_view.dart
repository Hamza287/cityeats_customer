import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/custom_widgets/submodifiers_list.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import 'order_detail_viewmodel.dart';

class OrderDetailView extends StackedView<OrderDetailViewModel> {
  const OrderDetailView({super.key, required this.orderId});
  final int orderId;
  // final String restaurantName;
  @override
  Widget builder(
      BuildContext context, OrderDetailViewModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: kcWhiteColor,
          title: Text(
            "My Orders",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        backgroundColor: kcLightGreyColor,
        body: SafeArea(
          child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
            child: !viewModel.isLoaded
                ? const SizedBox()
                : Column(
                    children: [
                      _restaurantDetails(context, viewModel),

                      12.verticalSpace,
                      _transactionDetail(context, viewModel),
                      12.verticalSpace,

                      if (viewModel.res?.body?.orders?.deliveryAddress !=
                          "No-address-Found")
                        _deliveryAddress(context, viewModel),
                      12.verticalSpace,
                      _orderSummary(context, viewModel),
                      12.verticalSpace,
                      _orderNote(context, viewModel),
                      12.verticalSpace,
                      if (viewModel.res?.body?.orders?.orderStatus ==
                          "completed")
                        _reviewSection(context, viewModel),
                      25.verticalSpace,
                      _priceRowWidget(
                          context,
                          "Coupon Discount",
                          viewModel.res?.body?.orders?.couponDiscountAmount ??
                              "",
                          false),
                      8.verticalSpace,
                      _priceRowWidget(
                          context,
                          "Vat",
                          (viewModel.res?.body?.orders?.vat ?? "").toString(),
                          false),
                      8.verticalSpace,
                      _priceRowWidget(
                          context,
                          "Service charges",
                          (viewModel.res?.body?.orders?.serviceCharges ?? "")
                              .toString(),
                          false),
                      8.verticalSpace,
                      _priceRowWidget(
                        context,
                        "Bag fee",
                        (viewModel.res?.body?.orders?.bagFee ?? "").toString(),
                        false,
                      ),
                      8.verticalSpace,
                      _priceRowWidget(
                        context,
                        "Delivery Charges",
                        viewModel.res?.body?.orders?.deliveryCharge ?? "",
                        false,
                      ),
                      8.verticalSpace,
                      if (viewModel.res?.body?.orders?.newUserDiscount !=
                          0) ...[
                        _priceRowWidget(
                            context,
                            "New User Discount",
                            viewModel.res?.body?.orders?.newUserDiscount
                                    .toString() ??
                                "",
                            true),
                        8.verticalSpace,
                      ],
                      if (viewModel
                              .res?.body?.orders?.newUserDeliveryDiscount !=
                          0) ...[
                        _priceRowWidget(
                            context,
                            "Delivery Discount",
                            viewModel.res?.body?.orders?.newUserDeliveryDiscount
                                    .toString() ??
                                "",
                            true),
                        8.verticalSpace,
                      ],
                      8.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 18.sp),
                          ),
                          Text(
                            "£ ${viewModel.res?.body?.orders?.orderAmount}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      20.verticalSpace,
                      // CustomElevatedButton(text: 'FeedBack', onPressed: () {}),
                      // 20.verticalSpace,
                    ],
                  ),
          ),
          ),
        ),
      ),
    );
  }

  Row _priceRowWidget(
      BuildContext context, String title, String price, bool isDiscountadded) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 12.sp),
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
          isDiscountadded ? "- £$price" : " £$price",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Container _orderNote(BuildContext context, OrderDetailViewModel viewModel) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: kcWhitColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Order Note",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        12.verticalSpace,
        Text(
          viewModel.res?.body?.orders?.orderNote ?? "No Note Yet",
          style:
              Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
        ),
      ]),
    );
  }

  Container _reviewSection(
      BuildContext context, OrderDetailViewModel viewModel) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
          color: kcWhitColor, borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Review for Restaurant",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          5.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  (viewModel.res?.body?.orders?.restReview?.reviewRemarks
                          .toString()) ??
                      "Review not added",
                  maxLines: 2,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ),
              // SizedBox(
              //   height: 30.h,
              //   child: ListView.builder(
              //     // itemCount: order.review?.reviewStar ?? 0,
              //     itemCount: 4,
              //     shrinkWrap: true,
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (BuildContext context, int index) =>
              //         const Icon(Icons.star, color: Colors.yellow),
              //   ),
              // ),
              ///add button for review here
              viewModel.res?.body?.orders?.restReview == null
                  ? InkWell(
                      onTap: () async {
                        //
                        viewModel.showRestReviewDialog(
                            viewModel.res?.body?.orders?.id ?? 0,
                            viewModel.res?.body?.orders?.restaurant?.id ?? 0,
                            viewModel.res?.body?.orders?.riderId ?? 0);
                      },
                      child: Container(
                        height: 30.h,
                        width: 90.w,
                        padding: EdgeInsets.symmetric(horizontal: 5.h),
                        decoration: BoxDecoration(
                            color: kcPrimaryColor,
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Center(
                          child: Text(
                            "Review",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: kcBlackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp),
                          ),
                        ),
                      ),
                    )
                  : RatingBar.builder(
                      itemSize: 20,
                      initialRating: double.parse((viewModel
                                  .res?.body?.orders?.restReview?.reviewStar ??
                              0)
                          .toString()),
                      // minRating: 0,
                      direction: Axis.horizontal,
                      tapOnlyMode: true,
                      ignoreGestures: true,
                      updateOnDrag: false,
                      allowHalfRating: true,
                      itemCount: 5,
                      unratedColor: kcGreyColor,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {},
                    ),
            ],
          ),
          20.verticalSpace,
          Text(
            "Review for Ride",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          5.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  (viewModel.res?.body?.orders?.riderReview?.reviewRemarks
                          .toString()) ??
                      "Review not added",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 12.sp),
                ),
              ),

              ///add button for review here
              viewModel.res?.body?.orders?.riderReview == null
                  ? InkWell(
                      onTap: () async {
                        //
                        viewModel.showRiderReviewDialog(
                          viewModel.res?.body?.orders?.id ?? 0,
                          viewModel.res?.body?.orders?.restaurant?.id ?? 0,
                          viewModel.res?.body?.orders?.riderId ?? 0,
                        );
                      },
                      child: Container(
                        height: 30.h,
                        width: 90.w,
                        padding: EdgeInsets.symmetric(horizontal: 5.h),
                        decoration: BoxDecoration(
                            color: kcPrimaryColor,
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Center(
                          child: Text(
                            "Review",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: kcBlackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp),
                          ),
                        ),
                      ),
                    )
                  : RatingBar.builder(
                      itemSize: 20,
                      initialRating: double.parse((viewModel
                                  .res?.body?.orders?.riderReview?.reviewStar ??
                              0)
                          .toString()),
                      // minRating: 0,
                      direction: Axis.horizontal,
                      tapOnlyMode: true,
                      ignoreGestures: true,
                      updateOnDrag: false,
                      allowHalfRating: true,
                      itemCount: 5,
                      unratedColor: kcGreyColor,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {},
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Container _orderSummary(
      BuildContext context, OrderDetailViewModel viewModel) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: kcWhitColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Summary",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.res?.body?.orders?.orderDetail?.length ?? 0,
            itemBuilder: (context, index) => Stack(
              clipBehavior: Clip.none,
              children: [
                /// Main ListTile Container with Shadow
                Container(
                  width: 500.w,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    title: orderProductsDetail(viewModel, index, context),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        viewModel.res?.body?.orders?.orderDetail?[index]
                                    .modifiers?.isNotEmpty ??
                                false
                            ? showMoreButton(viewModel, index, context)
                            : const SizedBox(),
                        viewModel.res?.body!.orders!.orderDetail![index]
                                    .showMore ??
                                false
                            ? SubModifiersList(
                                subModifers: viewModel.getProductSubmod(
                                    viewModel.res!.body!.orders!
                                        .orderDetail![index]),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),

                // / Symmetrically Positioned Discount Banner
                if (viewModel.res?.body?.orders?.orderDetail?[index].discount !=
                    0)
                  Positioned(
                    right: 0, // Moves slightly outside the right edge
                    top: 0, // Moves slightly above the top edge
                    child: Container(
                      width: 60, // Wider banner for a better diagonal effect
                      padding: const EdgeInsets.symmetric(
                          vertical: 6), // Padding for better readability
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 237, 198, 3),
                        borderRadius:
                            BorderRadius.circular(4), // Slight rounding
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset:
                                const Offset(2, 2), // Slight shadow for depth
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          " £${(viewModel.res?.body?.orders?.orderDetail?[index].discount ?? 0)} OFF", // Improved label for clarity
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) =>
                6.verticalSpace,
          ),
        ],
      ),
    );
  }

  GestureDetector showMoreButton(
      OrderDetailViewModel viewModel, int index, BuildContext context) {
    return GestureDetector(
        onTap: () {
          viewModel.toggleShowMore(index);
        },
        child: Wrap(
          children: [
            Text(
              viewModel.res?.body!.orders!.orderDetail![index].showMore ?? false
                  ? "View less"
                  : " View more",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: kcPrimaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: kcPrimaryColor,
                  ),
            ),
            Icon(
              viewModel.res?.body!.orders!.orderDetail![index].showMore ?? false
                  ? Icons.keyboard_arrow_up_outlined
                  : Icons.keyboard_arrow_down_outlined,
              color: kcPrimaryColor,
              size: 20.sp,
            )
          ],
        ));
  }

  Row orderProductsDetail(
    OrderDetailViewModel viewModel,
    int index,
    BuildContext context,
  ) {
    final food = viewModel.res?.body?.orders?.orderDetail?[index].food;
    double price =
        (viewModel.res?.body?.orders?.orderDetail?[index].price ?? 0) /
            (viewModel.res?.body?.orders?.orderDetail![index].quantity ?? 1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          food?.name ?? "",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
              ),
        ),
        Text(
          "£ ${(price).toStringAsFixed(2)} x  ${viewModel.res?.body?.orders?.orderDetail?[index].quantity}",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: kcBlackColor,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Container _deliveryAddress(
      BuildContext context, OrderDetailViewModel viewModel) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: kcWhitColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Delivery Address",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        12.verticalSpace,
        Text(
          (viewModel.res?.body?.orders?.userId ==
                  locator<AuthService>().userProfile?.id)
              ? (locator<AuthService>().userProfile?.name ?? "").toUpperCase()
              : "User",
          style:
              Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
        ),
        8.verticalSpace,
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () {
            viewModel.navigateToMap(viewModel.res?.body?.orders?.address?.lat,
                viewModel.res?.body?.orders?.address?.lang);
          },
          child: Text(
            viewModel.res?.body?.orders?.address?.address ?? "",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: kcPrimaryColor,
                fontSize: 12.sp,
                decoration: TextDecoration.underline),
          ),
        ),
      ]),
    );
  }

  Container _transactionDetail(
      BuildContext context, OrderDetailViewModel viewModel) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: kcWhitColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Transaction Detail",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Payment Method",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 13.sp),
            ),
            Text(
              (viewModel.res?.body?.orders?.paymentMethod ?? "other")
                  .toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        8.verticalSpace,
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModel.res?.body?.orders?.transactionReference !=
                'null') ...[
              Text(
                "Transaction Id",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 13.sp),
              ),
              Text(
                viewModel.res?.body?.orders?.transactionReference ?? "",
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ]),
    );
  }

  verification(BuildContext context, OrderDetailViewModel viewModel) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Verification Code',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                viewModel.res?.body?.orders?.verificationCode ?? "0000",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please share this code with the rider when they arrive.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Container _restaurantDetails(
      BuildContext context, OrderDetailViewModel viewModel) {
    // const String originalDateTimeString = '2023-11-14T13:06:56.000000Z';
    final DateFormat inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ");
    final DateFormat outputFormat = DateFormat("MM-dd-yyyy, hh:mm a");
    DateTime originalDateTime =
        inputFormat.parse(viewModel.res?.body?.orders?.createdAt ?? "");
    String formattedDateTime = outputFormat.format(originalDateTime);

    final order = viewModel.res?.body?.orders;
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: kcWhitColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            const Icon(Icons.add_business),
            12.horizontalSpace,
            Text(
              viewModel.res?.body?.orders?.restaurant?.name ?? "",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                  ),
            ),
            const Spacer(),
            // const Icon(Icons.schedule, size: 18, color: kcBlackColor),
            // 6.horizontalSpace,
            // Text(
            //   "Re-Order",
            //   style: Theme.of(context)
            //       .textTheme
            //       .bodyMedium
            //       ?.copyWith(fontSize: 14.sp, color: const Color(0xff9AC86E)),
            // ),
          ],
        ),
        12.verticalSpace,
        Text(
          // "Order ID: 12345678",
          "Order ID: ${viewModel.res?.body?.orders?.id}",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        6.verticalSpace,
        Text(
          // "Order ID: 12345678",
          "Verification code: ${viewModel.res?.body?.orders?.verificationCode}",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        6.verticalSpace,
        if (viewModel.res?.body?.orders?.scheduledSlots?.slotDate != null &&
            (viewModel
                    .res?.body?.orders?.scheduledSlots?.slotDate?.isNotEmpty ??
                false)) ...[
          Text(
            " ${order?.scheduledSlots?.slotDate},${viewModel.dateTimeService.convertIntoAmPmDate(order?.scheduledSlots?.startTime ?? " ")} - ${viewModel.dateTimeService.convertIntoAmPmDate(order?.scheduledSlots?.endTime ?? " ")}",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp, color: kcBlackColor.withOpacity(0.7)),
          )
        ] else ...[
          Text(
            formattedDateTime,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp, color: kcBlackColor.withOpacity(0.7)),
          ),
        ],
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Status",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp, color: kcBlackColor.withOpacity(0.7)),
            ),
            Text(
              // "In Progress",
              // "${viewModel.res?.body?.orders?.orderStatus}",
              viewModel.res?.body?.orders?.orderStatus == 'cancel_request'
                  ? "cancel request"
                  : viewModel.getOrderStatus(
                      viewModel.res?.body?.orders?.orderStatus ?? ''),

              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  color: viewModel.res?.body?.orders?.orderStatus == "pending"
                      ? kcPrimaryColor
                      : viewModel.res?.body?.orders?.orderStatus == "completed"
                          ? kGreenColor
                          : Colors.red),
            ),
          ],
        ),
      ]),
    );
  }

  @override
  OrderDetailViewModel viewModelBuilder(BuildContext context) =>
      OrderDetailViewModel(orderId);
}
