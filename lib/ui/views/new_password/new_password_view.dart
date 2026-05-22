import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/form_validations/form_validator.dart';
import 'package:city_customer_app/ui/views/change_password/change_password_view.form.dart';
import 'package:city_customer_app/ui/views/new_password/new_password_view.form.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:city_customer_app/ui/widgets/common/validation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'new_password_viewmodel.dart';

@FormView(
  fields: [
    FormTextField(
      name: 'new_pass',
      validator: FormFieldsValidator.validatePassword,
    ),
    FormTextField(
      name: 'c_password',
      validator: FormFieldsValidator.validatePassword,
    ),
  ],
)
class NewPasswordView extends StackedView<NewPasswordViewModel>
    with $NewPasswordView {
  final String email;
  const NewPasswordView({super.key, required this.email});

  @override
  Widget builder(
      BuildContext context, NewPasswordViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomProgressIndicator(
          isLoading: viewModel.isBusy,
          child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    viewModel.navigationService.back();
                  },
                ),
                30.verticalSpace,
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Reset Password",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 22.sp, fontWeight: FontWeight.w600),
                  ),
                ),
                30.verticalSpace,
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "$kcStaticImagesPath/forgot/new-password.png",
                    height: 191.h,
                    width: 214.w,
                  )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .scale()
                      .then(delay: 400.ms),
                ),
                20.verticalSpace,
                Text(
                  "Enter otp here",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                10.verticalSpace,
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
                20.verticalSpace,
                Text(
                  "Create new password",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                10.verticalSpace,
                CustomTextField(
                  hintText: "***********",
                  prefix: const Icon(Icons.lock),
                  obscure: viewModel.passwordHidden,
                  controller: newPassController,
                  focusNode: newPassFocusNode,
                  noSpace: true,
                  onChanged: (val) {
                    viewModel.newPass = val?.trim() ?? "";
                  },
                  suffix: IconButton(
                    splashRadius: 10.r,
                    onPressed: () {
                      viewModel.togglePassVisibility();
                    },
                    icon: Icon(
                      viewModel.passwordHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: kSlateGrayColor,
                    ),
                  ),
                ),
                if (viewModel.hasNewPassValidationMessage)
                  ValidationWidget(
                      message: viewModel.newPassValidationMessage ??
                          "Please enter old password"),
                15.verticalSpace,
                Text(
                  "Confirm password",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                10.verticalSpace,
                CustomTextField(
                  hintText: "*************",
                  prefix: const Icon(Icons.lock),
                  // textInputType: TextInputType.name,
                  obscure: viewModel.cPasswordHidden,
                  controller: cPasswordController,
                  focusNode: cPasswordFocusNode,
                  noSpace: true,
                  onChanged: (val) {
                    viewModel.cNewPass = val?.trim() ?? "";
                  },
                  suffix: IconButton(
                    splashRadius: 10.r,
                    onPressed: () {
                      viewModel.toggleCPassVisibility();
                    },
                    icon: Icon(
                      viewModel.cPasswordHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: kSlateGrayColor,
                    ),
                  ),
                ),
                if (cPasswordController.text != newPassController.text)
                  const ValidationWidget(
                      message:
                          "New password and confirm new password are not matching"),
                40.verticalSpace,
                CustomElevatedButton(
                    text: 'Change Password',
                    backgroundColor: viewModel.otp.length == 4 &&
                            viewModel.newPass == viewModel.cNewPass
                        ? kcPrimaryColor
                        : kcGreyColor,
                    onPressed: () {
                      ///
                      if (
                          // viewModel.isFormValid &&
                          viewModel.otp.length == 4 &&
                              !viewModel.hasNewPassValidationMessage &&
                              !viewModel.hasConfirmPasswordValidationMessage &&
                              viewModel.hasNewPass &&
                              viewModel.hasCPassword &&
                              viewModel.newPass == viewModel.cNewPass) {
                        viewModel.requestNewPassword();
                      }
                    })
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }

  PinTheme pinTheme(_) => PinTheme(
        height: 52.w,
        width: 52.w,
        // ignore: no_wildcard_variable_uses
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
  void onViewModelReady(NewPasswordViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    super.onViewModelReady(viewModel);
  }

  @override
  void onDispose(NewPasswordViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }

  @override
  NewPasswordViewModel viewModelBuilder(BuildContext context) =>
      NewPasswordViewModel(context, email);
}
