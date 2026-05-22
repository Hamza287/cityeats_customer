import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';
import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/common/ui_helpers.dart';
import 'package:city_customer_app/ui/custom_widgets/submodifiers_list.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:city_customer_app/ui/widgets/common/cache_network_image.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../responses/cart_response.dart';
import 'cart_viewmodel.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
        builder: (context, viewModel, child) => CustomProgressIndicator(
              isLoading: viewModel.isBusy,
              child: Scaffold(
                backgroundColor: kcLightGreyColor,
                appBar: _appBar(context, viewModel),
                body: SafeArea(
                  child: RefreshIndicator(
                  color: kcPrimaryColor,
                  onRefresh: () {
                    return viewModel.getMyCart(isRefresh: true);
                  },
                  child: viewModel.cartProducts.isEmpty && !viewModel.isBusy
                      ? EmptyBasket(viewModel: viewModel)
                      : cartBody(context, viewModel),
                  ),
                ),
              ),
            ));
  }

  ListView cartBody(BuildContext context, CartViewModel viewModel) {
    return ListView(
      children: [
        Column(
          children: [
            _top(context, viewModel.cartProducts.length),
            if (viewModel.cart != null)
              _cartList(
                viewModel.cart!,
                viewModel.cartProducts,
                viewModel,
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                30.verticalSpace,
                _total(context,
                    (viewModel.cart?.subTotal ?? 0).toStringAsFixed(2)),
                10.verticalSpace,
                _addNoteField(context, viewModel),
                verticalSpaceMedium,
                _checkoutButton(context, viewModel),
                12.verticalSpace,
              ],
            ),
          ],
          // ],
        ),
      ],
    );
  }

  // _scheduleOrderField(BuildContext context, CartViewModel viewModel) {
  //   return InkWell(
  //     onTap: () {
  //       viewModel.openScheduleSheet();
  //     },
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 20.w),
  //       width: 1.sw,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           SizedBox(width: 4.w),
  //           Container(
  //             width: 1.sw - 60.w,
  //             decoration: BoxDecoration(
  //               color: Color(0xFFECF1F6),
  //               borderRadius: BorderRadius.circular(40.r),
  //             ),
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(
  //                 vertical: 4.0.h,
  //                 horizontal: 10.w,
  //               ),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     viewModel.chosenDate != null &&
  //                             viewModel.chosenSlot != null
  //                         ? '${viewModel.getDayOfWeek(viewModel.chosenDate!)}, '
  //                             '${viewModel.dateTimeService.convertIntoAmPmDate(viewModel.chosenSlot?.startTime ?? " ")} - ${viewModel.dateTimeService.convertIntoAmPmDate(viewModel.chosenSlot?.endTime ?? " ")}'
  //                         : 'Now',
  //                     style: TextStyle(
  //                         fontSize: 14.sp, fontWeight: FontWeight.w600),
  //                     overflow: TextOverflow.ellipsis, // 🔥 Prevent overflow
  //                     maxLines: 1,
  //                   ),
  //                   SizedBox(width: 4.w),
  //                   Icon(
  //                     Icons.keyboard_arrow_down_rounded,
  //                     color: kcPrimaryColor,
  //                     size: 26.h,
  //                   )
  //                 ],
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //     // Container(
  //     //   width: screenWidth(context),
  //     //   color: kcWhiteColor,
  //     //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
  //     //   child: Row(
  //     //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     //     children: [
  //     //       Row(
  //     //         children: [
  //     //           const Icon(Icons.schedule),
  //     //           12.horizontalSpace,
  //     //           Text(
  //     //             "Order Scheduled For:",
  //     //             style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //     //                   fontSize: 16.sp,
  //     //                   fontWeight: FontWeight.bold,
  //     //                 ),
  //     //           ),
  //     //         ],
  //     //       ),
  //     //       Row(
  //     //         children: [
  //     //           Text(
  //     //             viewModel.chosenDate != null && viewModel.chosenSlot != null
  //     //                 ? "${viewModel.chosenDate} , ${viewModel.chosenSlot}"
  //     //                 : "Now",
  //     //             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //     //                   fontSize: 14.sp,
  //     //                   color: kcMediumGrey,
  //     //                 ),
  //     //           ),
  //     //           Icon(
  //     //             Icons.keyboard_arrow_down_outlined,
  //     //             size: 20.sp,
  //     //             color: kcMediumGrey,
  //     //           )
  //     //         ],
  //     //       )
  //     //     ],
  //     //   ),
  //     // ),
  //   );
  // }

  AppBar _appBar(BuildContext context, CartViewModel viewModel) {
    return AppBar(
      // elevation: 1,
      backgroundColor: kcWhitColor,
      shadowColor: kcWhitColor,
      title: Text(
        "My Cart",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: viewModel.cartProducts.isEmpty
              ? null
              : () {
                  viewModel.clearCart();
                },
          child: Text(
            "clear",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: viewModel.cartProducts.isEmpty
                    ? kcLightGrey
                    : kcBlackColor),
          ),
        )
      ],
    );
  }

  ListView _cartList(
      Cart cart, List<CartProducts> cartProducts, CartViewModel viewModel) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: cartProducts.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) =>
          _cartItem(context, cartProducts[index], cart, viewModel, index),
      separatorBuilder: (BuildContext context, int index) => 12.verticalSpace,
    );
  }

  Padding _checkoutButton(BuildContext context, CartViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: CustomElevatedButton(
        size: Size(374.w, 48.h),
        text: "Checkout",
        onPressed: () {
          viewModel.navigateToCheckout();
        },
      ),
    );
  }

  Container _addNoteField(BuildContext context, CartViewModel viewModel) {
    return Container(
      width: screenWidth(context),
      color: kcWhiteColor,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.chat_bubble_outline),
              12.horizontalSpace,
              Text(
                "Add Notes",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          16.verticalSpace,
          CustomTextField(
            hintText: "What else do you want us to know?",
            maxLines: 4,
            controller: viewModel.noteController,
            onChanged: (val) {},
          ),
          10.verticalSpace,
        ],
      ),
    );
  }

  Padding _top(BuildContext context, int length) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("My Basket",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18.sp,
                  )),
          Text(length > 1 ? "$length Products" : "$length Product",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 12.sp)),
        ],
      ),
    );
  }

  Padding _total(BuildContext context, String total) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 23.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Basket Total ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                  )),
          Text("£$total",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _cartItem(BuildContext context, CartProducts product, Cart cart,
      CartViewModel viewModel, int index) {
    List<SubModifiers> subModifers = viewModel.getProductSubmod(product);
    return Dismissible(
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      onDismissed: (direction) {
        viewModel.removeItem(product);
        showSnackBar(context, message: "product removed");
      },
      key: Key(cart.id.toString()),
      child: Column(
        children: [
          Container(
            width: screenWidth(context),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            color: kcWhiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productNameAndImageWidget(
                    product, context, index, viewModel, subModifers),
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            if (product.discount != 0) ...[
                              TextSpan(
                                  text:
                                      "£${((product.totalPrice ?? 0) + (product.discount)).toStringAsFixed(2)} ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 12.sp,
                                        color: kcGreyColor,
                                        fontWeight: FontWeight.w400,
                                        decorationColor: kcLightGrey,
                                        decorationThickness: 1.5,
                                        decoration: TextDecoration.lineThrough,
                                      )),
                            ],
                            TextSpan(
                                text:
                                    " £${(product.totalPrice ?? 0).toStringAsFixed(2)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                    )),
                          ],
                        ),
                      ),
                      8.horizontalSpace,
                      Container(
                        height: 20.h,
                        width: 20.w,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: kcPrimaryColor,
                        ),
                        child: Text(" x${product.productCount}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 9.sp,
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ]),
                    if (product.discount != 0) discountBannerWidget(product),
                  ],
                ),
                16.verticalSpace,
                priceAndCountWidget(product, context, viewModel),
              ],
            ),
          ),
          7.verticalSpace,
          if (product.sideItems.isNotEmpty)
            Container(
                width: screenWidth(context),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                color: kcWhiteColor,
                child: Column(children: [
                  if (product.sideItems.isNotEmpty) ...[
                    10.verticalSpace,
                    Row(
                      children: [
                        Text("Side Items (${product.productName ?? ""})",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    5.verticalSpace,
                    ListView.separated(
                      itemBuilder: (context, index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.sideItems[index].sideItemName ?? "",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          40.horizontalSpace,
                          Text(
                            "£ ${product.sideItems[index].sideItemPrice ?? ""}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      separatorBuilder: (context, index) => 2.verticalSpace,
                      shrinkWrap: true,
                      itemCount: product.sideItems.length,
                    ),
                  ]
                ])),
        ],
      ),
    );
  }

  Container discountBannerWidget(CartProducts product) {
    return Container(
      // width: 1.w,
      height: 25.h,
      // margin: EdgeInsets.symmetric(horizontal: 10.w),

      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Color.fromARGB(255, 247, 181, 15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          product.discountAdded < 0
              ? "  You got  £${(product.discountAdded * -1).toStringAsFixed(2)} discount! 🎉  "
              : "You got  £${(product.discountAdded.toStringAsFixed(2))} discount! 🎉",
          style: TextStyle(
              color: kPureBlackColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  GestureDetector showMoreButton(CartViewModel viewModel, int index,
      CartProducts product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        viewModel.toggleShowMore(index);
      },
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(color: kcPrimaryColor.withOpacity(0.1)),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              product.showMore ? "View less" : " View more",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    // decoration: TextDecoration.underline,
                    // decorationThickness: 1.2.h
                  ),
            ),
            Icon(
              product.showMore
                  ? Icons.keyboard_arrow_up_outlined
                  : Icons.keyboard_arrow_down_outlined,
              color: kcPrimaryColor,
              size: 20.sp,
            )
          ],
        ),
      ),
    );
  }

  Row productNameAndImageWidget(CartProducts product, BuildContext context,
      int index, CartViewModel viewModel, List<SubModifiers> submodifiers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  // "Chicken Broast",
                  product.productName ?? "",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      )),
              4.verticalSpace,
              submodifiers.isNotEmpty
                  ? showMoreButton(viewModel, index, product, context)
                  : SizedBox(
                      height: 10.h,
                    ),
              product.showMore
                  ? SubModifiersList(subModifers: submodifiers)
                  : const SizedBox(),
              //
              10.verticalSpace,
            ],
          ),
        ),
        12.horizontalSpace,
        SizedBox(
            height: 80.h,
            width: 80.w,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: NetworkImageWidget(
                  url: product.productImage ?? "",
                )))
      ],
    );
  }

  Row priceAndCountWidget(
      CartProducts product, BuildContext context, CartViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: Text("£ ${(product.totalPrice ?? 0).toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  )),
        ),

        const Spacer(),
        // 120.horizontalSpace,
        InkWell(
          onTap: () {
            if ((product.productCount ?? 0) == 1) {
              viewModel.removeItem(product);
            }
            if ((product.productCount ?? 0) > 1) {
              viewModel.decrementItem(product);
            }
          },
          child: CircleAvatar(
            radius: 15.r,
            backgroundColor: kcPrimaryColor,
            child: const Icon(Icons.remove, color: kcWhiteColor, size: 15),
          ),
        ),
        13.horizontalSpace,
        Text(
          "${product.productCount}",
          // "1",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
        ),
        13.horizontalSpace,
        InkWell(
          onTap: () {
            // if ((product.productCount ?? 0) > 1) {
            viewModel.incrementItem(product);
            // }
          },
          child: CircleAvatar(
            radius: 15.r,
            backgroundColor: kcPrimaryColor,
            child: const Icon(Icons.add, color: kcWhiteColor, size: 15),
          ),
        ),
      ],
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.red,
      child: const Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: const Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyBasket extends StatelessWidget {
  const EmptyBasket({super.key, required this.viewModel});
  final CartViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            "$kcStaticImagesPath/ion_basket.png",
            height: 100.h,
            width: 100.w,
          ),
          12.verticalSpace,
          Text("Ah... Empty Basket?!",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
          12.verticalSpace,
          Text("Fill your basket and heart with some food...",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 13)),
          40.verticalSpace,
          CustomElevatedButton(
              text: "Continue Shopping",
              onPressed: () {
                viewModel.navigateToHome();
              })
        ]),
      ),
    );
  }
}
