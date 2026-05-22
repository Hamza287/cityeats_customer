import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTileWithRadioButton extends StatelessWidget {
  const CustomTileWithRadioButton({
    Key? key,
    required this.radioButtonParametersBody,
  }) : super(key: key);
  final RadioAndCheckButtonParameterBody radioButtonParametersBody;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        children: [
          SizedBox(
            width: 1.sw,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    // onTap: radioButtonParametersBody.onTap,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            radioButtonParametersBody.titleWiget,
                            if (radioButtonParametersBody.subtitle != null)
                              FittedBox(
                                fit: BoxFit.contain,
                                child: SizedBox(
                                    width: 160.w,
                                    child: radioButtonParametersBody.subtitle),
                              ),
                          ],
                        ),

                        const Spacer(),
                        if (radioButtonParametersBody.price != "0.00")
                          Text(
                            "+£ ${radioButtonParametersBody.price}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 12.sp,
                                ),
                          ),
                        // CustomRadioButton(
                        //   isSelected: radioButtonParametersBody.isSelected,
                        // ),
                        SizedBox(
                          width: 10.w,
                        ),

                        InkWell(
                          onTap: radioButtonParametersBody.onTap,
                          child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              height: !radioButtonParametersBody.isSelected
                                  ? 22.h
                                  : null,
                              width: !radioButtonParametersBody.isSelected
                                  ? 22.h
                                  : null,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // color: radioButtonParametersBody.isSelected
                                //     ? kcPrimaryColor
                                //     : null,
                                border:
                                    //  radioButtonParametersBody.isSelected
                                    //     ? null:
                                    Border.all(
                                  color: kcGreyColor.withOpacity(0.7),
                                  width: 1.4.w,
                                ),
                              ),
                              child: radioButtonParametersBody.isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      size: 20,
                                      color: kcPrimaryColor,
                                    )
                                  : null
                              // Container(

                              //   decoration: BoxDecoration(
                              //   shape: BoxShape.circle,
                              //   color: radioButtonParametersBody.isSelected
                              //       ? kcPrimaryColor
                              //       : null,
                              //   border: radioButtonParametersBody.isSelected
                              //       ? null
                              //       : Border.all(
                              //           color: kcGreyColor.withOpacity(0.7),
                              //           width: 1.4.w,
                              //         ),
                              // ),
                              // ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                //
                SizedBox(width: 10.w),
                //
              ],
            ),
          ),
          if ((!radioButtonParametersBody.isItHaveSubModifires))
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 33.w, top: 4.h),
                child: Text(
                  radioButtonParametersBody.price,
                  // style: kBody.copyWith(fontSize: 12.sp),
                ),
              ),
            ),
          //
        ],
      ),
    );
  }
}

class RadioAndCheckButtonParameterBody {
  VoidCallback onTap;
  VoidCallback? decrement;
  Widget titleWiget;
  Widget? subtitle;
  bool isItHaveSubModifires;
  bool isSelected;
  String price;
  // int? quantity;

  RadioAndCheckButtonParameterBody({
    required this.onTap,
    this.decrement,
    required this.titleWiget,
    this.subtitle,
    required this.isItHaveSubModifires,
    required this.isSelected,
    required this.price,
    // this.quantity,
  });
}
