import 'dart:math';

import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';
import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/shimmers/bannershimmer.dart';
import 'package:city_customer_app/ui/shimmers/shimmer_lists.dart';
import 'package:city_customer_app/ui/views/cart/cart_viewmodel.dart';
import 'package:city_customer_app/ui/views/home/home_view.dart';
import 'package:city_customer_app/ui/widgets/common/cache_network_image.dart';
import 'package:city_customer_app/ui/widgets/common/cart_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'restaurant_detail_viewmodel.dart';

class RestaurantDetailView extends StackedView<RestaurantDetailViewModel> {
  const RestaurantDetailView(
      {Key? key,
      required this.restaurantId,
      required this.restaurant,
      this.foodId})
      : super(key: key);
  final int restaurantId;
  final Restaurant restaurant;
  final int? foodId;

  Size get preferredSize => Size.fromHeight(60.h);
  @override
  Widget builder(BuildContext context, RestaurantDetailViewModel viewModel,
      Widget? child) {
    final cartProvider = Provider.of<CartViewModel>(context, listen: true);
    return DefaultTabController(
      length: viewModel.restaurantCat.length + 1,
      child: Scaffold(
        backgroundColor: const Color(0xffF4F5FA),
        //  Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      // snap: true,
                      pinned: true,
                      floating: true,
                      stretch: true,
                      excludeHeaderSemantics: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: kcWhiteColor,
                      expandedHeight: 400.h,
                      bottom: PreferredSize(
                        preferredSize: preferredSize,
                        child: Container(
                          color: kcWhiteColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              20.horizontalSpace,
                              InkWell(
                                  onTap: () {
                                    viewModel.showBottomSheet();
                                  },
                                  child: const Icon(Icons.menu,
                                      color: kcBlackColor)),
                              if (viewModel.isBusy) ...[
                                BannerShimmer(
                                  margin:
                                      EdgeInsets.only(right: 15.w, left: 15.w),
                                  color: kcLightGreyColor,
                                  containerHeight: 20.h,
                                  containerWidth: 300.w,
                                  space: 10,
                                )
                              ] else ...[
                                if (viewModel.restaurantCat.isNotEmpty)
                                  Expanded(
                                    flex: 9,
                                    child: TabBar(
                                      padding: EdgeInsets.zero,
                                      isScrollable: true,
                                      labelColor: kcPrimaryColor,
                                      indicatorColor: kcPrimaryColor,
                                      tabs: [
                                        if (viewModel.restaurantCat.isNotEmpty)
                                          const Tab(
                                              child: Text(
                                            "All",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                        for (int i = 0;
                                            i < viewModel.restaurantCat.length;
                                            i++)
                                          Tab(
                                              child: Text(
                                            viewModel.restaurantCat[i].name ??
                                                "",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      ],
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          children: [
                            ///
                            _topBar(context, viewModel),

                            ///
                            5.verticalSpace,

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ///
                                    _restaurantInfo(context, viewModel),
                                    10.verticalSpace,

                                    ///
                                    Container(
                                      child:
                                          _restaurantRating(context, viewModel),
                                    ),
                                    // 30.verticalSpace,

                                    ///
                                    Divider(
                                        thickness: 0.5,
                                        color: kcBlackColor.withOpacity(0.4)),
                                  ]),
                            ),
                            10.verticalSpace,
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: <Widget>[
                    if (viewModel.isBusy) ...[
                      const ShimmerList(
                        color: Color(0xffF4F5FA),
                        height: 90,
                        width: 400,
                        isImage: true,
                      )
                    ] else ...[
                      if (viewModel.restaurantCat.isNotEmpty)
                        ListView(
                          children: [
                            ListView.builder(
                              itemCount: viewModel.restaurantCat.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => _categoryView(
                                context,
                                viewModel.restaurantCat[index],
                              ),
                            ),
                            if (cartProvider.cartProducts.isNotEmpty)
                              SizedBox(height: 90.h),
                          ],
                        ),
                    ],
                    for (int i = 0; i < viewModel.restaurantCat.length; i++)
                      ListView(
                        children: [
                          _categoryView(context, viewModel.restaurantCat[i]),
                          if (cartProvider.cartProducts.isNotEmpty)
                            SizedBox(height: 90.h),
                        ],
                      )
                  ],
                ),
              ),

              ///
              ///CART BUTTON
              if (cartProvider.cartProducts.isNotEmpty)
                Positioned(
                    bottom: 30.h,
                    left: -10.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: CustomElevatedButton(
                        onPressed: () {
                          viewModel.navigateToCartView();
                        },
                        text: '',
                        size: Size(320.w, 48.h),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.shopping_basket_outlined,
                                      color: kcWhitColor),
                                  4.horizontalSpace,
                                  Center(
                                    child: Text(
                                      "(${cartProvider.cartProducts.length} items) View your cart",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: kcWhitColor,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              // 50.horizontalSpace,
                              // Text(
                              //   "£ ${(cartProvider.cart?.subTotal ?? 0)} ",
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .bodyMedium
                              //       ?.copyWith(
                              //           color: kcWhitColor,
                              //           fontWeight: FontWeight.bold),
                              // ),
                            ]),
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }

  Row _restaurantInfo(
      BuildContext context, RestaurantDetailViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant.name ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        TextButton.icon(
            onPressed: () {
              ///
              if (viewModel.restaurant != null) {
                viewModel.navigateToRestaurantInfo(viewModel.restaurant!);
              } else {
                viewModel.navigateToRestaurantInfo(restaurant);
              }
            },
            icon: Icon(
              Icons.info_outline,
              size: 15.sp,
              color: kcPrimaryColor,
            ),
            label: Text(
              "See info",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: kcPrimaryColor,
                  ),
            ))
      ],
    );
  }

  _restaurantRating(BuildContext context, RestaurantDetailViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Row(
          children: [
            Text(
              // "😀",
              getRatingEmoji(
                double.parse((restaurant.rating ?? 0).toString()),
              ).toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    // fontWeight: FontWeight.w600,
                    color: kcPrimaryColor,
                  ),
            ),
            5.horizontalSpace,
            Text(
              // restaurant.rating ?? "Very Good",
              getRatingString(
                double.parse((restaurant.rating ?? 0).toString()),
              ).toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    // fontWeight: FontWeight.w600,
                    // color: kcPrimaryColor,
                  ),
            ),
            5.horizontalSpace,
            Text(
              "(${restaurant.rating ?? '0'} ratings)",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    // fontWeight: FontWeight.w600,
                    color: kcPrimaryColor,
                  ),
            ),
          ],
        ),
        13.horizontalSpace,
        if (viewModel.customerCharges != null)
          Flexible(
            child: Text(
              "£${viewModel.customerCharges} fixed delivery charges for ${viewModel.customerRadius}km radius",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    // fontWeight: FontWeight.w600,
                    // color: k,
                  ),
            ),
          )
      ],
    );
  }

  _categoryView(BuildContext context, RestaurantCategory resCat) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        color: kcWhiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resCat.name ?? "",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16.sp,
                    color: kcBlackColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              resCat.description ?? "",
              // maxLines: 4,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 10.sp,
                    color: kcBlackColor,
                  ),
            ),
            10.verticalSpace,
            ListView.separated(
              itemCount: resCat.foods?.length ?? 0,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => _itemWidget(
                context,
                resCat.foods![index],
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  10.verticalSpace,
            ),
          ],
        ),
      ),
    );
  }

  _itemWidget(
    BuildContext context,
    Foods food,
  ) {
    return InkWell(
      onTap: () {
        print("ItemWidget:FoodId:::: ${food.id}");
        locator<NavigationService>().navigateToProductDescriptionView(
            foodId: food.id ?? 0, restaurantId: restaurantId);
      },
      child: Container(
        width: screenWidth(context),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kcLightGrey.withOpacity(0.5), // shadow color
              spreadRadius: 2, // spread radius
              blurRadius: 4, // blur radius
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(8.r),
          // border: Border.all(
          //     width: 0.40,
          //     color: kcPrimaryColor.withOpacity(0.5),
          //     style: BorderStyle.solid),
          color: kWhiteColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 5.horizontalSpace,
            Stack(
              children: [
                SizedBox(
                  height: 85.h,
                  width: 85.w,
                ),
                Positioned(
                  top: 2.5.h,
                  left: 2.5.w,
                  child: SizedBox(
                    height: 82.h,
                    width: 82.w,
                    child: NetworkImageWidget(
                      url: food.image ?? "",
                      bottomLeftRadius: 10.r,
                      topLeftRadius: 10.r,
                      bottomRightRadius: 10.r,
                      topRightRadius: 10.r,
                    ),
                    //   Image.network(
                    // food.image ?? "",
                    // fit: BoxFit.cover,
                    // errorBuilder: (context, error, stackTrace) =>
                    //     Image.asset("$kcStaticImagesPath/place_pro.jpeg"),
                    // ),
                  ),
                ),
                if (food.percentDiscount != 0) ...[
                  Positioned(
                      top: 0.h,
                      left: 0.w,
                      child: Image.asset(
                        kBannerImage,
                        height: 55.8.h,
                        width: 55.25.w,
                        fit: BoxFit.cover,
                      )),
                  Positioned(
                    top: 13.h,
                    child: Transform.rotate(
                        angle: -(pi / 180) * 45,
                        child: Container(
                          alignment: Alignment.center,
                          width: 38.w,
                          child: FittedBox(
                            child: Text(
                              "${food.percentDiscount?.toInt()}% off",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
                  ),
                ]
              ],
            ),
            20.horizontalSpace,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  5.verticalSpace,
                  Text(
                    food.name ?? "",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: kcBlackColor,
                          // fontWeight: FontWeight.bold,
                          // fontSize: 18.sp,
                        ),
                  ),
                  5.verticalSpace,
                  Text(
                    food.description ?? "",
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 10.sp,
                          overflow: TextOverflow.ellipsis,
                          color: kcBlackColor,
                        ),
                  ),
                  5.verticalSpace,
                  if (discountApplicable(food.percentDiscount ?? 0)) ...[
                    Row(
                      children: [
                        Text(
                          "£ ${food.price}",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 13.sp,
                                    color: kcLightGrey,
                                    decorationColor: kcLightGrey,
                                    decorationThickness: 1.5,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                        ),
                        5.w.horizontalSpace,
                        Text(
                          "£ ${getDiscountedPrice(double.parse(food.price ?? '0'), food.percentDiscount ?? 0)}",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 14.sp,
                                    color: kcBlackColor,
                                  ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      food.variants!.isNotEmpty
                          ? "£ ${food.variants![0].price}"
                          : "£ ${food.price}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 14.sp,
                            color: kcLightGrey,
                          ),
                    )
                  ],
                  5.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  discountApplicable(double discount) {
    if (discount != 0) {
      return true;
    }
    return false;
  }

  String getDiscountedPrice(double price, double percentDiscount) {
    double discountedPrice = price - (price * (percentDiscount / 100));
    return discountedPrice.toStringAsFixed(2);
  }

  Stack _topBar(BuildContext context, RestaurantDetailViewModel viewModel) {
    return Stack(
      children: [
        SizedBox(
            height: 210.h,
            width: screenWidth(context),
            child: NetworkImageWidget(url: restaurant.featureImage ?? "")
            // Image.network(
            //   restaurant.featureImage ?? "",
            //   fit: BoxFit.cover,
            // ),
            ),
        Positioned(
          right: 20.w,
          top: 20.h,
          child: CartIconWidget(
            onTap: () {
              viewModel.navigateToCartView();
            },
          ),
        ),
        Positioned(
            left: 20.w,
            top: 20.h,
            child: InkWell(
              splashColor: Colors.blue, // Customize splash color
              onTap: () {
                viewModel.back();
              },
              child: const CircleAvatar(
                backgroundColor: kcWhitColor,
                child: Icon(
                  Icons.arrow_back,
                  color: kcBlackColor,
                ),
              ),
            )),
      ],
    );
  }

  @override
  RestaurantDetailViewModel viewModelBuilder(BuildContext context) =>
      RestaurantDetailViewModel(restaurantId, foodId);
}
