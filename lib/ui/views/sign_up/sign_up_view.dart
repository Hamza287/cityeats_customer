import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/form_validations/form_validator.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:city_customer_app/ui/widgets/common/phone_text_field.dart';
import 'package:city_customer_app/ui/widgets/common/validation_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'sign_up_view.form.dart';
import 'sign_up_viewmodel.dart';

@FormView(
  fields: [
    FormTextField(
      name: 'first_name',
      validator: FormFieldsValidator.validateNameText,
    ),
    FormTextField(
      name: 'last_name',
      validator: FormFieldsValidator.validateNameText,
    ),
    FormTextField(
      name: 'email',
      validator: FormFieldsValidator.validateEmailText,
    ),
    FormTextField(
      name: 'phone',
      validator: FormFieldsValidator.validatePhoneNumber,
    ),
    FormTextField(
      name: 'password',
      validator: FormFieldsValidator.validatePassword,
    ),
    FormTextField(
      name: 'c_password',
      validator: FormFieldsValidator.validatePassword,
    ),
  ],
)
class SignUpView extends StackedView<SignUpViewModel> with $SignUpView {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, SignUpViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            viewModel.navigateBack();
          },
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: CustomProgressIndicator(
          isLoading: viewModel.isBusy,
          child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               

                  _header(context),

                  40.verticalSpace,

                  ///
                  _inputFIelds(viewModel),

                  //
                  10.verticalSpace,

                  ///
                  /// terms and conditions plus privacy privacy
                  ///
                  buildClickableText(context),

                  ///
                  20.verticalSpace,

                  ///
                  _signUpButton(viewModel),
                  10.verticalSpace,
                  _alreadyOnMyAce(context, viewModel),
                ],
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget buildClickableText(context) {
    return RichText(
      text: TextSpan(
        text: 'I agree to accept the ',
        style: Theme.of(context).textTheme.bodySmall,
        children: <TextSpan>[
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchURL('https://www.example.com/terms');
              },
            text: "Terms & Conditions",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                decoration: TextDecoration.underline, color: kcPrimaryColor),
          ),

          TextSpan(
            text: " and ",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          // ignore: prefer_const_constructors
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchURL('https://www.example.com/terms');
              },
            text: 'privacy policy.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                decoration: TextDecoration.underline, color: kcPrimaryColor),
          ),
        ],
      ),
    );
  }

  void launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Column _inputFIelds(SignUpViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///FIRST AND LAST NAME
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("First Name"),
                  8.verticalSpace,
                  CustomTextField(
                    hintText: "John",
                    prefix: const Icon(Icons.person),
                    maxLength: 100,
                    controller: firstNameController,
                    focusNode: firstNameFocusNode,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (val) {
                      viewModel.signUpBody.fName = val;
                    },
                  ),
                ],
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Last Name"),
                  8.verticalSpace,
                  CustomTextField(
                    hintText: "Adam",
                    prefix: const Icon(Icons.person),
                    maxLength: 100,
                    controller: lastNameController,
                    focusNode: lastNameFocusNode,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (val) {
                      viewModel.signUpBody.lName = val;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        10.verticalSpace,
        if (viewModel.hasFirstNameValidationMessage ||
            viewModel.isSignUpPressed && !viewModel.hasFirstName)
          ValidationWidget(
            message: viewModel.firstNameValidationMessage ??
                "This field is required",
            // "S.of(getContext).fieldRequiredText",
          ),
        8.verticalSpace,

        ///EMAIL
        const Text("Email"),
        8.verticalSpace,
        CustomTextField(
          hintText: "john@gmail.com",
          textInputType: TextInputType.emailAddress,
          controller: emailController,
          prefix: const Icon(Icons.mail),
          focusNode: emailFocusNode,
          noSpace: true,
          onChanged: (val) {
            viewModel.signUpBody.email = val?.trim();
          },
        ),
        5.verticalSpace,

        if (viewModel.hasEmailValidationMessage ||
            viewModel.isSignUpPressed && !viewModel.hasEmail)
          ValidationWidget(
            message:
                viewModel.emailValidationMessage ?? "This field is required",
            // "S.of(getContext).fieldRequiredText",
          ),
        10.verticalSpace,

        ///PHONE
        const Text("Phone"),
        8.verticalSpace,
        InputPhoneNumberField(
          disableLengthCheck:
              viewModel.signUpBody.countryCode == "+44" ? true : false,
          controller: phoneController,
          onCodeChange: (code) {
            viewModel.signUpBody.countryCode = "+${code.dialCode}";
          },
          onChanged: (phone) {
            viewModel.signUpBody.phone = phone.number;
            viewModel.signUpBody.countryCode = phone.countryCode;
            // model.checkingTextFields();
            // model.authService.signUpBody.mobile = phone.number;
            // model.authService.signUpBody.completePhone = phone.completeNumber;
          },
        ),
        // CustomTextField(
        //   hintText: "+92345890876",
        //   controller: phoneController,
        //   focusNode: phoneFocusNode,
        //   prefix: const Icon(Icons.phone_android),
        //   onChanged: (val) {
        //     viewModel.signUpBody.phone = val;
        //   },
        // ),
        // 5.verticalSpace,
        // if (viewModel.hasPhoneValidationMessage ||
        //     viewModel.isSignUpPressed && !viewModel.hasPhone)
        //   ValidationWidget(
        //     message:
        //         viewModel.phoneValidationMessage ?? "This field is required",
        //     // "S.of(getContext).fieldRequiredText",
        //   ),
        10.verticalSpace,

        ///PASSWORD
        const Text("Create Password"),
        8.verticalSpace,
        CustomTextField(
          hintText: "***********",
          obscure: viewModel.passwordHidden,
          controller: passwordController,
          prefix: const Icon(Icons.lock),
          focusNode: passwordFocusNode,
          // textInputType: TextInputType.name,
          noSpace: true,
          onChanged: (val) {
            viewModel.signUpBody.password = val?.trim();
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
        5.verticalSpace,
        if (viewModel.hasPasswordValidationMessage ||
            viewModel.isSignUpPressed && !viewModel.hasPassword)
          ValidationWidget(
            message:
                viewModel.passwordValidationMessage ?? "This field is required",
            // "S.of(getContext).fieldRequiredText",
          ),
        10.verticalSpace,

        ///CONFIRM PASSWORD
        const Text("Confirm Password"),
        8.verticalSpace,
        CustomTextField(
          hintText: "***********",
          obscure: viewModel.cPasswordHidden,
          prefix: const Icon(Icons.lock),
          controller: cPasswordController,
          focusNode: cPasswordFocusNode,
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

        5.verticalSpace,
        if (viewModel.isSignUpPressed &&
            passwordController.text != cPasswordController.text)
          const ValidationWidget(
            message: "Password and confirm password are not matching",
            // "S.of(getContext).fieldRequiredText",
          ),
      ],
    );
  }

  Row _alreadyOnMyAce(BuildContext context, SignUpViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account? ",
            style: Theme.of(context).textTheme.bodyMedium),
        TextButton(
          onPressed: viewModel.navigateToLogin,
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          child: Text(
            "Login here",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  // fontWeight: FontWeight.w800,
                  color: kcPrimaryColor,
                ),
          ),
        ),
      ],
    );
  }

  CustomElevatedButton _signUpButton(SignUpViewModel viewModel) {
    return CustomElevatedButton(
      text: "Create My account",
      onPressed: () {
        viewModel.onSignUpPressed();
        if (viewModel.isFormValid &&
            viewModel.hasEmail &&
            viewModel.hasFirstName &&
            viewModel.hasPassword &&
            viewModel.hasPhone &&
            viewModel.hasPassword &&
            viewModel.passwordValue == viewModel.cPasswordValue) {
          viewModel.requestSignUp();
        }
      },
    );
  }

  Align _header(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        "Create An Account",
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  void onViewModelReady(SignUpViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    super.onViewModelReady(viewModel);
  }

  @override
  void onDispose(SignUpViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }

  @override
  SignUpViewModel viewModelBuilder(BuildContext context) =>
      SignUpViewModel(context);
}
