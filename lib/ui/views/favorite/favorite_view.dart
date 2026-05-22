import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/views/home/home_view.dart';
import 'package:city_customer_app/ui/widgets/common/cache_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import 'favorite_viewmodel.dart';

class FavoriteView extends StackedView<FavoriteViewModel> {
  const FavoriteView({super.key});

  @override
  Widget builder(
      BuildContext context, FavoriteViewModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: kcWhiteColor,
          title: Text(
            "Favorites",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 25.h),
            child: viewModel.isBusy
                ? Container()
                : viewModel.favRestaurantList.isEmpty
                    ? const Center(child: Text("No favorites"))
                    : _allFavRestaurantList(viewModel)),
          ),
      ),
    );
  }

  Container _allFavRestaurantList(FavoriteViewModel viewModel) {
    return Container(
      margin: EdgeInsets.only(right: 15.w),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: (viewModel.favRestaurantList[index].isBusy ?? false)
                ? null
                : () {
                    viewModel
                        .navigateToDetail(viewModel.favRestaurantList[index]);
                  },
            child: FavRestaurant(
                viewModel: viewModel,
                restaurant: viewModel.favRestaurantList[index])),
        itemCount: viewModel.favRestaurantList.length,
        separatorBuilder: (BuildContext context, int index) => 20.verticalSpace,
      ),
    );
  }

  @override
  FavoriteViewModel viewModelBuilder(BuildContext context) =>
      FavoriteViewModel();
}

class FavRestaurant extends StatelessWidget {
  const FavRestaurant(
      {super.key, required this.restaurant, required this.viewModel});
  final Restaurant restaurant;
  final FavoriteViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.w),
      width: 290.w,
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
                top: 15.h,
                right: 20.w,
                child: IconButton(
                  onPressed: () {
                    viewModel.toggleFav(restaurant);
                  },
                  icon: Icon(
                    Icons.favorite_outlined,
                    color: kcPrimaryColor,
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
          // Text(
          //   restaurant.foodNamesString,
          //   style: Theme.of(context)
          //       .textTheme
          //       .bodyMedium
          //       ?.copyWith(fontSize: 10.sp, letterSpacing: 1),
          // ),
          // 6.verticalSpace,

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

String getRatingString(double rating) {
  if (rating < 0 || rating > 5) {
    return "Invalid rating"; // Handle invalid rating values
  } else if (rating < 1) {
    return "Not Rated";
  } else if (rating < 2) {
    return "Fair";
  } else if (rating < 3) {
    return "Average";
  } else if (rating < 4) {
    return "Good";
  } else if (rating < 5) {
    return "Very Good";
  } else {
    return "Excellent";
  }
}

String getRatingEmoji(double rating) {
  if (rating < 0 || rating > 5) {
    return "Invalid rating"; // Handle invalid rating values
  } else if (rating < 1) {
    return "😞"; // Poor
  } else if (rating < 2) {
    return "😐"; // Fair
  } else if (rating < 3) {
    return "😊"; // Average
  } else if (rating < 4) {
    return "😄"; // Good
  } else if (rating < 5) {
    return "😍"; // Very Good
  } else {
    return "😎"; // Excellent
  }
}
