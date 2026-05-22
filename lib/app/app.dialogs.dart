// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/error/error_dialog.dart';
import '../ui/dialogs/info_alert/info_alert_dialog.dart';
import '../ui/dialogs/no_internet/no_internet_dialog.dart';
import '../ui/dialogs/rest_review/rest_review_dialog.dart';
import '../ui/dialogs/review_option/review_option_dialog.dart';
import '../ui/dialogs/rider_reivew/rider_review_dialog.dart';

enum DialogType {
  infoAlert,
  error,
  noInternet,
  riderReview,
  restReview,
  reviewOption,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.infoAlert: (context, request, completer) =>
        InfoAlertDialog(request: request, completer: completer),
    DialogType.error: (context, request, completer) =>
        ErrorDialog(request: request, completer: completer),
    DialogType.noInternet: (context, request, completer) =>
        NoInternetDialog(request: request, completer: completer),
    DialogType.riderReview: (context, request, completer) =>
        RiderReviewDialog(request: request, completer: completer),
    DialogType.restReview: (context, request, completer) =>
        RestReviewDialog(request: request, completer: completer),
    DialogType.reviewOption: (context, request, completer) =>
        ReviewOptionDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
