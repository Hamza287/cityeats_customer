import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/widgets/common/cache_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({
    Key? key,
    this.isImage,
    required this.color,
    required this.height,
    required this.width,
  }) : super(key: key);

  final bool? isImage;
  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        color: kcWhiteColor,
        child: ListView.separated(
          itemCount: 10,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: color,
                  ),
                  height: height.h,
                  width: width.w,
                  child: isImage != null
                      ? Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5.0),
                              height: 90.h,
                              width: 90.w,
                              child: NetworkImageWidget(
                                url: " $kcStaticImagesPath/place_pro.jpeg",
                                bottomLeftRadius: 10.r,
                                topLeftRadius: 10.r,
                                bottomRightRadius: 10.r,
                                topRightRadius: 10.r,
                              ),
                            ),
                          ],
                        )
                      : null)
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                  color: kcPrimaryColor.withOpacity(0.1), duration: 1200.ms),
          separatorBuilder: (BuildContext context, int index) =>
              16.verticalSpace,
        ));
  }
}
