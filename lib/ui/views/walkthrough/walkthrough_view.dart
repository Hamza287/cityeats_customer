import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:stacked/stacked.dart';

import 'walkthrough_viewmodel.dart';

class WalkthroughView extends StackedView<WalkthroughViewModel> {
  const WalkthroughView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    WalkthroughViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcWhitColor,
      floatingActionButton: buildFloatingActionButton(viewModel),
      body: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 30,
            child: DotsIndicator(
              onTap: (int index) {},
              dotsCount: 3,
              position: viewModel.currentPage,
              decorator: const DotsDecorator(
                color: kcGreyColor, // Inactive color
                activeColor: kcPrimaryColor,
              ),
            ),
          ),
          PageView(
            onPageChanged: (int page) {
              // Update the current page when the PageView changes
              viewModel.togglePage(page);
            },
            controller: viewModel.pageController,
            children: viewModel.walkthroughScreens,
          ),
        ],
      ),
    );
  }

  buildFloatingActionButton(WalkthroughViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        if (viewModel.currentPage == 2) {
          ///
          viewModel.saveOnBoarding();
          viewModel.navigateToWelcome();
        } else {
          viewModel.pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        }
      },
      child: const CircleAvatar(
        backgroundColor: kcBlackColor,
        radius: 25,
        child: Icon(
          Icons.arrow_forward,
          color: kcWhitColor,
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale().then(delay: 400.ms);
  }

  @override
  WalkthroughViewModel viewModelBuilder(BuildContext context) =>
      WalkthroughViewModel();
}

class WalkthroughScreen extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const WalkthroughScreen({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.asset(image)
            .animate()
            .slide(duration: 800.ms)
            .scale()
            .then(delay: 400.ms),
        const SizedBox(height: 30.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 25.0),
              Text(
                description,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
