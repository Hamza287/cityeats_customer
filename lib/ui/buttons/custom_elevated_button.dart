import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Size? size;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final Widget? child;

  const CustomElevatedButton({
    required this.text,
    required this.onPressed,
    this.size,
    this.backgroundColor,
    this.textStyle,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: size ?? Size(double.infinity, 48.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        backgroundColor:
            onPressed != null ? backgroundColor ?? kcPrimaryColor : kcGreyColor,
      ),
      child: child ??
          Text(
            text,
            style: textStyle ?? Theme.of(context).textTheme.displaySmall,
          ),
    )
        // .animate().fadeIn(duration: 800.ms).scale().then(delay: 400.ms)
        ;
  }
}
