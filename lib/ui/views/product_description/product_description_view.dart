import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/form_validations/form_validator.dart';
import 'package:city_customer_app/ui/views/product_description/modifiers_products.dart';
import 'package:city_customer_app/ui/views/product_description/product_description_view.form.dart';
import 'package:city_customer_app/ui/widgets/common/cache_network_image.dart';
import 'package:city_customer_app/ui/widgets/common/cart_icon_widget.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:city_customer_app/ui/widgets/common/phone_text_field.dart';
import 'package:city_customer_app/ui/widgets/common/validation_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_shared/stacked_shared.dart';
import 'package:url_launcher/url_launcher.dart';

import 'product_description_viewmodel.dart';

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
  ],
)
class ProductDescriptionView extends StackedView<ProductDescriptionViewModel>
    with $ProductDescriptionView {
  const ProductDescriptionView(
      {Key? key,
      // this.food = Foods(),
      required this.restaurantId,
      this.foodId = 0,
      this.isNavigatedFromBanner = false})
      : super(key: key);
  // final Foods food;
  final int foodId;
  final int restaurantId;
  final bool isNavigatedFromBanner;

  @override
  Widget builder(BuildContext context, ProductDescriptionViewModel viewModel,
      Widget? child) {
    // viewModel.log.wtf(food.toJson());
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: WillPopScope(
        onWillPop: () async {
          if (isNavigatedFromBanner) {
            await viewModel.getSingleResturant();
            viewModel.navigateToRestaurantDetail(context);
            return false; // prevent default pop
          }
          return true; // allow normal pop
        },
        child: Scaffold(
          body: SafeArea(
            child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topBar(context, viewModel),
                    _detailPriceQuantity(context, viewModel),
                    const SizedBox(height: 12),
                    if (viewModel.food.modifiers?.isNotEmpty ?? false)
                      modifierSection(context, viewModel),

                    // if (food.variants?.isNotEmpty ?? false)
                    //   _chooseFlavours(context, viewModel),
                    // const SizedBox(height: 12),
                    // if (food.sideItems?.isNotEmpty ?? false)
                    //   _chooseSideItem(context, viewModel),

                    SizedBox(height: 500.h),
                    // Add bottom padding to prevent content from being hidden behind the button
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 80.h),
                  ],
                ),
              ),
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 15,
                  left: 0,
                  right: 0,
                  child: _addToCartButton(context, viewModel)),
              if (viewModel.isButtonPressed && !viewModel.isCartHasItem)
                Positioned(
                    height: 1.sh,
                    width: 1.sw,
                    child: guestDeliveryDetails(context, viewModel)),
            ],
          ),
            ),
        ),
      ),
    );
  }

  guestDeliveryDetails(
      BuildContext context, ProductDescriptionViewModel viewModel) {
    return Form(
        key: viewModel.formKey,
        child: Container(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.h),
          color: kcWhitColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildHeader(context),

              20.verticalSpace,
              _buildNameField(viewModel),

              // Email field
              10.verticalSpace,
              _buildEmailField(viewModel),

              //phone Field
              10.verticalSpace,
              _buildPhoneField(viewModel),

              //Address Field
              _buildAddressField(viewModel),

              40.verticalSpace,
              buildClickableText(context),

              10.verticalSpace,

              CustomElevatedButton(
                  text: "Proceed",
                  onPressed: () async {
                    viewModel.onTapped();

                    if (viewModel.isFormValid &&
                        viewModel.locationController.text.isNotEmpty &&
                        viewModel.formKey.currentState!.validate() &&
                        viewModel.hasEmail &&
                        viewModel.hasName) {
                      await viewModel.getUserInfo(context);
                    }
                  }),
              SizedBox(
                height: 500.h,
              ),
            ]),
          ),
        ));
  }

  Text _buildHeader(BuildContext context) {
    return Text(
      " VERIFY DELIVERY DETAILS",
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildNameField(ProductDescriptionViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Name",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        8.verticalSpace,
        CustomTextField(
          hintText: "john adam",
          controller: nameController,
          focusNode: nameFocusNode,
          prefix: const Icon(
            Icons.person,
            color: Colors.black12,
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: (val) {
            viewModel.body.name = val;
          },
        ),
        if (viewModel.isTapped && viewModel.hasNameValidationMessage)
          ValidationWidget(message: viewModel.nameValidationMessage.toString()),
        if (viewModel.isTapped && !viewModel.hasName)
          const ValidationWidget(message: "This field is required"),
      ],
    );
  }

  Widget _buildEmailField(ProductDescriptionViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        8.verticalSpace,
        CustomTextField(
          hintText: "john@gmail.com",
          controller: emailController,
          focusNode: emailFocusNode,
          textInputType: TextInputType.emailAddress,
          prefix: const Icon(
            Icons.mail,
            color: Colors.black12,
          ),
          onChanged: (val) {
            viewModel.body.email = val;
          },
        ),
        if (viewModel.isTapped && viewModel.hasEmailValidationMessage)
          ValidationWidget(
              message: viewModel.emailValidationMessage.toString()),
        if (viewModel.isTapped && !viewModel.hasEmail)
          const ValidationWidget(message: "This field is required"),
      ],
    );
  }

  Widget _buildPhoneField(ProductDescriptionViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Phone",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        8.verticalSpace,
        InputPhoneNumberField(
          disableLengthCheck:
              viewModel.body.countryCode == "+44" ? true : false,
          controller: phoneController,
          focusNode: phoneFocusNode,
          onCodeChange: (code) {
            viewModel.body.countryCode = "+${code.dialCode}";
          },
          onChanged: (val) {
            viewModel.body.phone = val.number;
            viewModel.body.countryCode = val.countryCode;
          },
        ),
        if (viewModel.isTapped && !viewModel.hasPhone)
          const ValidationWidget(message: "This field is required"),
      ],
    );
  }

  Widget _buildAddressField(ProductDescriptionViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Address",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        8.verticalSpace,
        CustomTextField(
          hintText: "Building/ Apt",
          readOnly: true,
          controller: viewModel.locationController,
          // focusNode: addressFocusNode,
          textCapitalization: TextCapitalization.words,
          prefix: const Icon(
            Icons.location_on,
            color: Colors.black12,
          ),
          onTap: () {
            viewModel.navigateToAddressScreen();
          },
        ),
        if (viewModel.isTapped && viewModel.locationController.text.isEmpty)
          const ValidationWidget(message: "This field is required"),
      ],
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

  Padding _addToCartButton(
      BuildContext context, ProductDescriptionViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: CustomElevatedButton(
        size: Size(374.w, 48.h),
        text: "",
        child: Row(children: [
          const Icon(Icons.shopping_basket, color: kcWhiteColor),
          10.horizontalSpace,
          Text(
            "Add to Cart",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const Spacer(),
          Text(
            "£ ${(viewModel.toTalPrice - (getTotalDisocunt(viewModel.food.percentDiscount ?? 0, viewModel.toTalPrice))).toStringAsFixed(2)}",
            // "£${viewModel.toTalPrice.toStringAsFixed(2)}",
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ]),
        onPressed: viewModel.isBusy
            ? null
            : () {
                viewModel.log.d("isUserLogin: ${locator<AuthService>().isLogin}");
                if (viewModel.addTocartValidation(context)) {
                  if (viewModel.food.ageRestricted == 0) {
                    if (locator<AuthService>().isLogin) {
                      viewModel.addToCart(context);
                    } else {
                      viewModel.onPressed();
                    }
                  } else {
                    viewModel.showAgeRestrictionDialog(context);
                  }
                }

                //
              },
      ),
    );
  }

  // Container _chooseSideItem(
  //     BuildContext context, ProductDescriptionViewModel viewModel) {
  //   return Container(
  //     width: screenWidth(context),
  //     padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
  //     color: kcWhiteColor,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         if (food.sideItems?.isNotEmpty ?? false)
  //           Text(
  //             "Choose your side",
  //             style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //                   fontSize: 16.sp,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //           ),
  //         SingleChildScrollView(
  //           child: ListView.separated(
  //             shrinkWrap: true,
  //             padding: EdgeInsets.zero,
  //             physics: const NeverScrollableScrollPhysics(),
  //             itemCount: food.sideItems?.length ?? 0,
  //             itemBuilder: (context, index) => Row(
  //               children: [
  //                 Text(
  //                   food.sideItems?[index].name ?? "",
  //                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                         fontSize: 12.sp,
  //                       ),
  //                 ),
  //                 const Spacer(),
  //                 Text(
  //                   "£ ${food.sideItems?[index].price ?? ""}",
  //                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                         fontSize: 12.sp,
  //                       ),
  //                 ),
  //                 Checkbox(
  //                   value: viewModel.selectedSideItems
  //                       .contains(food.sideItems?[index]),
  //                   visualDensity: const VisualDensity(vertical: -4),
  //                   onChanged: (val) {
  //                     viewModel.addSideItem(food.sideItems![index]);
  //                   },
  //                   activeColor: kcPrimaryColor,
  //                 )
  //               ],
  //             ),
  //             separatorBuilder: (context, index) => 2.verticalSpace,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // choose size/flavours
  // Container _chooseFlavours(
  //     BuildContext context, ProductDescriptionViewModel viewModel) {
  //   return Container(
  //     width: screenWidth(context),
  //     padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
  //     color: kcWhiteColor,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         if (food.variants?.isNotEmpty ?? false)
  //           Text(
  //             "Choose your size",
  //             style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //                   fontSize: 16.sp,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //           ),

  //         //
  //         SingleChildScrollView(
  //           child: ListView.separated(
  //             shrinkWrap: true,
  //             padding: EdgeInsets.zero,
  //             physics: const NeverScrollableScrollPhysics(),
  //             itemCount: food.variants!.length,
  //             itemBuilder: (context, index) {
  //               final variant = food.variants![index];
  //               return Row(
  //                 children: [
  //                   Text(
  //                     variant.variant ?? '',
  //                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                           fontSize: 12.sp,
  //                         ),
  //                   ),
  //                   const Spacer(),
  //                   Text(
  //                     "£ ${variant.price ?? ""}",
  //                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                           fontSize: 12.sp,
  //                         ),
  //                   ),
  //                   if (variant.variant != null && variant.price != null)
  //                     Radio(
  //                       value: variant,
  //                       groupValue:
  //                           viewModel.selectedVariants ?? food.variants?[0],
  //                       onChanged: (selectedVariant) {
  //                         viewModel.selectedVariants = selectedVariant;

  //                         food.price =
  //                             viewModel.selectedVariants?.price.toString();
  //                         viewModel.addItemVariants(
  //                             viewModel.selectedVariants != null
  //                                 ? selectedVariant!
  //                                 : food.variants![0]);
  //                       },
  //                       activeColor: kcPrimaryColor,
  //                     ),
  //                 ],
  //               );
  //             },
  //             separatorBuilder: (context, index) => 2.verticalSpace,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  modifierSection(BuildContext context, ProductDescriptionViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: ModifiersProductsArea(modifiers: viewModel.food.modifiers ?? []),
    );
    //
  }

  Container _detailPriceQuantity(
      BuildContext context, ProductDescriptionViewModel viewModel) {
    Foods food = viewModel.food;
    return Container(
      color: kcWhiteColor,
      padding: EdgeInsets.all(20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                viewModel.food.name ?? "",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (viewModel.food.percentDiscount != 0)
                Container(
                  width: 100.w,
                  height: 25.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Color.fromARGB(255, 247, 181, 15)),
                  child: Text(
                    " Get  £${(getTotalDisocunt(viewModel.food.percentDiscount ?? 0, viewModel.toTalPrice)).toStringAsFixed(2)} off! 🎉 ",
                    style: TextStyle(
                        color: kPureBlackColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          8.verticalSpace,
          Padding(
            padding: EdgeInsets.only(right: 25.w),
            child: Text(
              food.description ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 11.sp),
            ),
          ),
          6.verticalSpace,
          Row(
            children: [
              if (viewModel.discountApplicable(food.percentDiscount ?? 0)) ...[
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: " £ ${viewModel.toTalPrice.toStringAsFixed(2)}  ",
                    // "£ ${viewModel.selectedVariants?.price ?? food.variants![0].price}  ",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: kcGreyColor,
                          decorationColor: kcLightGrey,
                          decorationThickness: 1.5,
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                  TextSpan(
                    text:
                        "£ ${(viewModel.toTalPrice - (getTotalDisocunt(food.percentDiscount ?? 0, viewModel.toTalPrice))).toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: kcBlackColor),
                  )
                ]))
              ] else ...[
                // }
                Text(
                  "£ ${viewModel.toTalPrice.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
              const Spacer(),
              InkWell(
                onTap: () {
                  viewModel.decrementQuantity();
                },
                child: CircleAvatar(
                  radius: 17.r,
                  backgroundColor: kcPrimaryColor,
                  child:
                      const Icon(Icons.remove, color: kcWhiteColor, size: 15),
                ),
              ),
              13.horizontalSpace,
              Text(
                "${viewModel.itemQuantity}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              13.horizontalSpace,
              InkWell(
                onTap: () {
                  viewModel.incrementQuantity();
                },
                child: CircleAvatar(
                  radius: 17.r,
                  backgroundColor: kcPrimaryColor,
                  child: const Icon(Icons.add, color: kcWhiteColor, size: 15),
                ),
              ),
              10.horizontalSpace,
            ],
          ),
        ],
      ),
    );
  }

  getTotalDisocunt(double percentDiscount, double amount) {
    double totalDiscount = (amount * (percentDiscount / 100));
    return totalDiscount;
  }

  Stack _topBar(BuildContext context, ProductDescriptionViewModel viewModel) {
    return Stack(
      children: [
        SizedBox(
          height: 210.h,
          width: screenWidth(context),
          child: NetworkImageWidget(url: viewModel.food.image ?? ""),
        ),
        Positioned(
            right: 20.w,
            top: 20.h,
            child: CartIconWidget(
              onTap: () {
                viewModel.navigateToCartView();
              },
            )),
        Positioned(
            left: 20.w,
            top: 20.h,
            child: InkWell(
              splashColor: Colors.blue, // Customize splash color
              onTap: () {
                if (isNavigatedFromBanner) {
                  viewModel.navigateToRestaurantDetail(context);
                  // prevent default pop
                } else {
                  viewModel.goBack();
                }
              },
              child: const CircleAvatar(
                backgroundColor: kcWhitColor,
                child: Icon(
                  Icons.arrow_back,
                  color: kcBlackColor,
                ),
              ),
            )),
      ],
    );
  }

  // @override
  // void onViewModelReady(ProductDescriptionViewModel viewModel) {
  //   syncFormWithViewModel(viewModel);
  //   super.onViewModelReady(viewModel);
  // }

  @override
  void onViewModelReady(ProductDescriptionViewModel viewModel) {
    viewModel.init();
    syncFormWithViewModel(viewModel);
    super.onViewModelReady(viewModel);
  }

  @override
  void onDispose(ProductDescriptionViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }

  @override
  ProductDescriptionViewModel viewModelBuilder(BuildContext context) =>
      ProductDescriptionViewModel(restaurantId, foodId);
}
