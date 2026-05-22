import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/responses/cart_response.dart';
import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'order_confirmed_viewmodel.dart';

class OrderConfirmedView extends StackedView<OrderConfirmedViewModel> {
  const OrderConfirmedView({super.key, required this.cart});
  final Cart cart;

  @override
  Widget builder(
    BuildContext context,
    OrderConfirmedViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcLightGreyColor,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            100.verticalSpace,
            Image.asset(
              "$kcStaticImagesPath/rec_icn.png",
              // "$kcStaticImagesPath/pre.png",
              height: 80.h,
              width: 80.w,
            ),
            12.verticalSpace,
            Text(
              "Thank You!",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: 24.sp),
            ),
            12.verticalSpace,
            Text(
              "Your order has been confirmed. ",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 12.sp),
            ),
            40.verticalSpace,
            Container(
              height: 6.h,
              width: 374.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: kcGreyColor,
              ),
            ),
            40.verticalSpace,
            Container(
              color: kcWhitColor,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 10.h),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       "123456",
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .bodyMedium
                    //           ?.copyWith(
                    //               color: kcBlackColor,
                    //               fontWeight: FontWeight.w600),
                    //     ),
                    //     8.verticalSpace,
                    //     Text(
                    //       "Order ID",
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .bodyMedium
                    //           ?.copyWith(
                    //               color: kcBlackColor.withOpacity(0.5),
                    //               fontSize: 10.sp),
                    //     ),
                    //   ],
                    // ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "£${cart.total}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: kcBlackColor,
                                  fontWeight: FontWeight.w600),
                        ),
                        8.verticalSpace,
                        Text(
                          "Order Amount",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: kcBlackColor.withOpacity(0.5),
                                  fontSize: 10.sp),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Online",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: kcBlackColor,
                                  fontWeight: FontWeight.w600),
                        ),
                        8.verticalSpace,
                        Text(
                          "Payment",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: kcBlackColor.withOpacity(0.5),
                                  fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ]),
            ),
            Divider(
              color: kcBlackColor.withOpacity(0.2),
              height: 0,
            ),
            Container(
              color: kcWhitColor,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.receipt_long_outlined,
                      ),
                      12.horizontalSpace,
                      Text(
                        // "Yasir Broast",
                        cart.restaurant?.name ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  15.verticalSpace,
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: cart.cartProducts?.length ?? 0,
                    itemBuilder: (context, index) => Text(
                      // "x1        Chicken Broast with pepsi (Half)",
                      "x ${cart.cartProducts?[index].productCount}   \t ${cart.cartProducts?[index].productName ?? ""}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 12.sp,
                            color: kcBlackColor.withOpacity(0.6),
                            letterSpacing: 1.1,
                          ),
                    ),
                    separatorBuilder: (context, index) => 12.verticalSpace,
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomElevatedButton(
                text: "Track Your Order",
                onPressed: () {
                  viewModel.navigateToOrderView();
                }),
            50.verticalSpace,
          ]),
        ),
      ),
    );
  }

  @override
  OrderConfirmedViewModel viewModelBuilder(BuildContext context) =>
      OrderConfirmedViewModel();
}
