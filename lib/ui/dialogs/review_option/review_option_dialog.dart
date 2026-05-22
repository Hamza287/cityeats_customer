import 'package:flutter/material.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'review_option_dialog_model.dart';

class ReviewOptionDialog extends StackedView<ReviewOptionDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ReviewOptionDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
      BuildContext context, ReviewOptionDialogModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select One to Review?",
                  style: Theme.of(context).textTheme.bodyMedium),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Feedback on order!",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: kcMediumGrey,
                        ),
                    maxLines: 3,
                    softWrap: true,
                  ),
                  InkWell(
                    onTap: () {
                      completer(DialogResponse(confirmed: true));
                    },
                    child: Text(
                      "skip",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: kcMediumGrey,
                          ),
                    ),
                  ),
                ],
              ),
              40.verticalSpace,
              // if (request.data['is_rider_review'] ?? false) ...[
              CustomElevatedButton(
                  text: "Rider",
                  onPressed: (request.data['is_rider_review'] ?? false)
                      ? null
                      : () async {
                          await viewModel.showRiderReviewDialog(
                            request.data['order_id'],
                            request.data['restaurant_id'],
                            request.data['rider_id'],
                          );
                          completer(DialogResponse(confirmed: true));
                          // viewModel.submitReview(context, request.data['order_id'],
                          //     request.data['restaurant_id']);
                        }),
              15.verticalSpace,

              CustomElevatedButton(
                  text: "Restaurant",
                  onPressed: (request.data['is_rest_review'] ?? false)
                      ? null
                      : () async {
                          await viewModel.showRestReviewDialog(
                              request.data['order_id'],
                              request.data['restaurant_id']);
                          completer(DialogResponse(confirmed: true));
                          // viewModel.submitReview(context, request.data['order_id'],
                          //     request.data['restaurant_id']);
                        }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ReviewOptionDialogModel viewModelBuilder(BuildContext context) =>
      ReviewOptionDialogModel();
}
