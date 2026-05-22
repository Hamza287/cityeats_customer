// ignore_for_file: no_wildcard_variable_uses

import 'dart:io';

import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/form_validations/form_validator.dart';
import 'package:city_customer_app/ui/views/edit_profile/edit_profile_view.form.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import '../../widgets/common/cache_network_image.dart';
import 'edit_profile_viewmodel.dart';

@FormView(
  fields: [
    FormTextField(
      name: 'name',
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
  ],
)
class EditProfileView extends StackedView<EditProfileViewModel>
    with $EditProfileView {
  const EditProfileView({super.key});

  @override
  Widget builder(
      BuildContext context, EditProfileViewModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: kcWhitColor,
        ),
        backgroundColor: kcWhitColor,
        body: SafeArea(
          child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 15.h),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hey ${viewModel.user.name!.toUpperCase()}!",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 20.sp, fontWeight: FontWeight.w600),
                  ),
                  // CircleAvatar(
                  //   radius: 30.r,
                  //   foregroundImage:
                  //       const AssetImage("$kcStaticImagesPath/pro.jpg"),
                  // ),
                  Stack(clipBehavior: Clip.none, children: [
                    viewModel.imageFile != null
                        ? CircleAvatar(
                            radius:
                                30.r, // Adjust the size of the circle avatar
                            backgroundImage: FileImage(File(
                                viewModel.imageFile?.path ??
                                    "")), // Replace with the actual file path
                          )
                        : NetworkImageWidget(
                            url: viewModel.user.image ?? "",
                            isProfilePic: true,
                            radius: 30.r,
                          ),
                    Positioned(
                      bottom: -8,
                      left: -6,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: kcGreyColor,
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showBottomSheet(context, viewModel);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: kcBlackColor,
                              size: 17,
                            )),
                      ),
                    )
                  ]),
                ],
              ),
              20.verticalSpace,

              ///
              const Text("Name"),
              8.verticalSpace,
              CustomTextField(
                hintText: "john adam",
                controller: nameController,
                focusNode: nameFocusNode,
                prefix: const Icon(Icons.person),
                textCapitalization: TextCapitalization.words,
                // label: "Name",
                onChanged: (val) {
                  viewModel.updateProfileBody.name = val;
                },
              ),
              10.verticalSpace,
              const Text("Email"),
              8.verticalSpace,
              CustomTextField(
                hintText: "john@gmail.com",
                controller: emailController,
                focusNode: emailFocusNode,
                textCapitalization: TextCapitalization.words,
                readOnly: true,
                prefix: const Icon(Icons.mail),
                // label: "Email",
                onChanged: (val) {
                  // viewModel.loginObj.email = val;
                },
              ),
              10.verticalSpace,
              const Text("Phone"),
              8.verticalSpace,
              CustomTextField(
                hintText: "03129098809",
                controller: phoneController,
                focusNode: phoneFocusNode,
                prefix: const Icon(Icons.phone),
                // label: "Phone",
                onChanged: (val) {
                  viewModel.updateProfileBody.phone = val;
                },
              ),
              10.verticalSpace,
              const Text("Password"),
              8.verticalSpace,
              CustomTextField(
                enabled: false,
                hintText: "***********",
                controller: passwordController,
                focusNode: passwordFocusNode,
                obscure: true,
                prefix: const Icon(Icons.lock),
                // label: "Password",
                onChanged: (val) {},
              ),

              ///
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      viewModel.navigateToChangePassword();
                    },
                    child: Text(
                      "Change password",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: kcPrimaryColor, fontSize: 14.sp),
                    )),
              ),
              60.verticalSpace,

              ///
              CustomElevatedButton(
                  text: "Done",
                  onPressed: () {
                    //
                    viewModel.updateProfile(context);
                  })
            ]),
          ),
          ),
        ),
      ),
    );
  }

  showBottomSheet(_, EditProfileViewModel model) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      // ignore: duplicate_ignore
      // ignore: no_wildcard_variable_uses
      context: _,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 30.h),
          ListTile(
            onTap: () {
              model.getImageFromGallery(_);
            },
            title: Text(
              "Gallery",
              style: Theme.of(_).textTheme.bodyMedium,
            ),
            leading: const Icon(Icons.image),
          ),
          const Divider(height: 0),
          ListTile(
            onTap: () {
              model.getImageFromCamera(_);
            },
            title: Text("Camera", style: Theme.of(_).textTheme.bodyMedium),
            leading: const Icon(Icons.camera),
          ),
        ],
      ),
    );
  }

  @override
  void onDispose(EditProfileViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }

  @override
  void onViewModelReady(EditProfileViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    viewModel.initData();
    super.onViewModelReady(viewModel);
  }

  @override
  EditProfileViewModel viewModelBuilder(BuildContext context) =>
      EditProfileViewModel();
}
