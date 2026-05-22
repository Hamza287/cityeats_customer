import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/form_validations/form_validator.dart';
import 'package:city_customer_app/ui/views/change_password/change_password_view.form.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:city_customer_app/ui/widgets/common/validation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'change_password_viewmodel.dart';

@FormView(fields: [
  FormTextField(
    name: 'password',
    validator: FormFieldsValidator.validatePassword,
  ),
  FormTextField(
    name: 'new_password',
    validator: FormFieldsValidator.validatePassword,
  ),
  FormTextField(
    name: 'confirm_password',
  )
])
class ChangePasswordView extends StackedView<ChangePasswordViewModel>
    with $ChangePasswordView {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, ChangePasswordViewModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        appBar: AppBar(shadowColor: kcWhitColor),
        backgroundColor: kcWhitColor,
        body: SafeArea(
          child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 10.h),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Change Password",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400),
              ),
              30.verticalSpace,

              ///
              const Text("Old Password"),
              8.verticalSpace,
              CustomTextField(
                hintText: "**********",
                controller: passwordController,
                focusNode: passwordFocusNode,
                obscure: viewModel.oldPasswordHidden,
                prefix: const Icon(Icons.lock),
                noSpace: true,
                suffix: IconButton(
                  splashRadius: 10.r,
                  onPressed: () {
                    viewModel.toggleOldPassVisibility();
                  },
                  icon: Icon(
                    viewModel.oldPasswordHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: kSlateGrayColor,
                  ),
                ),
              ),
              // if (!viewModel.hasPassword)
              if (viewModel.hasPasswordValidationMessage)
                ValidationWidget(
                    message: viewModel.passwordValidationMessage ??
                        "Please enter old password"),
              10.verticalSpace,
              const Text("New Password"),
              8.verticalSpace,
              CustomTextField(
                hintText: "********",
                controller: newPasswordController,
                focusNode: newPasswordFocusNode,
                prefix: const Icon(Icons.lock),
                obscure: viewModel.newPasswordHidden,
                noSpace: true,
                suffix: IconButton(
                  splashRadius: 10.r,
                  onPressed: () {
                    viewModel.toggleNewPassVisibility();
                  },
                  icon: Icon(
                    viewModel.newPasswordHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: kSlateGrayColor,
                  ),
                ),
              ),
              // if (!viewModel.hasNewPassword)
              if (viewModel.hasNewPasswordValidationMessage)
                ValidationWidget(
                    message: viewModel.newPasswordValidationMessage ?? ""),
              10.verticalSpace,
              const Text("Confirm Password"),
              8.verticalSpace,
              CustomTextField(
                hintText: "********",
                controller: confirmPasswordController,
                focusNode: confirmPasswordFocusNode,
                prefix: const Icon(Icons.lock),
                obscure: viewModel.cPasswordHidden,
                noSpace: true,
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
              if (confirmPasswordController.text != newPasswordController.text)
                const ValidationWidget(
                    message:
                        "New password and confirm new password are not matching"),
              60.verticalSpace,

              ///
              CustomElevatedButton(
                  text: "Done",
                  onPressed: viewModel.hasPassword &&
                          viewModel.hasNewPassword &&
                          viewModel.hasConfirmPassword &&
                          viewModel.newPasswordValue ==
                              viewModel.confirmPasswordValue
                      ? () {
                          viewModel.buttonPressed();
                          if (viewModel.hasPassword &&
                              viewModel.hasNewPassword &&
                              viewModel.hasConfirmPassword &&
                              viewModel.newPasswordValue ==
                                  viewModel.confirmPasswordValue) {
                            viewModel.requestPasswordChange();
                          }
                        }
                      : null)
            ]),
          ),
          ),
          ),
        ),
    
    );
  }

  @override
  void onDispose(ChangePasswordViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }

  @override
  void onViewModelReady(ChangePasswordViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    super.onViewModelReady(viewModel);
  }

  @override
  ChangePasswordViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ChangePasswordViewModel();
}
