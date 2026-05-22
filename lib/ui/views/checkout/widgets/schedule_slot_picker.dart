import 'package:city_customer_app/responses/cart_response.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/views/checkout/checkout_viewmodel.dart';
import 'package:city_customer_app/ui/views/restaurant_detail/restaurant_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScheduleSlotPicker extends StatefulWidget {
  const ScheduleSlotPicker({
    Key? key,
    // required this.modifiers
  }) : super(key: key);

  // final List<Modifiers> modifiers;

  @override
  State<ScheduleSlotPicker> createState() => _ScheduleSlotPickerState();
}

class _ScheduleSlotPickerState extends State<ScheduleSlotPicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutViewModel>(
      builder: (context, model, child) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateBoxList(dates: model.weeklyDates),
            TimeRanges(
              timeRange: model.restaurantAvailableSlots
                      .firstWhere(
                          (element) =>
                              element.date?.day ==
                              (model.chosenDate ?? DateTime.now()).day,
                          orElse: () => RestaurantAvailableSlots(slots: []))
                      .slots ??
                  [],
            ),
          ],
        ),
      ),
    );
  }
}

class DateBoxList extends StatelessWidget {
  const DateBoxList({
    Key? key,
    required this.dates,
  }) : super(key: key);

  final List<CustomDate> dates;

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutViewModel>(
      builder: (context, model, child) => SizedBox(
        height: 75.h,
        child: ListView.custom(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(vertical: 5.h),
          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) {
              return DateBox(
                dateTime: dates[index].date,
                isSelected: model.chosenDate == null && index == 0
                    ? true
                    : dates[index].isSelected,
                index: index,
              );
            },
            childCount: dates.length,
          ),
        ),
      ),
    );
  }
}

class TimeRanges extends StatelessWidget {
  const TimeRanges({
    required this.timeRange,
    Key? key,
  }) : super(key: key);

  final List<Slots> timeRange;

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutViewModel>(
      builder: (context, model, child) => ListView.builder(
        itemCount: timeRange.length + 1,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
        itemBuilder: (context, index) {
          return index == timeRange.length
              ? SizedBox(height: 110.h)
              : timeRange.isEmpty
                  ? Center(
                      child: Text(
                        "No slots available for this date",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : TimeDurationTile(
                      customTime: timeRange[index],
                      index: index,
                    );
        },
      ),
    );
  }
}

class TimeDurationTile extends StatelessWidget {
  const TimeDurationTile({
    required this.customTime,
    required this.index,
    Key? key,
  }) : super(key: key);
  final Slots customTime;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutViewModel>(
      builder: (context, model, child) => GestureDetector(
        onTap: () {
          model.assignTime(customTime);
          model.selectTime(index, customTime);
        },
        child: Container(
          width: 337.w,
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.12),
                offset: Offset(0, 0),
                blurRadius: 5.w,
                spreadRadius: 0.w,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: 15.0.h,
              bottom: 16.0.h,
              left: 8.w,
              right: 8.w,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  customTime.startTime != null && customTime.endTime != null
                      ? '${model.dateTimeService.convertIntoAmPmDate(customTime.startTime ?? " ")} - ${model.dateTimeService.convertIntoAmPmDate(customTime.endTime ?? " ")}'
                      : 'NA',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black,
                  ),
                ),
                Container(
                  height: 18.h,
                  width: 18.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: customTime.isSelected
                          ? kcPrimaryColor
                          : Colors.black38,
                      width: 1.5.w,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: customTime.isSelected
                      ? Center(
                          child: Container(
                            height: 10.h,
                            width: 10.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kcPrimaryColor,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateBox extends StatelessWidget {
  const DateBox({
    required this.dateTime,
    required this.isSelected,
    required this.index,
    Key? key,
  }) : super(key: key);
  final DateTime dateTime;
  final bool isSelected;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutViewModel>(
      builder: (context, model, child) => Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: InkWell(
          onTap: () {
            model.assignDate(dateTime);
            model.selectDate(index);
          },
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: 90.w,
            height: 70.h,
            padding: EdgeInsets.only(left: 8.w),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    isSelected ? kcPrimaryColor : Colors.grey.withOpacity(0.5),
                width: isSelected ? 2.w : 0.7.w,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 9.h),
                Text(
                  getDayOfWeek(dateTime),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: '${getFormattedDate(dateTime).split(' ').first} ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: kcPrimaryColor.withOpacity(0.7),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: getFormattedDate(dateTime).split(' ')[1],
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 9.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getDayOfWeek(DateTime date) {
    DateTime todaysDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime apiDate = DateTime(date.year, date.month, date.day);

    if (todaysDate.isAtSameMomentAs(apiDate)) {
      return 'Today';
    }

    if (todaysDate.add(Duration(days: 1)).isAtSameMomentAs(apiDate)) {
      return 'Tomorrow';
    }

    String dayOfWeek = DateFormat('EEEE').format(date);
    if (dayOfWeek.length > 6) {
      return dayOfWeek.substring(0, 3);
    }
    return dayOfWeek;
  }

  String getFormattedDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }
}
