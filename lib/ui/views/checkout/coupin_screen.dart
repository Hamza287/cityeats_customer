import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/views/checkout/checkout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseCoupinScreen extends StatefulWidget {
  const ChooseCoupinScreen({super.key, required this.checkoutViewModel});
  final CheckoutViewModel checkoutViewModel;
  @override
  State<ChooseCoupinScreen> createState() => _ChooseCoupinScreenState();
}

class _ChooseCoupinScreenState extends State<ChooseCoupinScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

@override
Widget build(BuildContext context, dynamic widget) {
  final model = widget.checkoutViewModel;
  return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      child: Stack(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              18.0.verticalSpace,

              ///
              Container(
                height: 5.h,
                width: 74.w,
                decoration: const BoxDecoration(color: kcGreyColor),
              ),
              13.0.verticalSpace,

              ///

              SizedBox(height: 16.h),

              /// Tab Content
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildActionButtons(context, model),
        ),
      ]));
}

Widget _buildActionButtons(BuildContext context, CheckoutViewModel model) {
  return Container(
    color: kWhiteColor,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // CustomElevatedButton(
        //   backgroundColor: const Color(0xffE5E7EB),
        //   icon: kCrossImage,
        //   iconColor: const Color(0xff42526E),
        //   fontColor: const Color(0xff374151),
        //   height: 48.h,
        //   width: MediaQuery.of(context).devicePixelRatio > 2 ? 158.w : 140.w,
        //   title: "Reset",
        //   includeIcon: false,
        //   fontSize: 14.sp,
        //   iconHeight: 14.h,
        //   iconWidth: 14.w,
        //   radius: 8.r,
        //   fontWeight: FontWeight.bold,
        //   onTap: () {
        //     model.clearFilters();
        //     GoRouter.of(context).pop();
        //     model.selectedFilterIndex = 0;
        //     model.radiusController.clear();
        //     model.selectedRadius = '';
        //     widget.feedViewModel.getPosts(isLoad: true);
        //   },
        // ),
        // CustomElevatedButton(
        //     backgroundColor:
        //         //  model.selectedOptions.isEmpty &&
        //         //         model.selectedFriendtype.isEmpty &&
        //         //         model.selectedRelationType.isEmpty
        //         // ? kSlateGrayColor
        //         // :
        //         kPrimaryColor,
        //     icon: kTikImage,
        //     iconColor: kWhiteColor,
        //     fontColor: kWhiteColor,
        //     height: 48.h,
        //     width:
        //         MediaQuery.of(context).devicePixelRatio > 2 ? 158.w : 140.w,
        //     title: 'Apply',
        //     radius: 8.r,
        //     fontSize: 14.sp,
        //     iconHeight: 14.h,
        //     iconWidth: 14.w,
        //     includeIcon: false,
        //     fontWeight: FontWeight.bold,
        //     onTap:
        //         //  model.selectedOptions.isEmpty &&
        //         //         model.selectedFriendtype.isEmpty &&
        //         //         model.selectedRelationType.isEmpty
        //         //     ? null
        //         //     :
        //         () {
        //       Future.delayed(const Duration(milliseconds: 200), () {
        //         GoRouter.of(context).pop();
        //       });
        //       model.postLoadingIndex = 0;
        //       model.getPosts(isLoad: true);
        //       model.selectedFilterIndex = 0;
        //     }),
      ],
    ),
  );
}

Widget buildDivider() => const Divider(
      height: 0,
      color: kcBlueColor,
    );
