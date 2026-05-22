import 'dart:math';
import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/views/home/home_view.dart';
import 'package:city_customer_app/ui/widgets/common/cache_network_image.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'search_viewmodel.dart';
class SearchView extends StackedView<SearchViewModel> {
  const SearchView({super.key});

  @override
  Widget builder(
      BuildContext context, SearchViewModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Container(
          padding:
              EdgeInsets.only(left: 10.w, top: 30.h, right: 20.w, bottom: 10.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        viewModel.back(context);
                      },
                    ),
                    5.horizontalSpace,
                    Expanded(
                      child: CustomTextField(
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (val) async {
                          viewModel.setBusy( true);
                          await viewModel.search(val);
                          viewModel.setBusy(false);
                        },
                        onChanged: (val) {
                          viewModel.search(val ?? "");
                        },
                        hintText: "search",
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) => InkWell(
                    onTap: (viewModel.listRestaurant[index].isBusy ?? false)
                        ? null
                        : () {
                            // print(viewModel.featureRestaurantList[index].isBusy);
                            viewModel.navigateToDetail(
                                viewModel.listRestaurant[index]);
                          },
                    child: SearchRestaurantWidget(
                        viewModel: viewModel,
                        restaurant: viewModel.listRestaurant[index]),
                  ),
                  itemCount: viewModel.listRestaurant.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      12.verticalSpace,
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }

  @override
  SearchViewModel viewModelBuilder(BuildContext context) => SearchViewModel();
}

class SearchRestaurantWidget extends StatelessWidget {
  const SearchRestaurantWidget(
      {super.key, required this.restaurant, required this.viewModel});
  final Restaurant restaurant;
  final SearchViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.w),
      width: 290.w,
      // decoration:BoxDecoration(),
      // height: 100.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 160.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  child: NetworkImageWidget(url: restaurant.featureImage ?? ""),
                  // Image.network(restaurant.featureImage ?? ""),
                ),
              ),
              if (restaurant.isBusy ?? false)
                Container(
                  height: 160.h,
                  width: screenWidth(context),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.5), // Shadow color
                        offset: const Offset(0, 3), // Shadow position
                        blurRadius: 6, // Shadow blur radius
                      ),
                    ],
                  ),
                ),
              Positioned(
                bottom: 10,
                right: 0.w,
                child: IconButton(
                  onPressed: () {
                    viewModel.toggleFav(restaurant);
                  },
                  icon: Icon(
                    viewModel.checkIsFavRestaurant(restaurant)
                        ? Icons.favorite_outlined
                        : Icons.favorite_rounded,
                    color: viewModel.checkIsFavRestaurant(restaurant)
                        ? kcPrimaryColor
                        : kcGreyColor,
                    size: 30.sp,
                  ),
                ),
              ),
              if (restaurant.highestDiscount != 0)
                Positioned(
                    right: -28,
                    top: 18.h,
                    child: Transform.rotate(
                      angle: -(pi / 180) * 315,
                      child: Container(
                        height: 25.h,
                        width: 110.w,
                        margin: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0.r),
                          color: Color.fromARGB(255, 237, 198, 3),
                        ),
                        child: Text(
                          "upto ${(restaurant.highestDiscount ?? 0).toInt()}% off",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: kWhiteColor),
                        ),
                      ),
                    )),
              if (restaurant.isBusy ?? false)
                Positioned(
                  left: 20.w,
                  top: 30.h,
                  child: const ClosedRestaurantTagWidget(),
                ),
              if (restaurant.hygineRating != 0)
                Positioned(
                    top: -2.h,
                    left: -2.w,
                    child: Image.asset(
                      viewModel.hygineRating(restaurant.hygineRating ?? 0),
                      height: 60.h,
                      width: 100.w,
                    ))
            ],
          ),
          4.verticalSpace,
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  restaurant.name ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.pedal_bike, size: 17),
                  5.horizontalSpace,
                  Text(
                    "within ${restaurant.deliveryTime ?? 0} mins",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                        ),
                  ),
                ],
              ),
            ],
          ),

          // 2.verticalSpace,
          // //
          // Text(
          //   restaurant.foodNamesString,
          //   style: Theme.of(context)
          //       .textTheme
          //       .bodyMedium
          //       ?.copyWith(fontSize: 10.sp, letterSpacing: 1),
          // ),
          6.verticalSpace,

          //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    getRatingEmoji(
                            double.parse((restaurant.rating ?? 0).toString()))
                        .toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                        ),
                  ),
                  // const Icon(Icons.emoji_emotions_outlined, size: 17),
                  5.horizontalSpace,
                  Text(
                    getRatingString(
                      double.parse((restaurant.rating ?? 0).toString()),
                    ).toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                        ),
                  ),
                ],
              ),
              if (restaurant.freeDelivery == 1) ...[
                discountBannerWidget()
              ] else ...[
                if (restaurant.expectedDeliveryCharges != 0)
                  Text(
                    " Delivery(Est.): £${restaurant.expectedDeliveryCharges}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 12.sp),
                  ),
              ],
              // Text(
              //   "£ ${restaurant.deliveryCharge} Delivery Fee",
              //   style: Theme.of(context)
              //       .textTheme
              //       .bodyMedium
              //       ?.copyWith(fontSize: 12.sp),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Padding discountBannerWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 120.w,
        height: 25.h,
        // margin: EdgeInsets.symmetric(horizontal: 10.w),

        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Color.fromARGB(255, 247, 181, 15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.delivery_dining,
                color: kcBlackColor,
                size: 20.sp,
              ),
              4.horizontalSpace,
              Text(
                "Free Delivery!",
                style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
