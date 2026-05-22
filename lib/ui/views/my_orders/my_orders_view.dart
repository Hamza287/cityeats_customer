// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:city_customer_app/responses/order_response.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'my_orders_viewmodel.dart';

class MyOrdersView extends StackedView<MyOrdersViewModel> {
  const MyOrdersView({super.key});

  @override
  Widget builder(
      BuildContext context, MyOrdersViewModel viewModel, Widget? child) {
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
          child: RefreshIndicator(
          color: kcPrimaryColor,
          onRefresh: () async {
            viewModel.getMyOrders();
          },
          child: Container(
            padding: EdgeInsets.only(
                left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
            child: viewModel.ordersList.isEmpty
                ? ListView(children: const [])
                : ListView.separated(
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.ordersList.length,
                    itemBuilder: (context, index) =>
                        _item(context, viewModel, viewModel.ordersList[index]),
                    separatorBuilder: (BuildContext context, int index) {
                      return 15.verticalSpace;
                    },
                  ),

            // Column(children: [
            //   _item(context, viewModel),
            //   15.verticalSpace,
            //   // _item(context, viewModel),
            //   // 15.verticalSpace,
            //   // _item(context, viewModel),
            //   // 15.verticalSpace,
            //   // _item(context, viewModel),
            // ]),
          ),
          ),
        ),
      ),
    );
  }

  _item(BuildContext context, MyOrdersViewModel viewModel, OrderModel order) {
    String? localTime = DateTimeHelper()
        .convertTimeToLocal(DateTime.parse(order.createdAt ?? ""));
    return InkWell(
      onTap: () {
        viewModel.navigateToDetail(order.id!, order.restaurant?.name ?? "");
      },
      child: Stack(children: [
        Container(
          width: screenWidth(context),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: kcWhitColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const Icon(Icons.add_business),
                12.horizontalSpace,
                Text(
                  // "Restaurant Name",
                  order.restaurant?.name ?? "",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                      ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // "Order ID: 12345678",
                      "Order ID: ${order.id}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                          ),
                    ),
                    6.verticalSpace,
                    if (order.scheduledSlots?.slotDate != null &&
                        order.scheduledSlots!.slotDate!.isNotEmpty) ...[
                      Text(
                        " ${order.scheduledSlots?.slotDate},${viewModel.dateTimeService.convertIntoAmPmDate(order.scheduledSlots?.startTime ?? " ")} - ${viewModel.dateTimeService.convertIntoAmPmDate(order.scheduledSlots?.endTime ?? " ")}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: kcBlackColor.withOpacity(0.7)),
                      ),
                    ] else ...[
                      Text(
                        // "07-04-2022, 12:30 pm",
                        // formattedDateTime,
                        (localTime).toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: kcBlackColor.withOpacity(0.7)),
                      ),
                    ]
                  ],
                ),
                if ((order.canCancel ?? false) &&
                    ((!(order.orderStatus ?? "")
                            .trim()
                            .contains("completed")) ||
                        !(order.orderStatus ?? "")
                            .trim()
                            .contains("cancel request"))) ...[
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      bool cancel = await _onCanceled(context);
                      if (cancel) {
                        await viewModel.cancelOrder(context, order.id!);
                        order.canCancel = false;
                        order.orderStatus = 'cancel request';
                        viewModel.rebuildUi();
                      }
                    },
                    child: Container(
                      height: 30.h,
                      width: 90.w,
                      padding: EdgeInsets.symmetric(horizontal: 5.h),
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(.1),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 9.r,
                              child: const Icon(Icons.remove, size: 9),
                            ),
                            Text(
                              "Cancel",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.redAccent[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp),
                            )
                          ]),
                    ),
                  )

                  // ElevatedButton.icon(
                  //   style: ElevatedButton.styleFrom(
                  //       surfaceTintColor: Colors.transparent,
                  //       shadowColor: Colors.transparent,
                  //       maximumSize: Size(100.w, 45.w),
                  //       shape: const OutlinedBorder(),
                  //       padding:
                  //           EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  //       side: const BorderSide(
                  //         style: BorderStyle.solid,
                  //         color: Colors.red,
                  //       ),
                  //       backgroundColor: Colors.red.withOpacity(0.4)),
                  //   icon: CircleAvatar(
                  //     backgroundColor: Colors.red,
                  //     radius: 9.r,
                  //     child: const Icon(Icons.remove, size: 9),
                  //   ),
                  //   onPressed: () async {
                  //     await viewModel.cancelOrder(context, order.id!);
                  //     order.canCancel = false;
                  //     order.orderStatus = 'cancel_request';
                  //     viewModel.rebuildUi();
                  //   },
                  //   label: Text(
                  //     "Cancel",
                  //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  //       color: Colors.redAccent[700], fontSize: 12.sp),
                  // ),
                  // )
                ],
                if (((order.orderStatus ?? "").trim().contains("completed") &&
                    (order.restReview == null ||
                        order.riderReview == null))) ...[
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      //
                      viewModel.showOrderFeedbackDialog(
                        order.id ?? 0,
                        order.restaurant?.id ?? 0,
                        order.riderId ?? 0,
                        order.riderReview != null,
                        order.restReview != null,
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
                ]
              ],
            ),
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
                  order.orderStatus == 'cancel_request'
                      ? "cancel request"
                      : "${order.orderStatus}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        color: order.orderStatus == "pending"
                            ? kcPrimaryColor
                            : order.orderStatus == "completed"
                                ? kGreenColor
                                : Colors.red,
                      ),
                ),
              ],
            ),
          ]),
        ),
        if (order.scheduledSlots?.slotDate != null &&
            order.scheduledSlots!.slotDate!.isNotEmpty &&
            order.orderStatus == "pending")
          Positioned(
              right: -20.w,
              top: 23.h,
              child: Transform.rotate(
                angle: -(pi / 180) * 315,
                child: Container(
                  height: 20.h,
                  width: 110.w,
                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.r),
                    color: Color.fromARGB(255, 237, 198, 3),
                  ),
                  child: Text(
                    "Scheduled Order",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: kcBlackColor),
                  ),
                ),
              )),
      ]),
    );
  }

  Future<bool> _onCanceled(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Confirm Cancel',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            content: const Text('Are you sure you want to cancel this order?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: kcBlackColor),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Yes',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: kcBlackColor),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  MyOrdersViewModel viewModelBuilder(BuildContext context) =>
      MyOrdersViewModel();
}

class DateTimeHelper {
  // Create a DateTime object
  // DateTime utcDateTime = DateTime.utc(2023, 1, 1, 12, 0, 0);

  convertTimeToLocal(DateTime utcDateTime) {
    // Convert the DateTime to the local time zone
    DateTime localDateTime = utcToLocal(utcDateTime);

    // Format the local DateTime
    String formattedTime = formatLocalDateTime(localDateTime);

    // print('UTC DateTime: $utcDateTime');
    // print('Local DateTime: $formattedTime');
    return formattedTime;
  }

  DateTime utcToLocal(DateTime utcDateTime) {
    // Create a TZDateTime object using the UTC DateTime and the local time zone
    final local = utcDateTime.toLocal();
    return DateTime(local.year, local.month, local.day, local.hour,
        local.minute, local.second, local.millisecond, local.microsecond);
  }

  String formatLocalDateTime(DateTime localDateTime) {
    // Format the DateTime using the desired pattern
    final formatter = DateFormat('MM-dd-yyyy, hh:mm a');
    return formatter.format(localDateTime);
  }

  differenceLessThanTwoMinutes(DateTime utcDateTime1) {
    // Create two DateTime objects

    // Convert UTC DateTime to local DateTime
    DateTime localDateTime1 = utcToLocal(utcDateTime1);
    DateTime localDateTime2 = DateTime.now();

    // Find the difference between the two DateTime objects
    Duration difference = localDateTime2.difference(localDateTime1);

    // Check if the difference is less than two minutes
    if (difference.inMinutes < 2) {
      // Perform the action (replace this with your actual action)
      // print('The difference is less than two minutes.');
      return true;
    } else {
      // print('The difference is equal to or greater than two minutes.');
      return false;
    }
  }
}
