import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import 'root_viewmodel.dart';

class RootView extends StackedView<RootViewModel> {
  const RootView({super.key, this.index = 0});
  final int index;

  @override
  Widget builder(BuildContext context, RootViewModel viewModel, Widget? child) {
    // ignore: deprecated_member_use
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: WillPopScope(
        onWillPop: () async {
          // Show the exit confirmation dialog
          bool exitConfirmed = await _onBackPressed(context);
          return exitConfirmed;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: viewModel.currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: kcPrimaryColor,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_offer),
                  label: 'Deals',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Account',
                ),
              ],
              onTap: (index) {
                viewModel.togglePage(index, context);
              }),
          body: viewModel.getPages[viewModel.currentIndex],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Confirm Exit',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: kcBlackColor),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Yes',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: kcBlackColor),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  RootViewModel viewModelBuilder(BuildContext context) =>
      RootViewModel(index, context);
}
