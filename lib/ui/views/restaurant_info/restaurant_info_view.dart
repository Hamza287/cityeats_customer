// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/custom_widgets/resturant_info_tile.dart';
import 'package:city_customer_app/ui/widgets/common/cache_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../common/ui_helpers.dart';
import '../home/home_view.dart';
import 'restaurant_info_viewmodel.dart';

class RestaurantInfoView extends StackedView<RestaurantInfoViewModel> {
  const RestaurantInfoView({
    Key? key,
    required this.restaurant,
    this.chargePerKm = 0.0,
    this.customerCharge = 0.0,
    this.customerRadius = 0.0,
  }) : super(key: key);

  final Restaurant restaurant;
  final double? chargePerKm;
  final double? customerCharge;
  final double? customerRadius;

  @override
  Widget builder(
      BuildContext context, RestaurantInfoViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: kcLightGreyColor,
      appBar: AppBar(
        title: Text(
          "Info",
          style:
              Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _coverImage(),
            12.verticalSpace,
            _titleDescription(context),
            20.verticalSpace,

            /// Ratings Tile
            TileWidget(
              title: "Ratings",
              subTitle:
                  "${getRatingString(double.parse((restaurant.rating ?? 0).toString()))} (${restaurant.rating ?? 0})",
              icon: Icons.star,
            ),
            10.verticalSpace,

            /// Hygiene Ratings Tile
            TileWidget(
              title: "Hygiene Ratings",
              subTitle:
                  "${getRatingString(double.parse((restaurant.rating ?? 0).toString()))} (${restaurant.rating ?? 0})",
              icon: Icons.star,
              kcImagesPath: _hygineRating(restaurant.hygineRating ?? 0),
              isAddedImage: true,
            ),
            10.verticalSpace,

            /// Location Tile
            _locationTile(context, "Location", "${restaurant.address}",
                Icons.location_on),
            10.verticalSpace,

            /// Opening Hours Tile
            TileWidget(
                title: "Opening Hours", subTitle: "", icon: Icons.watch_later),

            /// Weekly Timings List
            Container(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              width: MediaQuery.of(context).size.width,
              color: kcWhiteColor,
              child: ListView.separated(
                padding: EdgeInsets.only(left: 30.w),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: restaurant.weeklyTimings?.length ?? 0,
                separatorBuilder: (context, index) => 10.verticalSpace,
                itemBuilder: (context, index) => Row(
                  children: [
                    Text(
                      "${restaurant.weeklyTimings?[index].day}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kcBlackColor.withOpacity(0.6),
                          fontSize: 12.sp),
                    ),
                    const Spacer(),
                    Text(
                      "${viewModel.dateTimeService.convertIntoAmPmDate(restaurant.weeklyTimings?[index].openingTime ?? "00:00:00")} - ${viewModel.dateTimeService.convertIntoAmPmDate(restaurant.weeklyTimings?[index].closingTime ?? "00:00:00")}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            10.verticalSpace,

            /// Delivery Time Tile
            TileWidget(
              title: "Deliver within",
              subTitle: "${restaurant.deliveryTime} mins",
              icon: Icons.pedal_bike,
            ),
            10.verticalSpace,

            /// Expected Delivery Charges Tile (Only if applicable)
            if (restaurant.deliveryCharge != "0")
              TileWidget(
                title: "Expected Delivery Charges",
                subTitle: "£ ${restaurant.deliveryCharge}",
                icon: Icons.note_alt_outlined,
              ),
            10.verticalSpace,

            /// Fixed Charges Tile
            TileWidget(
              title: "Fixed charges per ${customerRadius ?? 0}km",
              subTitle: "£ ${customerCharge ?? 0.0}",
              icon: Icons.note_alt_outlined,
            ),
            10.verticalSpace,

            /// Charges Per Kilometer Tile
            TileWidget(
              title: "Charges Per Kilometer",
              subTitle: "£ ${chargePerKm ?? 0.0}",
              icon: Icons.note_alt_outlined,
            ),
            10.verticalSpace,

            /// Payment Options Tile
            TileWidget(
              title: "Payment Options",
              subTitle: "Stripe, Paypal",
              icon: Icons.credit_card,
            ),
          ],
        ),
      ),
    );
  }

  String _hygineRating(int rating) {
    if (rating == 0) {
      return '$kcStaticImagesPath/zero_rat.png';
    } else if (rating == 1) {
      return "$kcStaticImagesPath/one_rat.png";
    } else if (rating == 2) {
      return "$kcStaticImagesPath/two_rat.png";
    } else if (rating == 3) {
      return "$kcStaticImagesPath/three_rat.png";
    } else if (rating == 4) {
      return "$kcStaticImagesPath/four_rat.png";
    } else if (rating == 5) {
      return "$kcStaticImagesPath/five_rat.png";
    } else {
      return '$kcStaticImagesPath/zero_rat.png';
    }
  }

  Container _locationTile(
      BuildContext context, String title, String subTitle, IconData icon) {
    return Container(
      // height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      width: screenWidth(context),
      color: kcWhiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: kcPrimaryColor),
              10.horizontalSpace,
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: kcBlackColor.withOpacity(0.6), fontSize: 12.sp),
              ),
            ],
          ),
          // const Spacer(),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      subTitle,
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  SizedBox _coverImage() {
    return SizedBox(
        height: 210.h,
        child: NetworkImageWidget(url: restaurant.featureImage ?? "")
        // Image.asset(
        //   "$kcStaticImagesPath/res.jpg",
        //   fit: BoxFit.cover,
        // ),
        );
  }

  Container _titleDescription(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name ?? "",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
          ),
          // Text(
          //   restaurant.foodNamesString,
          //   style: Theme.of(context)
          //       .textTheme
          //       .bodyMedium
          //       ?.copyWith(fontSize: 11.sp),
          // ),
        ],
      ),
    );
  }

  @override
  RestaurantInfoViewModel viewModelBuilder(BuildContext context) =>
      RestaurantInfoViewModel();
}
