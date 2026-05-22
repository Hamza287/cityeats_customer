import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/views/home/home_view.dart';
import 'package:city_customer_app/ui/widgets/common/cache_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import 'showfilerdata_viewmodel.dart';

class ShowfilerdataView extends StackedView<ShowfilerdataViewModel> {
  const ShowfilerdataView({Key? key, required this.response}) : super(key: key);
  final RestaurantsResponse response;

  @override
  Widget builder(
    BuildContext context,
    ShowfilerdataViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding:
            EdgeInsets.only(left: 10.w, top: 50.h, right: 20.w, bottom: 10.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      viewModel.back();
                    },
                  ),
                ],
              ),
              20.verticalSpace,
              viewModel.listRestaurant.isEmpty
                  ? const Text("No Data found")
                  : ListView.builder(
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
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ShowfilerdataViewModel viewModelBuilder(BuildContext context) =>
      ShowfilerdataViewModel(response);
}

class SearchRestaurantWidget extends StatelessWidget {
  const SearchRestaurantWidget(
      {super.key, required this.restaurant, required this.viewModel});
  final Restaurant restaurant;
  final ShowfilerdataViewModel viewModel;
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
                // top: 3.h,
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
              if (restaurant.isBusy ?? false)
                Positioned(
                  left: 20.w,
                  top: 30.h,
                  child: const ClosedRestaurantTagWidget(),
                )
            ],
          ),
          4.verticalSpace,
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                restaurant.name ?? "Macdonalds",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
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

          2.verticalSpace,
          //
          Text(
            restaurant.address ??
                "Broast, chicken, icecream, hot cofee, drinks ",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 10.sp, letterSpacing: 1),
          ),
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
}
