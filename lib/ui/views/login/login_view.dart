import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/form_validations/form_validator.dart';
import 'package:city_customer_app/ui/views/login/login_view.form.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:city_customer_app/ui/widgets/common/validation_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_viewmodel.dart';

@FormView(fields: [
  FormTextField(
    name: 'login_email',
    validator: FormFieldsValidator.validateEmailText,
  ),
  FormTextField(
      name: 'login_password',
      validator: FormFieldsValidator.validateFieldEmpty),
 
])
class LoginView extends StackedView<LoginViewModel> with $LoginView {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, LoginViewModel viewModel, Widget? child) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to guest mode when back button is pressed
        viewModel.navigateToGuestMode();
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              viewModel.navigateToGuestMode();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 50.verticalSpace,
                // const Align(alignment: Alignment.center, child: AppLogo()),
                Center(
                  child: Image.asset("assets/images/static/W1.png",
                      height: 170.h, width: 170.w),
                ),
                60.verticalSpace,
                const Text("Email"),
                8.verticalSpace,
                CustomTextField(
                  hintText: "john@gmail.com",
                  controller: loginEmailController,
                  focusNode: loginEmailFocusNode,
                  prefix: const Icon(Icons.mail),
                  textInputType: TextInputType.emailAddress,
                  noSpace: true,
                  label: "Email",
                  onChanged: (val) {
                    viewModel.loginObj.email = val?.trim() ?? "";
                  },
                ),
                if (viewModel.isLoginPressed &&
                    loginEmailController.text.isEmpty)
                  const ValidationWidget(
                    message: "This field is required",
                    // "S.of(getContext).fieldRequiredText",
                  ),
                10.verticalSpace,
                const Text("Password"),
                8.verticalSpace,
                CustomTextField(
                  hintText: "***********",
                  obscure: viewModel.passwordHidden,
                  prefix: const Icon(Icons.lock),
                  controller: loginPasswordController,
                  focusNode: loginPasswordFocusNode,
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
                  label: "Password",
                  noSpace: true,
                  onChanged: (val) {
                    viewModel.loginObj.password = val?.trim() ?? "";
                  },
                ),
                if (viewModel.isLoginPressed &&
                    loginPasswordController.text.isEmpty)
                  const ValidationWidget(
                    message: "This field is required",
                    // "S.of(getContext).fieldRequiredText",
                  ),
                10.verticalSpace,
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        ///forgot screen
                        viewModel.navigateToForgot();
                        // disposeForm();
                      },
                      child: Text(
                        "Forgot Password?",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: kcPrimaryColor),
                      )),
                ),
                25.verticalSpace,
                buildClickableText(context),
                10.verticalSpace,
                CustomElevatedButton(
                  text: "Login",
                  onPressed: () async {
                    ///login function
                    viewModel.onLoginPressed();
                    if (viewModel.isFormValid &&
                        loginEmailController.text.isNotEmpty &&
                        loginPasswordController.text.isNotEmpty) {
                      await viewModel.loginWithEmailAndPassword();
                    }
                  },
                ),
                12.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New to City Eat? ",
                        style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: () {
                         viewModel.navigateToSignUp();
                      },
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      child: Text(
                        "Register here",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: kcPrimaryColor,
                            ),
                      ),
                    ),
                  ],
                ),
                if (!viewModel.isFormValid) 30.verticalSpace,
              ],
            ),
          ),
          ),
        ),
      ),
    ));
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
                launchURL('https://city-eats.co.uk/terms-and-conditions');
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
                launchURL('https://city-eats.co.uk/privacy-policy');
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

  @override
  LoginViewModel viewModelBuilder(BuildContext context) =>
      LoginViewModel(context);

  @override
  void onViewModelReady(LoginViewModel viewModel) {
     viewModel.clearForm();
    // Clear text controllers
    loginEmailController.clear();
    loginPasswordController.clear();
  }
}
