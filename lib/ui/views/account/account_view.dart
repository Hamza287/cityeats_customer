import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:city_customer_app/ui/views/cart/cart_viewmodel.dart';
import 'package:city_customer_app/ui/widgets/common/cache_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import 'account_viewmodel.dart';

class AccountView extends StackedView<AccountViewModel> {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, AccountViewModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        backgroundColor: kcLightGreyColor,
        body: SafeArea(
          child: SingleChildScrollView(
          child: Column(
            children: [
              ///
              _topBar(context, viewModel),
              12.verticalSpace,

              ///
              ListView.separated(
                itemCount: viewModel.list.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    if (!viewModel.autService.checkLogin()) {
                      showSnackBar(context, message: "Please Login First");
                      viewModel.navigationService.navigateToLoginView();
                    } else {
                      if (index == 5) {
                        // Show a dialog to confirm exit
                        bool? deleteConfirmed = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Delete Account',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              content: Text(
                                'Do you really want to delete your account?',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    surfaceTintColor: Colors.transparent,
                                    backgroundColor: kcPrimaryColor,
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 12.sp,
                                          color: kcWhiteColor,
                                        ),
                                  ),
                                  onPressed: () {
                                    viewModel.navigationService
                                        .back(result: false);
                                    // GoRouter.of(context).pop(false);
                                    // Navigator.of(context)
                                    //     .pop(false); // Return false to cancel the pop-up
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    surfaceTintColor: Colors.transparent,
                                    backgroundColor: kcPrimaryColor,
                                  ),
                                  child: Text(
                                    'Delete',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 12.sp,
                                          color: kcWhiteColor,
                                        ),
                                  ),
                                  onPressed: () {
                                    viewModel.navigationService
                                        .back(result: true);
                                    // GoRouter.of(context).pop(true);
                                    // Navigator.of(context)
                                    // .pop(true); // Return true to confirm exit
                                  },
                                ),
                              ],
                            );
                          },
                        );

                        if (deleteConfirmed ?? false) {
                          viewModel.onItemTap(index);
                        }
                      } else if (index == 6) {
                        // Show a dialog to confirm exit
                        bool? logoutConfirmed = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Logout',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              content: Text(
                                'Do you want to logout?',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    surfaceTintColor: Colors.transparent,
                                    backgroundColor: kcPrimaryColor,
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 12.sp,
                                          color: kcWhiteColor,
                                        ),
                                  ),
                                  onPressed: () {
                                    viewModel.navigationService
                                        .back(result: false);
                                    // GoRouter.of(context).pop(false);
                                    // Navigator.of(context)
                                    //     .pop(false); // Return false to cancel the pop-up
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    surfaceTintColor: Colors.transparent,
                                    backgroundColor: kcPrimaryColor,
                                  ),
                                  child: Text(
                                    'Logout',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 12.sp,
                                          color: kcWhiteColor,
                                        ),
                                  ),
                                  onPressed: () {
                                    viewModel.navigationService
                                        .back(result: true);
                                  },
                                ),
                              ],
                            );
                          },
                        );

                        if (logoutConfirmed ?? false) {
                          viewModel.onItemTap(index);
                        }
                      } else {
                        viewModel.onItemTap(index);
                      }
                    }
                  },
                  child: _item(context, viewModel.list[index]['item'],
                      viewModel.list[index]['icon']),
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    10.verticalSpace,
              ),
              15.verticalSpace,
            ],
          ),
          ),
        ),
      ),
    );
  }

  Container _item(BuildContext context, String title, IconData icon) {
    return Container(
      width: screenWidth(context),
      decoration: BoxDecoration(
          color: kcWhitColor, borderRadius: BorderRadius.circular(10.r)),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Column(children: [
        Row(
          children: [
            Icon(icon),
            15.horizontalSpace,
            Text(
              // "Order History",
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_outlined),
          ],
        )
      ]),
    );
  }

  Container _topBar(BuildContext context, AccountViewModel viewModel) {
    final cartProvider = Provider.of<CartViewModel>(context, listen: true);
    return Container(
      width: screenWidth(context),
      decoration: BoxDecoration(
          color: kcWhitColor, borderRadius: BorderRadius.circular(10.r)),
      padding:
          EdgeInsets.only(left: 25.w, right: 25.w, top: 5.h, bottom: 24.h),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Account",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            Stack(
              children: [
                cartProvider.cartProducts.isNotEmpty
                    ? Positioned(
                        right: 6.w,
                        top: 4.h,
                        child: Badge(
                          backgroundColor: Colors.amber[700],
                          // smallSize: 22,
                          // largeSize: 20,
                          label: Text(
                            // "3",
                            (cartProvider.cartProducts.length).toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 10.sp),
                          ),
                        ),
                      )
                    : const SizedBox(),
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined, size: 32),
                  onPressed: () {
                    if (!viewModel.autService.checkLogin()) {
                      showSnackBar(context, message: "Please Login First");
                      viewModel.navigationService.navigateToLoginView();
                    } else {
                      viewModel.navigateToCartView();
                    }
                  },
                ),
              ],
            )
          ],
        ),
        16.verticalSpace,
        // CircleAvatar(
        //   radius: 50.r,
        //   foregroundImage: const AssetImage("$kcStaticImagesPath/pro.jpg"),
        // ),
        NetworkImageWidget(
            url: viewModel.user.image ?? "", isProfilePic: true, radius: 50.r),
        20.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              viewModel.user.name!.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            // 10.horizontalSpace,
            if (viewModel.user.userType != "guest")
              IconButton(
                onPressed: () async {
                  if (viewModel.user.id != -1) {
                    await viewModel.navigateToEditProfile();
                    viewModel.getProfile();
                  }
                },
                icon: Icon(
                  Icons.edit,
                  color: kcBlackColor.withOpacity(0.4),
                ),
              )
          ],
        ),
        5.verticalSpace,
        Text(
          viewModel.user.email ?? "",
          // "ahsanahmad43@gmail.com",
          style:
              Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
        ),

        // Center(
        //   child: MaterialButton(
        //     onPressed: () {
        //       viewModel.navigateToOrders();
        //     },
        //     child: const Text("orders"),
        //   ),
        // ),
        // Center(
        //   child: MaterialButton(
        //     onPressed: () {
        //       viewModel.logout();
        //     },
        //     child: const Text("Logout"),
        //   ),
        // )
      ]),
    );
  }

  @override
  AccountViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AccountViewModel();
}
