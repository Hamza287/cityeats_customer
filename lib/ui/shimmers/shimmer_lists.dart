import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/shimmers/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({
    required this.containerHeight,
    required this.containerWidth,
    required this.color,
    required this.space,
    this.margin,
    this.radius,
    this.cardWidth,
    this.itemCount,
    Key? key,
  }) : super(key: key);
  final double containerHeight;
  final double containerWidth;
  final Color color;
  final double? radius;
  final int space;
  final EdgeInsetsGeometry? margin;
  final double? cardWidth;
  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: containerWidth,
      height: containerHeight,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => ShimmerContainer(
          height: 35.h,
          width: cardWidth ?? 50.w,
          margin: EdgeInsets.only(left: 20.w),
          radius: 12.0.r,
        )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(color: kcPrimaryColor.withOpacity(0.1), duration: 1200.ms),
        itemCount: itemCount ?? 5,
        separatorBuilder: (BuildContext context, int index) =>
            space.horizontalSpace,
      ),
    );
  }
}
