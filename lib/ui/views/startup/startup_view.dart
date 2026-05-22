import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, StartupViewModel viewModel, Widget? child) {
    // return Scaffold(
    //   backgroundColor: kcPrimaryColor,
    //   body: Padding(
    //     padding: EdgeInsets.all(20.h),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisSize: MainAxisSize.max,
    //       children: [
    //         SizedBox(height: 150.h),
    //         ///
    //         Text(
    //           "Welcome to \nCity Eats App",
    //           textAlign: TextAlign.center,
    //           style: Theme.of(context).textTheme.headlineLarge?.copyWith(
    //                 fontSize: 28.sp,
    //                 letterSpacing: 1.3,
    //                 color: kcWhitColor,
    //               ),
    //         ),
    //         SizedBox(height: 100.h),
    //         const AppLogo(),
    //         const Spacer(),
    //         Center(
    //           child: Text(
    //             "We run the City Errands \nfor you",
    //             textAlign: TextAlign.center,
    //             style: Theme.of(context).textTheme.headlineLarge?.copyWith(
    //                   letterSpacing: 1.3,
    //                   color: kcWhitColor,
    //                 ),
    //           ),
    //         ),
    //         SizedBox(height: 40.h),
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      backgroundColor: Colors.white, // Fallback background color
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth(context),
            height: screenHeight(context),
            child: Image.asset(
              "$kcStaticImagesPath/splash/splash_back.png",
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if image fails to load
                return Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
          Positioned(
              top: 0,
              bottom: 0,
              left: 80.w,
              right: 80.w,
              child: Image.asset(
                "$kcStaticImagesPath/login_logo.png",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Return empty container if logo fails to load
                  return const SizedBox.shrink();
                },
              ))
        ],
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(BuildContext context) => StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}
