import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:stacked/stacked.dart';
import 'filter_viewmodel.dart';

class FilterView extends StackedView<FilterViewModel> {
  const FilterView({super.key});

  @override
  Widget builder(
      BuildContext context, FilterViewModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        backgroundColor: kcLightGreyColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              viewModel.navigateToHomeBack();
            },
          ),
          shadowColor: kcWhiteColor,
          title: Text(
            "Filter",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
          child: Column(children: [
            filterContainer(context, viewModel),
            35.verticalSpace,

            const Spacer(),

            ///
            CustomElevatedButton(
              text: "Apply",
              onPressed: () {
                viewModel.filter();
              },
            ),
            50.verticalSpace,
          ]),
        ),
      ),
    );
  }

  Container filterContainer(BuildContext context, FilterViewModel viewModel) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: kcWhitColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cuisines",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          10.verticalSpace,
          DynamicDropDown(
            viewModel: viewModel,
            onChange: (val) {
              ///
              viewModel.filterBody.category = val ?? "";
            },
          ),

          ///
          20.verticalSpace,
          Text(
            "Distance",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          10.verticalSpace,
          CustomTextField(
            hintText: 'Distance in km',
            onChanged: (val) {
              viewModel.filterBody.maxDistance = double.parse(val ?? "0");
            },
            textInputType: TextInputType.number,
          ),

          20.verticalSpace,
          Text(
            "Ratings",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          15.verticalSpace,

          _ratingSlider(viewModel),

          20.verticalSpace,
          Text(
            "Price Range",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          10.verticalSpace,

          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hintText: 'Min',
                  onChanged: (val) {
                    viewModel.filterBody.minPrice = double.parse(val ?? "0");
                  },
                  textInputType: TextInputType.number,
                ),
              ),
              20.horizontalSpace,
              Expanded(
                child: CustomTextField(
                  hintText: 'Max',
                  onChanged: (val) {
                    viewModel.filterBody.maxPrice = double.parse(val ?? "0");
                  },
                  textInputType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _ratingSlider(FilterViewModel viewModel) {
    return FlutterSlider(
      min: 0,
      max: 5,
      rangeSlider: true,
      step: const FlutterSliderStep(step: 1),
      handler: FlutterSliderHandler(
        decoration: const BoxDecoration(),
        child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: kcPrimaryColor),
            padding: const EdgeInsets.all(5),
            child: const Icon(Icons.arrow_back_ios_new,
                size: 20, color: kcWhiteColor)),
      ),
      rightHandler: FlutterSliderHandler(
        decoration: const BoxDecoration(),
        child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: kcPrimaryColor),
            padding: const EdgeInsets.all(5),
            child: const Icon(Icons.arrow_forward_ios_rounded,
                size: 20, color: kcWhiteColor)),
      ),
      tooltip: FlutterSliderTooltip(
        alwaysShowTooltip: true,
        textStyle: TextStyle(color: kcBlackColor, fontSize: 10.sp),
        positionOffset: FlutterSliderTooltipPositionOffset(top: -15),
        boxStyle: FlutterSliderTooltipBox(
          decoration: BoxDecoration(
            color: kcGreyColor,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      values: [viewModel.lowerRatingValue, viewModel.upperRatingValue],
      onDragging: (handlerIndex, lowerValue, upperValue) {
        viewModel.updateRating(lowerValue, upperValue);
      },
    );
  }

  @override
  FilterViewModel viewModelBuilder(BuildContext context) => FilterViewModel();
}

// ignore: must_be_immutable
class DynamicDropDown extends StatelessWidget {
  const DynamicDropDown({super.key, this.onChange, required this.viewModel});

  final FilterViewModel viewModel;
  final void Function(String?)? onChange;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      // value: genders.first.type,
      elevation: 2,
      hint:
          Text("Select Cuisine", style: Theme.of(context).textTheme.bodyMedium),
      borderRadius: BorderRadius.circular(10.r),
      decoration: InputDecoration(
        constraints: BoxConstraints(maxHeight: 50.h),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
        hintText: 'cuisine',
        fillColor: kWhiteColor,
      ),
      dropdownColor: kWhiteColor,
      onChanged: onChange,
      //  ['Grocery', 'Pizza', 'Burger', 'Fries', 'Sandwiches']
      items: viewModel.categoryList.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value.name,
          child: Text(
            value.name ?? "",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: const Color(0xff0D0F23), fontSize: 13.sp),
          ),
        );
      }).toList(),
    );
  }
}
