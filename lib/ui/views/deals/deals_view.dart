import 'package:city_customer_app/models/coupon_model.dart';
import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/shimmers/bannershimmer.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:city_customer_app/ui/widgets/common/cache_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import 'deals_viewmodel.dart';

class DealsView extends StackedView<DealsViewModel> {
  final bool showBackButton;
  const DealsView({super.key, this.showBackButton = false});

  @override
  Widget builder(
      BuildContext context, DealsViewModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: kcWhiteColor,
          backgroundColor: kcLightGreyColor,
          elevation: 0,
          leading: showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: kcBlackColor),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
          automaticallyImplyLeading: showBackButton,
          title: Text(
            "Promotions & Deals",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        backgroundColor: kcLightGreyColor,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    12.verticalSpace,
                    viewModel.isBusy
                        ? const ShimmerList(
                            color: Color(0xffF4F5FA),
                            height: 110,
                            width: 400,
                          )
                        : viewModel.couponList.isEmpty
                            ? const Center(child: Text("No promotions & Deals"))
                            : ListView.separated(
                                shrinkWrap: true,
                                itemCount: viewModel.couponList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) => _dealItem(
                                    context, viewModel.couponList[index]),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        12.verticalSpace,
                              )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Container _dealItem(BuildContext context, CouponBody coupon) {
    return Container(
      width: screenWidth(context),
      // height: 160.h,
      // margin: EdgeInsets.symmetric(vertical: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: kcBlackColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "UPTO",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 12.sp,
                    color: kcWhitColor,
                    fontWeight: FontWeight.bold),
              ),
              4.verticalSpace,
              Text(
                _getDiscountText(coupon),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 18.sp,
                    color: const Color(0xffFFCE21),
                    fontWeight: FontWeight.bold),
              ),
              4.verticalSpace,
              Text(
                // "Avail 20% off on all pizza",
                coupon.couponTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 14.sp,
                      letterSpacing: -.5,
                      color: kcWhitColor,
                    ),
              ),
              18.verticalSpace,
              CustomElevatedButton(
                text: "Apply Promo",
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: coupon.couponCode));
                  showSnackBar(context,
                      message: "Coupon code (${coupon.couponCode})  is copied");
                },
                size: Size(126.w, 38.h),
                backgroundColor: kcWhitColor,
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: kcBlackColor),
              )
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(70.r),
            child: NetworkImageWidget(
              url: coupon.couponImage,
              height: 120.h,
              width: 120.w,
            ),
          )
          // Image.asset(
          //   "$kcStaticImagesPath/pix.png",
          //   height: 120.h,
          //   width: 120.w,
          // )
        ],
      ),
    );
  }

  String _getDiscountText(CouponBody coupon) {
    // For delivery_off type, show "x2" (free delivery)
    if (coupon.couponType == 'delivery_off') {
      return "x2";
    }

    // Get discount value from backend
    final discountValue = double.tryParse(coupon.couponDiscount) ?? 0.0;

    // Format based on coupon type
    if (coupon.couponType == 'percent' && discountValue > 0) {
      // For percentage coupons, show as "10% OFF"
      return "${discountValue.toInt()}% OFF";
    } else if (discountValue > 0) {
      // For fixed amount coupons, show as "£10 OFF"
      return "£ ${discountValue.toInt()} OFF";
    } else {
      // Fallback if discount is 0 or invalid
      return "OFF";
    }
  }

  @override
  DealsViewModel viewModelBuilder(BuildContext context) =>
      DealsViewModel(context);
}
