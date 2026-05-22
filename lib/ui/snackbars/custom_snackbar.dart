import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
showSnackBar(BuildContext context, {String? message}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: kcPrimaryColor,
      closeIconColor: kcScaffoldBackgroundColor,
      showCloseIcon: true,
      content: Text(message ?? 'snackBar message',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: kcWhitColor)),
    ),
  );
}
