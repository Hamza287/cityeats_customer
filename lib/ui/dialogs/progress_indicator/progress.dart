import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator(
      {super.key, required this.isLoading, required this.child});
  final bool isLoading;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
      blurEffectIntensity: 0,
      progressIndicator:
          const SpinKitFadingCircle(color: kcPrimaryColor, size: 60),
      dismissible: false,
      opacity: 1,
      color: kcScaffoldBackgroundColor.withOpacity(0.2),
      child: child,
    );
  }
}
