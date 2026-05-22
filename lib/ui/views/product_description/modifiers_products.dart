import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:city_customer_app/ui/views/product_description/product_description_viewmodel.dart';
import 'package:city_customer_app/ui/views/product_description/widgets/custom_ratio_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// This ModifiersProductsArea is used to show the modifers in the product details screen
// only for product details screen not for sub modifers screen
// I just refactored this code to make it more readable and understandable
// Thats why I have added this here.

// Why its Stateful?
// Because we need to add the modifers to the selected tree list in the initial phase
// and we use maniuplate the selected tree list it will rebuild the UI so we need to make it stateful

class ModifiersProductsArea extends StatefulWidget {
  const ModifiersProductsArea({Key? key, required this.modifiers})
      : super(key: key);

  final List<Modifiers> modifiers;

  @override
  State<ModifiersProductsArea> createState() => _ModifiersProductsAreaState();
}

class _ModifiersProductsAreaState extends State<ModifiersProductsArea> {
  @override
  void initState() {
    super.initState();
    // addModifersToSelectedTree();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDescriptionViewModel>(
      builder: (context, model, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < widget.modifiers.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                ModiferNameWidget(
                  modifiers: widget.modifiers,
                  i: i,
                ),

                // CheckRulesAndShowCationText(
                //   i: i,
                //   modifiers: widget.modifiers,
                // ),

                SizedBox(
                  height: 10.h,
                ),

                for (int j = 0;
                    j < widget.modifiers[i].subModifiers!.length;
                    j++)
                  Column(
                    children: [
                      //
                      if (_checkItsRadioButton(i))
                        CustomTileWithRadioButton(
                          radioButtonParametersBody:
                              _getRadioButtonParametersBody(
                            i: i,
                            j: j,
                            model: model,
                          ),
                        ),

                      if (_checkIsCheckButton(
                        i,
                      ))
                        CustomTileWithRadioButton(
                          radioButtonParametersBody:
                              _getRadioButtonParametersBody(
                            i: i,
                            j: j,
                            model: model,
                          ),
                        ),

                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }

  bool _checkItsRadioButton(
    int i,
  ) {
    if (widget.modifiers[i].type == 'single') {
      return true;
    } else {
      return false;
    }
  }

  bool _checkIsCheckButton(
    int i,
  ) {
    if (widget.modifiers[i].type == 'multiple') {
      return true;
    } else {
      return false;
    }
  }

  RadioAndCheckButtonParameterBody _getRadioButtonParametersBody({
    required int i,
    required int j,
    required ProductDescriptionViewModel model,
  }) {
    //
    return RadioAndCheckButtonParameterBody(
      //
      price: _getPrice(i: i, j: j),

      isSelected: _isItSelected(
          i: i, j: j, model: model, modifierProductsList: widget.modifiers[i]),

      onTap: _onTap(
          i: i,
          j: j,
          model: model,
          isRadioButton: true,
          modifierProductsList: widget.modifiers[i]),

      titleWiget: _getTitle(i: i, j: j),
      //
      subtitle: _getSubTitle(i: i, j: j),
      //
      isItHaveSubModifires: _isItHaveSubModifires(i: i, j: j),
    );
  }

  // RadioAndCheckButtonParameterBody _getCheckButtonParameterBody(
  //     {required int i,
  //     required int j,
  //     required ProductDescriptionViewModel model}) {
  //   //
  //   return RadioAndCheckButtonParameterBody(
  //     //
  //     price: _getPrice(i: i, j: j),

  //     isSelected: _isItSelected(i: i, j: j),

  //     onTap: _onTap(
  //         i: i,
  //         j: j,
  //         model: model,
  //         isRadioButton: false,
  //         modifierProductsList:
  //             widget.modifiersProductsParameterBody.modifierProductsList),

  //     titleWiget: _getTitle(i: i, j: j),
  //     //
  //     subtitle: _getSubTitleList(i: i, j: j),
  //     //
  //     isItHaveSubModifires: _isItHaveSubModifires(i: i, j: j),
  //   );
  // }

//   //

//   //
//   //
  bool _isItSelected({
    required int i,
    required int j,
    required Modifiers modifierProductsList,
    required ProductDescriptionViewModel model,
  }) {
    // if (modifierProductsList.optionStatus == "mandatory" && model.selectedSubModifiers.isEmpty) {
    //   model.selectedSubModifiers.add(modifierProductsList.subModifiers![0]);
    // }
    model.log.wtf(
        "isITSelected:${model.selectedSubModifiers.contains(modifierProductsList.subModifiers![j])}");
    return model.selectedSubModifiers
        .contains(modifierProductsList.subModifiers![j]);
  }

  String _getPrice({required int i, required int j}) {
    return widget.modifiers[i].subModifiers![j].price!.toStringAsFixed(2);
  }

//   /// get sub title list of the product or modifer /////
  Text _getSubTitle({required int i, required int j}) {
    return Text(
      '${widget.modifiers[i].subModifiers![j].description ?? ' '} ',
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontSize: 10.sp, color: Colors.black54),
    );
  }

// //// is not already selected ////////////////
//   ///
//   ///
  bool _isNotAlreadySelected(
      {required int i,
      required int j,
      required Modifiers modifierProductsList,
      required ProductDescriptionViewModel model}) {
    if (model.selectedSubModifiers
            .contains(modifierProductsList.subModifiers![j]) ==
        true) {
      return false;
    }

    return true;
  }

  _onTap({
    required int i,
    required int j,
    required bool isRadioButton,
    required ProductDescriptionViewModel model,
    required Modifiers modifierProductsList,
  }) {
    return () async {
      //
      if (_isNotAlreadySelected(
          i: i,
          j: j,
          model: model,
          modifierProductsList: modifierProductsList)) {
        //
        if (_checkTheRules(i, j, model, isRadioButton, modifierProductsList)) {
          model.selectedSubModifiers.add(modifierProductsList.subModifiers![j]);
          model.findTotal();
          setState(() {});
          //
        } else {
          showSnackBar(context, message: "You can't choose multiple options.");
        }
      } else {
        // remove it
        _removeProduct(i, j, model, modifierProductsList);

        model.findTotal();

        setState(() {});
      }
    };
  }

// //
// //
// //// Remove Product Function //////////////////////////
//   ///
  void _removeProduct(
      int i, int j, ProductDescriptionViewModel model, Modifiers modifier) {
    //

    model.selectedSubModifiers
        .removeWhere((element) => element.id == modifier.subModifiers![j].id);
  }

  bool _checkTheRules(
    int i,
    int j,
    ProductDescriptionViewModel model,
    bool isRadioButton,
    Modifiers modifierProductsList,
  ) {
    if (modifierProductsList.type == 'multiple') {
      return true;
    } else if (modifierProductsList.type == 'single' &&
        model.selectedSubModifiers.isEmpty) {
      return true;
    } else if (modifierProductsList.type == 'single' &&
        model.selectedSubModifiers.isNotEmpty) {
      bool flag = false;
      model.log.d("SUBMOD ID : ${modifierProductsList.subModifiers![j].id}");
      for (int a = 0; a < model.selectedSubModifiers.length; a++) {
        model.log.d("ModifierID:${model.selectedSubModifiers[a].id}");
        if (model.selectedSubModifiers[a].id !=
            modifierProductsList.subModifiers![j].id) {
          for (int b = 0; b < modifierProductsList.subModifiers!.length; b++) {
            SubModifiers subModifier = modifierProductsList.subModifiers![b];
            model.selectedSubModifiers
                .removeWhere((element) => element.id == subModifier.id);
          }
          flag = true;
          break;
        }
      }
      return flag;
    } else {
      return true;
    }
  }

// //////////////// get title actually a product name //////////////////////
// //
  Text _getTitle({required int i, required int j}) {
    return Text(
      '${widget.modifiers[i].subModifiers![j].name}',
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
    );
  }

// //
// //
// //

// //////////////////////////////// is it  have sub modifires or tree ///////////////////////
  bool _isItHaveSubModifires({required int i, required int j}) {
    return widget.modifiers[i].subModifiers!.isNotEmpty;
  }
}

// //
// //
// //
// //////////////////////////////// _AwarenessDialog ////////////////////////////////
// class _AwarenessDialog extends StatelessWidget {
//   const _AwarenessDialog({
//     required this.i,
//     required this.modifierProductsList,
//     required this.model,
//     Key? key,
//   }) : super(key: key);

//   final int i;
//   final List<ModifierProducts> modifierProductsList;
//   final ProductDetailsViewModel model;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       // title:
//       content: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Oops!', style: kH4),
//               InkWell(
//                 onTap: () {
//                   // Get.back();
//                   GoRouter.of(context).pop();
//                 },
//                 child: Icon(
//                   Icons.close,
//                   size: 16.h,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           Text(
//               'You\'ve chosen too many option for ${modifierProductsList[i].modifier!.name}. Please select only ${model.rulesList[i].minSelectionPerGroup} option and try again.'
//               // 'You can\'t select more than ${model.rulesList[i].minSelectionPerGroup} Products for ${modifierProductsList[i].modifier!.name}',
//               ),
//         ],
//       ),
//       actions: [
//         // TextButton(
//         //   onPressed: () {
//         //     Get.back();
//         //   },
//         //   child: Text(
//         //     'Ok',
//         //     style: kH1.copyWith(fontWeight: FontWeight.w600),
//         //   ),
//         // )
//       ],
//     );
//   }
// }

class CheckRulesAndShowCationText extends StatelessWidget {
  const CheckRulesAndShowCationText({
    Key? key,
    required this.i,
    required this.modifiers,
  }) : super(key: key);

  final int i;
  final List<Modifiers> modifiers;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDescriptionViewModel>(
      builder: (context, model, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          if (modifiers[i].optionStatus == "mandatory")
            Text(
              'required',
              style: TextStyle(color: Colors.red, fontSize: 10.sp),
            ),
        ],
      ),
    );
  }
}

class ModiferNameWidget extends StatelessWidget {
  const ModiferNameWidget({
    Key? key,
    required this.modifiers,
    required this.i,
  }) : super(key: key);

  final List<Modifiers> modifiers;
  final int i;

  @override
  Widget build(BuildContext context) {
    //
    return RichText(
        text: TextSpan(
            text: '${modifiers[i].name}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
            children: [
          TextSpan(
            text: modifiers[i].optionStatus == "mandatory"
                ? " (Required)"
                : " (Optional)",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 12.sp, color: Colors.black87),
          )
        ]));
  }
}

// class SubModifersScreenParameterBody {
//   String requestProductId;
//   String productName;
//   int lastModifireId;
//   int index;
//   int productId;
//   int popCount;
//   OrderType orderType;

//   SubModifersScreenParameterBody({
//     required this.requestProductId,
//     required this.productName,
//     required this.lastModifireId,
//     required this.index,
//     required this.productId,
//     required this.popCount,
//     required this.orderType,
//   });
