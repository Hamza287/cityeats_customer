import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_colors.dart';
import 'save_addresses_viewmodel.dart';

class SaveAddressesView extends StackedView<SaveAddressesViewModel> {
  const SaveAddressesView({super.key});

  @override
  Widget builder(
      BuildContext context, SaveAddressesViewModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: kcPrimaryColor,
          onPressed: () {
            viewModel.navigateToAddressScreen(null);
          },
          child: const Icon(Icons.add, color: kcWhitColor, size: 25),
        ),
        appBar: AppBar(
          shadowColor: kcWhiteColor,
          title: Text(
            "Save Addresses",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        backgroundColor: kcLightGreyColor,
        body: Padding(
          padding:
              EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 50.h),
          child: Column(children: [
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: viewModel.addressList.length,
                itemBuilder: (BuildContext context, int index) =>
                    viewModel.addressList[index].address == null
                        ? const SizedBox()
                        : InkWell(
                            onTap: () {
                              viewModel.back(viewModel.addressList[index]);
                            },
                            child: Container(
                              // height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: kcWhiteColor,
                              ),
                              width: screenWidth(context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 25.h),
                              child: Row(children: [
                                Icon(
                                    viewModel.addressList[index].type == "home"
                                        ? Icons.home_outlined
                                        : viewModel.addressList[index].type ==
                                                "office"
                                            ? Icons.work_outline_sharp
                                            : Icons.home_outlined,
                                    size: 25),
                                10.horizontalSpace,
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                      viewModel.addressList[index].address ??
                                          "UnKnow",
                                      // "Hosue 123 building 28 Street #1, Johar Town, Lahore 54800 ",
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontSize: 12.sp,
                                              overflow: TextOverflow.ellipsis)),
                                ),
                                6.horizontalSpace,
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    visualDensity:
                                        const VisualDensity(horizontal: -4),
                                    onPressed: () async {
                                      // Show confirmation dialog before deleting
                                      await viewModel.showDeleteConfirmation(
                                        context,
                                        viewModel.addressList[index].id!,
                                        viewModel.addressList[index].address ??
                                            "this address",
                                      );
                                    },
                                    icon: const Icon(Icons.delete_outlined,
                                        size: 20)),
                                2.horizontalSpace,
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity:
                                      const VisualDensity(horizontal: -4),
                                  icon:
                                      const Icon(Icons.edit_outlined, size: 20),
                                  onPressed: () {
                                    viewModel.navigateToAddressScreen(
                                        viewModel.addressList[index]);
                                  },
                                ),
                              ]),
                            ),
                          ),
                separatorBuilder: (BuildContext context, int index) =>
                    12.verticalSpace,
              ),
            ),
            //  SizedBox(height: 200.h,),
          ]),
        ),
      ),
    );
  }

  @override
  SaveAddressesViewModel viewModelBuilder(BuildContext context) =>
      SaveAddressesViewModel();
}
