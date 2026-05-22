// import 'package:city_customer_app/responses/add_to_cart_response.dart';
import 'package:city_customer_app/responses/cart_response.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/views/checkout/checkout_viewmodel.dart';
import 'package:city_customer_app/ui/views/checkout/widgets/schedule_slot_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ScheduleSheetSheet extends StackedView<CheckoutViewModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;
  const ScheduleSheetSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CheckoutViewModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Stack(
        children: [
          if (!viewModel.dataLoaded) ...[
            const Center(
              child: CircularProgressIndicator(
                color: kcPrimaryColor,
                strokeWidth: 3,
              ),
            ),
          ] else ...[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        request.title ?? 'Hello Stacked Sheet!!',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 24.h,
                        width: 24.w,
                      ),
                    ],
                  ),
                  if (request.description != null) ...[
                    verticalSpaceTiny,
                    Text(
                      "choose your preferred date and time",
                      style: const TextStyle(fontSize: 14, color: kcMediumGrey),
                      maxLines: 3,
                      softWrap: true,
                    ),
                  ],
                  verticalSpaceTiny,
                  const Divider(
                    color: Colors.grey,
                  ),
                  verticalSpaceTiny,
                  //date section
                  Text(
                    "Select Date",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  // verticalSpacSmall,
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: SizedBox(
                      // height: 9.h,
                      child: ScheduleSlotPicker(),
                    ),
                  ),
                  //
                ],
              ),
            ),
          ],
          if (viewModel.isDateAndTimeRangeChoosen())
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  completer?.call(
                    SheetResponse(
                      confirmed: true,
                      data: {
                        "date": viewModel.chosenDate,
                        "slot": viewModel.chosenSlot,
                      },
                    ),
                  );
                },
                child: Container(
                  height: 45.h,
                  margin: EdgeInsets.only(
                    left: 18.w,
                    right: 18.w,
                    bottom: 18.h,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kcPrimaryColor,
                    borderRadius: BorderRadius.circular(
                      24.r,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(
                          0,
                          0,
                          0,
                          0.12,
                        ),
                        offset: Offset(0, 0),
                        blurRadius: 40.w,
                        spreadRadius: 0.w,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Schedule',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  CheckoutViewModel viewModelBuilder(BuildContext context) => CheckoutViewModel(
        context,
        request.data['cartProducts'] ?? [],
        request.data['notes'] ?? "",
        request.data?['restaurantId'] ?? 0,
        request.data?['cart'] ?? Cart(),
        request.data?['restaurantAvailableSlots'] ?? [],
      );
}

class ScheduleSheetTopBar extends StatelessWidget {
  const ScheduleSheetTopBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0.h, horizontal: 18.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // InkWell(
          //   onTap: () {
          //     model.choosenDate != null || model.choseTimeRange != null
          //         ? model.closeScheduleSheet()
          //         : model.deactivateScheduleSheet();
          //   },
          //   child: Icon(
          //     Icons.keyboard_arrow_left_rounded,
          //     size: 24.w,
          //   ),
          // ),
          Text(
            'Choose Timings',
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          SizedBox(
            height: 24.h,
            width: 24.w,
          ),
          verticalSpaceTiny,
          Text(
            "choose your preferred date and time",
            style: const TextStyle(fontSize: 14, color: kcMediumGrey),
            maxLines: 3,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
