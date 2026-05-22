import 'package:flutter/material.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/dialogs/progress_indicator/progress.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'rest_review_dialog_model.dart';

class RestReviewDialog extends StackedView<RestReviewDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const RestReviewDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
      BuildContext context, RestReviewDialogModel viewModel, Widget? child) {
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
              Text("How was the order?",
                  style: Theme.of(context).textTheme.bodyMedium),
              12.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Feedback for Restaurant",
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
              12.verticalSpace,
              RatingBar.builder(
                initialRating: viewModel.rating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                unratedColor: kcGreyColor,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  viewModel.rating = rating;
                  viewModel.rebuildUi();
                },
              ),
              12.verticalSpace,
              CustomTextField(
                hintText: "Type here",
                controller: viewModel.controller,
                onChanged: (val) {
                  viewModel.controller.text = val ?? "";
                  viewModel.rebuildUi();
                },
                maxLines: 4,
              ),
              40.verticalSpace,
              CustomElevatedButton(
                  text: "Submit",
                  onPressed: (viewModel.controller.text.isEmpty ||
                          viewModel.rating == 0)
                      ? null
                      : () {
                          viewModel.submitReview(
                              context,
                              request.data['order_id'],
                              request.data['restaurant_id']);
                        }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  RestReviewDialogModel viewModelBuilder(BuildContext context) =>
      RestReviewDialogModel();
}
