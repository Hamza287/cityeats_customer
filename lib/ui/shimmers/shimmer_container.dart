import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({
    Key? key,
    // required this.color,
    required this.height,
    required this.width,
    this.radius,
    this.margin,
  }) : super(key: key);

  final double height;
  final double width;
  final double? radius;
  final EdgeInsetsGeometry? margin;
  // final Color color;
  @override
  Widget build(BuildContext context) {
    return
        // Shimmer.fromColors(
        //   baseColor: Colors.grey[300]!,
        //   highlightColor: kcPrimaryColor.withOpacity(1.5),
        //   child:
        Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 8.0),
        color: const Color(0xffF4F5FA),
      ),
    )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(color: kcPrimaryColor.withOpacity(0.1), duration: 1200.ms);
    // );
  }
}
