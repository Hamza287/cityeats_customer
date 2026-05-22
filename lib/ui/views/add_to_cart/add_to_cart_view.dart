import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add_to_cart_viewmodel.dart';

class AddToCartView extends StackedView<AddToCartViewModel> {
  const AddToCartView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, AddToCartViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  AddToCartViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddToCartViewModel();
}
