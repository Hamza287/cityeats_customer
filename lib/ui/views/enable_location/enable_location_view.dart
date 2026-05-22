import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import 'enable_location_viewmodel.dart';

class EnableLocationView extends StackedView<EnableLocationViewModel> {
  const EnableLocationView({super.key});

  @override
  Widget builder(
      BuildContext context, EnableLocationViewModel viewModel, Widget? child) {
    return Scaffold(
      // ignore: deprecated_member_use
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset("$kcStaticImagesPath/location/location-pin.png",
                      height: 200.h, width: 200.w)
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale()
                  .then(delay: 400.ms),
              80.verticalSpace,
              Text(
                "Enable your Location",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              20.verticalSpace,
              Text(
                "Allow location on you phone for accurate service delivery. My Ace will locate you anytime.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 14.sp),
              ),
              55.verticalSpace,
              CustomElevatedButton(
                  text: "Allow Location",
                  onPressed: () {
                    ///
                    // viewModel.navigateToMapView();
                    viewModel.enableLocation();
                  }),
              10.verticalSpace,
              TextButton(
                onPressed: () {
                  ///
                  viewModel.doLater();
                },
                style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                child: Text(
                  "I’ll do this later",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      // fontWeight: FontWeight.w800,
                      // color: kcPrimaryColor,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  EnableLocationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EnableLocationViewModel();
}
