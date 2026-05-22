import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/views/cart/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CartIconWidget extends StatelessWidget {
  const CartIconWidget({super.key, this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, viewModel, child) => InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 23.r,
              backgroundColor: kcPrimaryColor,
              child: Icon(Icons.shopping_basket, size: 22.w),
            ),
            if (viewModel.cartProducts.isNotEmpty)
              Badge(
                smallSize: 20,
                offset: const Offset(20, 31),
                label: Text((viewModel.cartProducts.length).toString()),
                backgroundColor: kcBlackColor,
              ),
          ],
        ),
      ),
    );
  }
}
