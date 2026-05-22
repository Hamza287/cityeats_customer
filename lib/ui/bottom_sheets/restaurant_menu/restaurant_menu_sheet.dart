import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';
import 'package:flutter/material.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'restaurant_menu_sheet_model.dart';

class RestaurantMenuSheet extends StackedView<RestaurantMenuSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;
  const RestaurantMenuSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget builder(
      BuildContext context, RestaurantMenuSheetModel viewModel, Widget? child) {
    List<RestaurantCategory> list = request.data as List<RestaurantCategory>;
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: kcWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      locator<NavigationService>().back();
                    },
                    icon: const Icon(Icons.close)),
                15.horizontalSpace,
                Text(
                  "Menu Categories",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: kcBlackColor),
                ),
              ],
            ),
            25.verticalSpace,
            Expanded(
              child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            list[index].name ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: kcBlackColor),
                          ),
                          Text(
                            list[index].foods?.length.toString() ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: kcBlackColor),
                          ),
                        ]);
                  },
                  itemCount: list.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(thickness: .5)),
            ),
          ]),
    );
  }

  @override
  RestaurantMenuSheetModel viewModelBuilder(BuildContext context) =>
      RestaurantMenuSheetModel();
}
