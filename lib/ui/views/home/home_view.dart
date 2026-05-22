import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/shimmers/bannershimmer.dart';
import 'package:city_customer_app/ui/shimmers/shimmer_container.dart';
import 'package:city_customer_app/ui/shimmers/shimmer_lists.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:city_customer_app/ui/widgets/common/cache_network_image.dart';
import 'package:city_customer_app/ui/widgets/common/cart_icon_widget.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';
import '../../../responses/addresses_response.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return UpgradeAlert(
      dialogStyle: UpgradeDialogStyle.cupertino,
      cupertinoButtonTextStyle: const TextStyle(
          color: kcPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold),
      showLater: false,
      showIgnore: false,
      showReleaseNotes: true,
      onUpdate: () {
        viewModel.launchURL();
        return true;
      },
      upgrader: Upgrader(
        languageCode: 'en',
        messages: UpgraderMessages(code: "en"),
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kcWhiteColor,
          title: _topBar(context, viewModel),
          toolbarHeight: 80.h,
        ),
        body: SafeArea(
          child: RefreshIndicator(
            color: kcPrimaryColor,
            onRefresh: () async {
              print("refresh");
              await viewModel.init(viewModel.getSelectedAddressId(),
                  isRefresh: true);
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 4.verticalSpace,

                  // _topBar(context, viewModel),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: _searchAndFilter(viewModel)
                        .animate(delay: 300.ms)
                        .fadeIn(duration: 700.ms, delay: 300.ms)
                        .shimmer(
                            blendMode: BlendMode.srcOver, color: kcPrimaryColor)
                        .move(
                            begin: const Offset(-16, 0),
                            curve: Curves.easeOutQuad),
                  ),

                  if (viewModel.bannerList.isNotEmpty)
                    _bannerSlider(viewModel, context),

                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: viewModel.bannerList.asMap().entries.map((entry) {
                      final res = viewModel.findRestaurantById(
                          viewModel.bannerList[entry.key].restaurantId);
                      if (res == null || !(res.isBusy ?? false)) {
                        return GestureDetector(
                          onTap: () =>
                              viewModel.controller.animateToPage(entry.key),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? kcWhiteColor
                                        : kcPrimaryColor)
                                    .withOpacity(viewModel.current == entry.key
                                        ? 0.9
                                        : 0.4)),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }).toList(),
                  ),

                  if (viewModel.isBusy) ...[
                    shimmerWidget(),
                  ] else ...[
                    if (viewModel.categoryList.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Text(
                          "Top Cuisines",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      10.verticalSpace,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _categoryList(context, viewModel),
                            20.horizontalSpace,
                          ],
                        ),
                      ),
                      20.verticalSpace,
                    ]
                  ],

                  if (viewModel.featureRestaurantList.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(
                        "Feature Restaurants",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    10.verticalSpace,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _featureRestaurantList(context, viewModel),
                    ),
                    20.verticalSpace,
                  ],

                  if (viewModel.favRestaurantList.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(
                        "Favorite Restaurants",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    10.verticalSpace,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _favRestaurantList(context, viewModel),
                          20.horizontalSpace,
                        ],
                      ),
                    ),
                    20.verticalSpace,
                  ],

                  if (viewModel.allRestaurantList.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(
                        "All Restaurants",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    10.verticalSpace,
                    _allRestaurantList(viewModel),
                    20.verticalSpace,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // );
  }

  Column shimmerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.h, left: 20.0.w),
          child: ShimmerContainer(height: 30.h, width: 200.w),
        ),
        10.verticalSpace,
        BannerShimmer(
          containerHeight: 50.h,
          containerWidth: 600.w,
          color: kcLightGreyColor,
          space: 2,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.h, left: 20.0.w),
          child: ShimmerContainer(height: 30.h, width: 200.w),
        ),
        10.verticalSpace,
        BannerShimmer(
          containerHeight: 140.h,
          containerWidth: 650.w,
          color: kcLightGreyColor,
          space: 2,
          cardWidth: 290.w,
          itemCount: 2,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.h, left: 20.0.w),
          child: ShimmerContainer(height: 30.h, width: 200.w),
        ),
        const ShimmerList(
          color: Color(0xffF4F5FA),
          height: 110,
          width: 400,
        ),
      ],
    );
  }

  Container _allRestaurantList(HomeViewModel viewModel) {
    return Container(
      margin: EdgeInsets.only(right: 15.w),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: (viewModel.allRestaurantList[index].isBusy ?? false)
                ? null
                : () {
                    print(viewModel.allRestaurantList[index].isBusy);
                    viewModel.navigateToDetail(
                        viewModel.allRestaurantList[index], 0);
                  },
            child: RestaurantWidget(
                viewModel: viewModel,
                restaurant: viewModel.allRestaurantList[index])),
        itemCount: viewModel.allRestaurantList.length,
        separatorBuilder: (BuildContext context, int index) => 20.verticalSpace,
      ),
    );
  }

  SizedBox _favRestaurantList(BuildContext context, HomeViewModel viewModel) {
    return SizedBox(
      height: 245.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) => InkWell(
          onTap: (viewModel.favRestaurantList[index].isBusy ?? false)
              ? null
              : () {
                  print(viewModel.favRestaurantList[index].isBusy);
                  viewModel.navigateToDetail(
                      viewModel.favRestaurantList[index], 0);
                },
          child: RestaurantWidget(
              viewModel: viewModel,
              restaurant: viewModel.favRestaurantList[index]),
        ),
        itemCount: viewModel.favRestaurantList.length,
        separatorBuilder: (BuildContext context, int index) =>
            10.horizontalSpace,
      ),
    );
  }

  SizedBox _featureRestaurantList(
      BuildContext context, HomeViewModel viewModel) {
    return SizedBox(
      height: 245.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) => InkWell(
          onTap: (viewModel.featureRestaurantList[index].isBusy ?? false)
              ? null
              : () {
                  viewModel.navigateToDetail(
                      viewModel.featureRestaurantList[index], 0);
                },
          child: RestaurantWidget(
              viewModel: viewModel,
              restaurant: viewModel.featureRestaurantList[index]),
        ),
        itemCount: viewModel.featureRestaurantList.length,
      ),
    );
  }

  Padding _categoryList(BuildContext context, HomeViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(left: 20.h),
      child: SizedBox(
        height: 90.h,
        child: ListView.separated(
          itemCount: viewModel.categoryList.length,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              viewModel.navigateToCatRestView(index);
            },
            child: CategoryWidget(
                image: viewModel.categoryList[index].image ?? "",
                title: viewModel.categoryList[index].name ?? ""),
          ),
          separatorBuilder: (BuildContext context, int index) =>
              10.horizontalSpace,
        ),
      ),
    );
  }

  CustomTextField _searchAndFilter(HomeViewModel viewModel) {
    return CustomTextField(
      borderRadius: 0,
      onTap: () async {
        await viewModel.navigateToSearchView();
        viewModel.unFocus();
      },
      autofocus: false,
      focusNode: viewModel.focusNode,
      hintText: "Search for food, restaurants...",
      prefix: const Icon(Icons.search),
      suffix: InkWell(
        onTap: () {
          viewModel.navigateToFilterView();
        },
        child: Container(
          width: 100.w,
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: kcGreyColor,
                width: 1,
              ),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.tune),
              Text("Filter"),
            ],
          ),
        ),
      ),
    );
  }

  String _getDisplayAddress(
      GlobalLocationViewModel locationModel, HomeViewModel viewModel) {
    if (locationModel.isBusy || !locationModel.addressesLoaded) {
      return "Loading...";
    }

    if (locationModel.getSelectedAddress != null) {
      final displayAddress = locationModel
          .getDisplayAddressString(locationModel.getSelectedAddress);
      if (displayAddress != null && displayAddress.isNotEmpty) {
        return displayAddress;
      }
    }

    if (!viewModel.authService.checkLogin()) {
      final localStorageAddress = viewModel.localStorageService.address;
      if (localStorageAddress != null) {
        if (localStorageAddress is LocationAddress) {
          final address = localStorageAddress.address;
          if (address != null && address.isNotEmpty) {
            return address;
          }
        } else if (localStorageAddress is String &&
            localStorageAddress.isNotEmpty) {
          return localStorageAddress;
        }
      }
    }

    if (locationModel.addressList.isNotEmpty) {
      for (var address in locationModel.addressList) {
        final displayAddress = locationModel.getDisplayAddressString(address);
        if (displayAddress != null && displayAddress.isNotEmpty) {
          if (locationModel.getSelectedAddress == null) {
            locationModel.selectedAddress = address;
          }
          return displayAddress;
        }
      }
    }

    if (viewModel.authService.checkLogin() &&
        viewModel.authService.userProfile?.address != null &&
        viewModel.authService.userProfile!.address!.isNotEmpty) {
      final profileAddress = viewModel.authService.userProfile!.address!.first;
      if (profileAddress.address != null &&
          profileAddress.address!.isNotEmpty) {
        return profileAddress.address!;
      }
    }

    if (locationModel.addressesLoaded) {
      return "No address";
    }

    return "Loading...";
  }

  Widget _topBar(BuildContext context, HomeViewModel viewModel) {
    return Consumer<GlobalLocationViewModel>(
        builder: (context, locationModel, child) {
      return Container(
        // height: 80.h, // Removed fixed height to let AppBar control it
        width: screenWidth(context),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.menu, color: kcBlackColor),
              onPressed: () {
                if (viewModel.authService.checkLogin()) {
                  viewModel.navigateToAccountView();
                } else {
                  showSnackBar(context, message: "Please Login First");
                  viewModel.loginView();
                }
              },
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Delivering to",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp, fontWeight: FontWeight.w500),
                  ),
                  3.verticalSpace,
                  InkWell(
                    onTap: () async {
                      LocationAddress? address =
                          await viewModel.navigateToSaveAddresses();
                      if (address != null) {
                        locationModel.selectedAddress = address;
                        viewModel.init(address.id ?? 0);
                      } else {}
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            _getDisplayAddress(locationModel, viewModel),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down,
                            color: kcPrimaryColor),
                        const Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CartIconWidget(onTap: () {
              if (viewModel.authService.checkLogin()) {
                viewModel.navigateToCartView();
              } else {
                showSnackBar(context, message: "Please Login First");
                viewModel.loginView();
              }
            })
          ],
        ),
      );
    });
  }

  Widget _bannerSlider(HomeViewModel viewModel, BuildContext context) {
    return CarouselSlider(
      items: viewModel.bannerList
          .map((banner) {
            final res = viewModel.findRestaurantById(banner.restaurantId);
            if (res == null || res.isBusy == false) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      if (res == null) return; // Prevent tap while restaurants are still loading
                      if (banner.foodId != null) {
                        await viewModel.getSpecificFoodDetails(banner.foodId!);
                      }
                      viewModel.navigateToDetail(res, banner.foodId);
                    },
                    child: roundedImage(
                      context,
                      res?.isBusy ?? false,
                      banner.sliderImage ?? "",
                    ),
                  );
                },
                //
              );
            } else {
              return null;
            }
          })
          .whereType<Widget>()
          .toList(),
      carouselController: viewModel.controller,
      options: CarouselOptions(
        autoPlay: true,
        height: 160.h,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
        autoPlayInterval: 3.seconds,
        onPageChanged: (index, reason) {
          viewModel.onPageChange(index);
        },
      ),
    );
  }

  Widget getCousinWidget(BuildContext context, String image, String title) {
    return Column(
      children: [
        SizedBox(
          height: 80.h,
          width: 80.w,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              child: Image.asset("$kcStaticImagesPath/$image")),
        ),
        10.verticalSpace,
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        )
      ],
    );
  }

  Widget roundedImage(context, bool isBusy, String imageUrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      width: screenWidth(context),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(10.r), // Adjust the radius as needed
        child: Stack(
          children: [
            NetworkImageWidget(
              url: imageUrl,
            ),
            if (isBusy)
              Positioned(
                left: 20.w,
                top: 18.h,
                child: const ClosedRestaurantTagWidget(),
              ),
            if (isBusy)
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
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.image,
    required this.title,
    this.isAssetImage = false,
  });
  final String image, title;
  final bool isAssetImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60.h,
          width: 60.w,
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: isAssetImage
                ? Image.asset(image, fit: BoxFit.cover)
                : NetworkImageWidget(url: image),
          ),
        ),
        6.verticalSpace,
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class RestaurantWidget extends StatelessWidget {
  const RestaurantWidget(
      {super.key, required this.restaurant, required this.viewModel});
  final Restaurant restaurant;
  final HomeViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.w),
      width: 290.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: kWhiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5), // Shadow color with opacity
            offset: Offset(0, 2.18), // Horizontal and vertical offset
            blurRadius: 21.18, // How much the shadow should blur
            // How much the shadow spreads
          ),
        ],
      ),
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
              if (viewModel.authService.userProfile != null)
                Positioned(
                    bottom: 10,
                    right: 0.w,
                    child: FavouriteWidget(
                        viewModel: viewModel, restaurant: restaurant)),

              // Discount Banner
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

              if (restaurant.isBusy ?? false) ...[
                Positioned(
                    left: 20.w,
                    top: 20.h,
                    child: const ClosedRestaurantTagWidget()),
              ] else ...[
                if (restaurant.hygineRating != 0)
                  Positioned(
                      top: -2.h,
                      left: -2.w,
                      child: Image.asset(
                        viewModel.hygineRating(restaurant.hygineRating ?? 0),
                        height: 60.h,
                        width: 100.w,
                      )),
              ]

              // Schedule for later
              // if (restaurant.isScheduleForLater == 1)
              //   Positioned(bottom: 10.h, left: 3.w, child: ScheduleTagWidget())
            ],
          ),
          4.verticalSpace,
          //
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    restaurant.name ?? "Macdonalds",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp, fontWeight: FontWeight.w600),
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
          ),

          //
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 3.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getRatingEmoji(double.parse(
                                (restaurant.rating ?? 0).toString()))
                            .toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12.sp,
                            ),
                      ),
                      // const Icon(Icons.emoji_emotions_outlined, size: 17),
                      5.horizontalSpace,
                      Flexible(
                        child: Text(
                          getRatingString(
                            double.parse((restaurant.rating ?? 0).toString()),
                          ).toString(),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 12.sp,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (restaurant.freeDelivery == 1) ...[
                  Flexible(child: discountBannerWidget())
                ] else ...[
                  if (restaurant.expectedDeliveryCharges != 0)
                    Flexible(
                      child: Text(
                        " Delivery(Est.): £${(restaurant.expectedDeliveryCharges ?? 0).toStringAsFixed(2)}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 12.sp),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                ],
              ],
            ),
          ),
          // if (restaurant.freeDelivery == 1) discountBannerWidget(),
          5.verticalSpace
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

class FavouriteWidget extends StatelessWidget {
  const FavouriteWidget({
    super.key,
    required this.viewModel,
    required this.restaurant,
  });

  final HomeViewModel viewModel;
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (viewModel.authService.checkLogin()) {
          viewModel.toggleFav(restaurant);
        } else {
          showSnackBar(context, message: "Please Login First");
          viewModel.loginView();
        }
      },
      icon: Icon(
        viewModel.checkIsFavRestaurant(restaurant)
            // viewModel.favRestaurantList.contains(restaurant)
            ? Icons.favorite_outlined
            : Icons.favorite_rounded,
        color: viewModel.checkIsFavRestaurant(restaurant)
            ? kcPrimaryColor
            : kcGreyColor,
        size: 30.sp,
      ),
    );
  }
}

class ClosedRestaurantTagWidget extends StatelessWidget {
  const ClosedRestaurantTagWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(8.r)),
      // height: 18.h,
      // width: 60.w,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
      child: Center(
          child: Text(
        "closed",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.red[900],
            letterSpacing: 1.4,
            // fontSize: ,
            fontFamily: GoogleFonts.abhayaLibre().fontFamily,
            fontStyle: FontStyle.normal),
      )),
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

class ScheduleTagWidget extends StatelessWidget {
  const ScheduleTagWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
      // height: 18.h,
      // width: 60.w,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
      child: Center(
          child: Text(
        " ⏰ Schedule For Later!",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            letterSpacing: 1.4,
            // fontSize: ,
            fontFamily: GoogleFonts.abhayaLibre().fontFamily,
            fontStyle: FontStyle.normal),
      )),
    );
  }
}
