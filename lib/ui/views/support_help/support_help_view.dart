import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/views/support_help/support_help_view.form.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:city_customer_app/ui/widgets/common/validation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import '../../buttons/custom_elevated_button.dart';
import '../../common/app_colors.dart';
import '../../form_validations/form_validator.dart';
import 'support_help_viewmodel.dart';

@FormView(
  fields: [
    FormTextField(
      name: 'email',
      validator: FormFieldsValidator.validateEmailText,
    ),
    FormTextField(
      name: 'object',
      validator: FormFieldsValidator.validateFieldEmpty,
    ),
    FormTextField(
      name: 'message',
      validator: FormFieldsValidator.validateFieldEmpty,
    ),
  ],
)
class SupportHelpView extends StackedView<SupportHelpViewModel>
    with $SupportHelpView {
  const SupportHelpView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, SupportHelpViewModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        // appBar: AppBar(shadowColor: kcWhitColor),
        backgroundColor: kcWhitColor,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 20.0, right: 25.0),
            child: Column(children: [
              ///
              Container(
                height: 236.h,
                width: screenWidth(context),
                padding: EdgeInsets.symmetric(horizontal: 0.h, vertical: 40.h),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("$kcStaticImagesPath/sup.png"))),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          viewModel.back();
                        },
                        icon: const Icon(Icons.arrow_back))),
              ),

              8.verticalSpace,
              CustomTextField(
                hintText: "john@gmail.com",
                controller: emailController,
                focusNode: emailFocusNode,
                label: "Your Email",
                onChanged: (val) {
                  // viewModel.loginObj.email = val;
                },
              ),
              if (viewModel.isButtonPressed && !viewModel.hasEmail)
                ValidationWidget(
                  message: viewModel.emailValidationMessage ??
                      "This field is required",
                  // "S.of(getContext).fieldRequiredText",
                ),
              8.verticalSpace,
              8.verticalSpace,
              CustomTextField(
                hintText: "anything",
                controller: objectController,
                focusNode: objectFocusNode,
                label: "Object",
                onChanged: (val) {
                  // viewModel.loginObj.email = val;
                },
              ),
              if (viewModel.isButtonPressed && !viewModel.hasObject)
                ValidationWidget(
                  message: viewModel.emailValidationMessage ??
                      "This field is required",
                  // "S.of(getContext).fieldRequiredText",
                ),
              8.verticalSpace,
              CustomTextField(
                hintText: "Your message",
                controller: messageController,
                focusNode: messageFocusNode,
                maxLines: 13,
                // label: "Your message",
                onChanged: (val) {
                  // viewModel.loginObj.email = val;
                },
              ),
              if (viewModel.isButtonPressed && !viewModel.hasMessage)
                ValidationWidget(
                  message: viewModel.emailValidationMessage ??
                      "This field is required",
                  // "S.of(getContext).fieldRequiredText",
                ),

              40.verticalSpace,

              ///
              CustomElevatedButton(
                  text: "Send Message",
                  onPressed: () {
                    viewModel.isButtonPressed = true;
                    viewModel.rebuildUi();
                    if (viewModel.hasEmail &&
                        viewModel.hasObject &&
                        viewModel.hasMessage) {
                      viewModel.requestFeedback(context);
                    }
                  })
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void onDispose(SupportHelpViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }

  @override
  void onViewModelReady(SupportHelpViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    super.onViewModelReady(viewModel);
  }

  @override
  SupportHelpViewModel viewModelBuilder(BuildContext context) =>
      SupportHelpViewModel();
}
