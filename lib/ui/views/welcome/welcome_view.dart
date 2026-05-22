import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'welcome_viewmodel.dart';
class WelcomeView extends StackedView<WelcomeViewModel> {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, WelcomeViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 40.h),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('$kcWelcomePath/welcome.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomElevatedButton(
              size: Size(375.w, 48.h),
              onPressed: () {
                viewModel.navigateToLogin();
              },
              text: 'Login',
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: kcWhitColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "New on City Eat? ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: kcWhitColor),
                ),
                TextButton(
                  onPressed: () {
                    ///
                    // viewModel.setGuestUser();
                    // GoRouter.of(context).go(AppRoutes.home);
                    viewModel.navigateToSignUp();
                  },
                  style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  child: Text(
                    "Signup Now",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: kcWhitColor,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  WelcomeViewModel viewModelBuilder(BuildContext context) => WelcomeViewModel();
}
