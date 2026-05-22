import 'package:city_customer_app/enums/address_lable.dart';
import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:city_customer_app/ui/widgets/common/validation_widget.dart';
import 'package:flutter/material.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'map_address_sheet_model.dart';

class MapAddressSheet extends StackedView<MapAddressSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;
  const MapAddressSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget builder(
      BuildContext context, MapAddressSheetModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Container(
        // height: 540.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Save this Address ",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900),
              ),
              10.verticalSpace,
              CustomTextField(
                hintText: "Door / Building Number",
                controller: viewModel.buildingController,
                onChanged: (val) {
                  viewModel.locationBody?.name = val;
                },
              ),
              2.verticalSpace,
              if (viewModel.isTapped &&
                  viewModel.buildingController.text.isEmpty)
                const ValidationWidget(message: "This field is required"),
              5.verticalSpace,
              CustomTextField(
                hintText: "Street Address",
                controller: viewModel.streetController,
                onChanged: (val) {
                  viewModel.locationBody?.streetAddress = val;
                },
              ),
              2.verticalSpace,
              if (viewModel.isTapped && viewModel.streetController.text.isEmpty)
                const ValidationWidget(message: "This field is required"),
              5.verticalSpace,
              CustomTextField(
                hintText: "Zip code/Postcode",
                controller: viewModel.zipcodeController,
                onChanged: (val) {
                  viewModel.locationBody?.postalCode = val;
                },
              ),
              2.verticalSpace,
              if (viewModel.isTapped &&
                  viewModel.zipcodeController.text.isEmpty)
                const ValidationWidget(message: "This field is required"),
              5.verticalSpace,
              const Text(
                "Add a label",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              10.verticalSpace,
              Row(
                children: [
                  _labelWidget(context, Icons.home, "Home", viewModel,
                      labelType: AddressLabel.home),
                  20.horizontalSpace,
                  _labelWidget(context, Icons.home, "Office", viewModel,
                      labelType: AddressLabel.office),
                  20.horizontalSpace,
                  _labelWidget(context, Icons.home, "Other", viewModel,
                      labelType: AddressLabel.other),
                ],
              ),
              if (viewModel.label == AddressLabel.other) ...[
                20.verticalSpace,
                CustomTextField(
                  hintText: "Type here",
                  controller: TextEditingController(),
                  onChanged: (val) {
                    viewModel.locationBody?.label = val;
                  },
                ),
              ],
              30.verticalSpace,
              CustomElevatedButton(
                  text: "Save Location",
                  onPressed: () {
                    viewModel.onTapped();
                    if (viewModel.locationBody?.name != "" &&
                        viewModel.locationBody?.streetAddress != "" &&
                        viewModel.locationBody?.postalCode != "" &&
                        viewModel.locationBody?.postalCode != null) {
                      viewModel.requestConfirmLocation(context);
                    }
                  }
                  // viewModel.locationBody == null
                  //     ? null
                  //     : () {
                  //         ///
                  //         // viewModel.navigateToBack();

                  //       }
                  )
            ],
          ),
        ),
      ),
    );
  }

  _labelWidget(context, icon, title, MapAddressSheetModel viewModel,
      {required AddressLabel labelType}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        viewModel.toggleLabel(labelType);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 64.h,
            width: 64.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                    color: viewModel.label == labelType
                        ? kcPrimaryColor
                        : kSlateGrayColor)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon,
                  color: viewModel.label == labelType
                      ? kcPrimaryColor
                      : kSlateGrayColor),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    color: viewModel.label == labelType
                        ? kcPrimaryColor
                        : kSlateGrayColor),
              )
            ]),
          ),
          if (viewModel.label == labelType)
            Positioned(
              right: -4,
              top: -3,
              child: CircleAvatar(
                radius: 8.r,
                backgroundColor: kcPrimaryColor,
                child: const Icon(
                  Icons.check,
                  size: 10,
                  color: kcWhitColor,
                ),
              ),
            )
        ],
      ),
    );
  }

  @override
  MapAddressSheetModel viewModelBuilder(BuildContext context) =>
      MapAddressSheetModel(request);
}
