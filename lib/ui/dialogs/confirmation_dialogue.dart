import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmationDialog<T> extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onPressed,
    this.okButtonText = 'Ok',
    this.cancelButtonText = "Cancel",
    this.isIncludeCancelButton = true,
    this.normalPadding = false,
  });
  final String title;
  final T subTitle;
  final void Function() onPressed;
  final String okButtonText;
  final String cancelButtonText;
  final bool isIncludeCancelButton;
  final bool normalPadding;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        // width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(17.w),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              12.0.verticalSpace,
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xff0D0F23),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
              10.0.verticalSpace,

              buildSubTitleWidget(subTitle, context),
              //

              30.0.verticalSpace,
              getActionButtons(context),
            ]),
      ),
      // Positioned(
      //   top: 12.h,
      //   right: 12.w,
      //   child: Align(
      //       alignment: Alignment.centerRight,
      //       child: IconButton(
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //         },
      //         icon: Icon(
      //           Icons.close,
      //           size: 20.sp,
      //         ),
      //       )),
      // )
    ]);
  }

  /// A function to build the subtitle widget of the confirmation dialog.
  ///
  /// It takes a generic type [T] as an argument, which can be either a [String]
  /// or a [Widget].
  ///
  /// If [subTitle] is a [String], it returns a [Text] widget with the provided
  /// string and a font size of 16.
  ///
  /// If [subTitle] is a [Widget], it returns the provided widget.
  ///
  /// If [subTitle] is neither a [String] nor a [Widget], it returns an empty
  /// [SizedBox].
  Widget buildSubTitleWidget(T? subTitle, BuildContext context) {
    if (subTitle is Widget) {
      return subTitle;
    } else if (subTitle is String) {
      return Text(
        subTitle,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 16.sp, fontFamily: GoogleFonts.roboto().fontFamily),
      );
    } else {
      return const SizedBox(); // Return an empty widget if subTitle is neither String nor Widget
    }
  }

  Widget getActionButtons(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (isIncludeCancelButton)
          CustomElevatedButton(
            backgroundColor: const Color(0xffE5E7EB),
            text: "No",
            textStyle:
                TextStyle(color: const Color(0xff0D0F23), fontSize: 14.sp),
            size: Size(120.w, 40.h),
            onPressed: () {
              Navigator.of(context).pop();
              // setState(() {
              //   state = ViewState.busy;
              // });
              // widget.viewModel.rejectFriendRequest(
              //     widget.friendRequest.fkSourceId.validateNull);
              // setState(() {
              //   state = ViewState.idle;
              // });
            },
          ),
        CustomElevatedButton(
            backgroundColor: kcPrimaryColor,
            textStyle: TextStyle(color: kWhiteColor, fontSize: 14.sp),
            text: "Yes",
            size: Size(120.w, 40.h),
            onPressed: () {
              Navigator.of(context).pop();
              onPressed();
            }),
      ],
    );
  }
}
