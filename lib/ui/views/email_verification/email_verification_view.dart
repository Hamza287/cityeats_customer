// ignore_for_file: no_wildcard_variable_uses

import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:stacked/stacked.dart';
import 'email_verification_viewmodel.dart';

class EmailVerificationView extends StackedView<EmailVerificationViewModel> {
  final bool isRoutedFromForgotView;
  final String email;
  const EmailVerificationView({
    super.key,
    required this.email,
    this.isRoutedFromForgotView = false,
  });

  @override
  Widget builder(BuildContext context, EmailVerificationViewModel viewModel,
      Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///
                  /// Contains back button and header text
                  ///
                  _header(context, viewModel),
                  37.verticalSpace,

                  ///
                  /// Contains otp section
                  ///
                  _otpSection(context, viewModel),

                  _backToLogin(context, viewModel),

                16.verticalSpace,

                  ///
                  /// Contains verify account button
                  ///
                  _verifyAccountButton(context, viewModel),
                  16.verticalSpace,

                  ///
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _backToLogin(context, EmailVerificationViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Back to?",
          // S.of(context).didntReceiveCodeText,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: kChineseBlackColor,
                fontFamily: GoogleFonts.inter().fontFamily,
                // fontWeight: FontWeight.w600,
              ),
        ),
        TextButton(
          onPressed: () {
            viewModel.routeToLogin();
          },
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          child: Text(
            'Login',
            // S.of(context).resendButtonText,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: kBluePigmentColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
          ),
        ),
      ],
    );
  }

  _verifyAccountButton(
      BuildContext context, EmailVerificationViewModel viewModel) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SvgPicture.asset(
            //   '$kStaticIconsPath/clock.svg',
            //   height: 21.sp,
            //   width: 21.sp,
            // ),
            8.horizontalSpace,
            Text(
              '00:${viewModel.counter}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: kTaupeGrayColor,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
            )
          ],
        ),
        16.verticalSpace,
        CustomElevatedButton(
          text: 'Verify Account',
          // text: S.of(context).verifyButtonText,
          textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: viewModel.isOtpComplete ? kWhiteColor : kcMediumGrey,
              ),
          onPressed: viewModel.isOtpComplete
              ? () {
                  viewModel.verifyOTP();
                }
              : null,
          backgroundColor:
              viewModel.isOtpComplete ? kcPrimaryColor : kBrightGreyColor,
        ),
      ],
    );
  }

  _otpSection(BuildContext context, EmailVerificationViewModel viewModel) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Pinput(
            cursor: Container(
              width: 1,
              height: 32.h,
              decoration: BoxDecoration(
                color: kChineseBlackColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            autofocus: true,
            length: 4,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            defaultPinTheme: pinTheme(context),
            focusedPinTheme: pinTheme(context).copyWith(
              decoration: BoxDecoration(
                color: kWhiteColor,
                border: Border.all(color: kcPrimaryColor),
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                      color: kcPrimaryColor.withOpacity(0.3),
                      blurRadius: 8.r,
                      spreadRadius: 3.r
                      // offset: const Offset(0, 5),
                      ),
                ],
              ),
            ),
            onChanged: viewModel.onChangeOTP,
          ),
        ),
        24.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive code?",
              // S.of(context).didntReceiveCodeText,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: kChineseBlackColor,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    // fontWeight: FontWeight.w600,
                  ),
            ),
            TextButton(
              onPressed: viewModel.isCounterZero
                  ? () {
                      viewModel.generateOTP();
                    }
                  : null,
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              child: Text(
                'Resend',
                // S.of(context).resendButtonText,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: viewModel.isCounterZero
                          ? kBluePigmentColor
                          : kTaupeGrayColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _header(BuildContext context, EmailVerificationViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        52.verticalSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {},
          ),
        ),
        25.verticalSpace,
        Text(
          'Email Verification',
          // S.of(context).emailVerificationText,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        8.verticalSpace,
        Text(
          'Enter the verification code we sent to your email at $email',
          // S.of(context).emailVerificationDescText + email,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: kTaupeGrayColor,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
        ),
      ],
    );
  }

  PinTheme pinTheme(_) => PinTheme(
        height: 52.w,
        width: 52.w,
        textStyle: Theme.of(_).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
        decoration: BoxDecoration(
          color: kcWhiteColor,
          border: Border.all(color: kSilverLightColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
      );

  @override
  EmailVerificationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EmailVerificationViewModel(
        context,
        email: email,
        isRoutedFromForgotView: isRoutedFromForgotView,
      );
}
