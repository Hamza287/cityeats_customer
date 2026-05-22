import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TileWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final String? kcImagesPath;
  final bool? isAddedImage;

  const TileWidget({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.icon,
    this.kcImagesPath,
    this.isAddedImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      width: MediaQuery.of(context).size.width, // screenWidth(context)
      color: kcWhiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: kcPrimaryColor),
              10.horizontalSpace,
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kcBlackColor.withOpacity(0.6),
                      fontSize: 12.sp,
                    ),
              ),
            ],
          ),
          isAddedImage == true
              ? Image.asset(
                  kcImagesPath ?? "",
                  height: 60.h,
                  width: 100.w,
                )
              : Text(
                  subTitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                      ),
                ),
        ],
      ),
    );
  }
}
