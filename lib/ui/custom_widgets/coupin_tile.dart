import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CouponTile extends StatelessWidget {
  final String title;
  final String value;
  final String discount;
  final String couponType;
  final String startDate;
  final String endDate;
  final String? imageUrl;
  final VoidCallback onCouponRedeemed;

  const CouponTile({
    Key? key,
    required this.title,
    required this.value,
    required this.discount,
    required this.couponType,
    required this.startDate,
    required this.endDate,
    this.imageUrl,
    required this.onCouponRedeemed,
  }) : super(key: key);

  String _getDiscountText() {
    // For delivery_off type, show "x2" (free delivery)
    if (couponType == 'delivery_off') {
      return "x2";
    }

    // Get discount value
    final discountValue = double.tryParse(discount) ?? 0.0;

    // Format based on coupon type
    if (couponType == 'percent' && discountValue > 0) {
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: Card(
        elevation: 4,
        color: kcWhiteColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: kcGreyColor)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Background Image with Placeholder
              Positioned.fill(
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(height: 100.h, width: 100.w),
              ),
              // Shimmer Effect
              Positioned.fill(
                child: Shimmer.fromColors(
                  baseColor: kcGreyColor,
                  highlightColor: kcWhiteColor,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
              // Coupon Content
              Padding(
                padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kcBlackColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      couponType == 'delivery_off'
                          ? "Free Delivery"
                          : "Spend: £$value | Discount: ${_getDiscountText()}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: kcMediumGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Valid: $startDate - $endDate",
                      style: TextStyle(
                        fontSize: 12,
                        color: kcMediumGrey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 140.w,
                        height: 38.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CustomElevatedButton(
                              size: Size(130.w, 32.h),
                              text: "Get Coupon",
                              backgroundColor: kcPrimaryColor,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: kcWhitColor,
                                      fontWeight: FontWeight.bold),
                              onPressed: () {
                                onCouponRedeemed();
                                Navigator.pop(context);
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
