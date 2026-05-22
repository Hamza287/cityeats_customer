import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/shimmers/bannershimmer.dart';
import 'package:city_customer_app/ui/views/home/home_view.dart';
import 'package:city_customer_app/ui/widgets/common/cache_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import 'categrory_rest_viewmodel.dart';

class CategroryRestView extends StackedView<CategroryRestViewModel> {
  const CategroryRestView({
    Key? key,
    required this.catId,
    required this.catName,
    this.isGrocery = false,
  }) : super(key: key);
  final int catId;
  final String catName;
  final bool isGrocery;

  @override
  Widget builder(
      BuildContext context, CategroryRestViewModel viewModel, Widget? child) {
    return
        // CustomProgressIndicator(
        // isLoading: viewModel.isBusy,
        // child:
        Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              elevation: 2,
              backgroundColor: kcWhiteColor,
              title: Text(
                catName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                color: kcWhiteColor,
                child: viewModel.isBusy
                    ? const ShimmerList(
                        color: Color(0xffF4F5FA),
                        height: 105,
                        width: 300,
                      )
                    : Column(
                        crossAxisAlignment: (isGrocery
                                ? !viewModel.isBusy &&
                                    viewModel.groceriesList.isEmpty
                                : !viewModel.isBusy &&
                                    viewModel.restaurantList.isEmpty)
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          if (isGrocery
                              ? !viewModel.isBusy &&
                                  viewModel.groceriesList.isEmpty
                              : !viewModel.isBusy &&
                                  viewModel.restaurantList.isEmpty)
                            Text(
                              // resCat.name ?? "",
                              isGrocery
                                  ? "All Grocery Stores"
                                  : "All Restaurants",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 16.sp,
                                    color: kcBlackColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          10.verticalSpace,
                          (isGrocery
                                  ? !viewModel.isBusy &&
                                      viewModel.groceriesList.isEmpty
                                  : !viewModel.isBusy &&
                                      viewModel.restaurantList.isEmpty)
                              ? Center(
                                  child: Text(
                                    isGrocery
                                        ? "No Grocery Store"
                                        : "No Restaurants",
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: isGrocery
                                      ? viewModel.groceriesList.length
                                      : viewModel.restaurantList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => _itemWidget(
                                      context,
                                      isGrocery
                                          ? viewModel.groceriesList[index]
                                          : viewModel.restaurantList[index],
                                      viewModel),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          10.verticalSpace,
                                ),
                        ],
                      ),
              ),
            ));
  }

  _itemWidget(BuildContext context, Restaurant restaurant,
      CategroryRestViewModel viewModel) {
    return InkWell(
      onTap: (restaurant.isBusy ?? false)
          ? null
          : () {
              viewModel.navigateToDetail(restaurant);
            },
      child: Stack(
        children: [
          Container(
            width: screenWidth(context),
            padding: EdgeInsets.symmetric(vertical: 5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: const Color(0xffF4F5FA),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 90.h,
                  width: 90.w,
                  child: NetworkImageWidget(
                    url: restaurant.featureImage ?? "",
                    bottomLeftRadius: 10.r,
                    topLeftRadius: 10.r,
                    bottomRightRadius: 10.r,
                    topRightRadius: 10.r,
                  ),
                ),
                24.horizontalSpace,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      5.verticalSpace,
                      Text(
                        restaurant.name ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: kcBlackColor),
                      ),
                      5.verticalSpace,
                      Text(
                        restaurant.foodNamesString,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 10.sp,
                              color: kcBlackColor.withOpacity(.5),
                            ),
                      ),
                      5.verticalSpace,
                      Row(
                        children: [
                          const Icon(Icons.pedal_bike, size: 17),
                          5.horizontalSpace,
                          Text(
                            "within ${restaurant.deliveryTime} mins",
                            // "within 20 mins",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 12.sp,
                                      color: kcBlackColor,
                                    ),
                          ),
                        ],
                      ),
                      5.verticalSpace,
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.emoji_emotions_outlined,
                                  size: 17),
                              5.horizontalSpace,
                              Text(
                                restaurant.rating ?? "Very Good",
                                // "Very Good .",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 12.sp,
                                    ),
                              ),
                            ],
                          ),
                          5.horizontalSpace,
                          // Text(
                          //   "£ ${restaurant.deliveryCharge} Delivery Fee",
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .bodyMedium
                          //       ?.copyWith(
                          //           fontSize: 12.sp,
                          //           color: kcBlackColor.withOpacity(.5)),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (restaurant.isBusy ?? false)
            Positioned(
              right: 10.w,
              top: 10.h,
              child: const ClosedRestaurantTagWidget(),
            )
        ],
      ),
    );
  }

  @override
  CategroryRestViewModel viewModelBuilder(BuildContext context) =>
      CategroryRestViewModel(catId, isGrocery);
}
