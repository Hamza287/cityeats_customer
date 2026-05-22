import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import 'app_logo_model.dart';

class AppLogo extends StackedView<AppLogoModel> {
  const AppLogo({super.key});

  @override
  Widget builder(
    BuildContext context,
    AppLogoModel viewModel,
    Widget? child,
  ) {
    return Container(
      height: 162.h,
      width: 167.w,
      decoration: BoxDecoration(
          // color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: kcBlackColor,
            width: 2.w,
          )),
      child: Center(
        child: Text(
          "Food",
          style: TextStyle(
            fontSize: 32.sp,
            color: kcBlackColor,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale().then(delay: 400.ms);
  }

  @override
  AppLogoModel viewModelBuilder(BuildContext context) => AppLogoModel();
}
