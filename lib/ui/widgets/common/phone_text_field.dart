import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class InputPhoneNumberField extends StatelessWidget {
  const InputPhoneNumberField({
    required this.controller,
    required this.onChanged,
    this.focusNode,
    super.key,
    this.onCodeChange,
    this.disableLengthCheck,
  });
  final TextEditingController controller;
  final void Function(PhoneNumber)? onChanged;
  final void Function(Country)? onCodeChange;
  final FocusNode? focusNode;
  final bool? disableLengthCheck;

  @override
  Widget build(BuildContext context) {
    BuildContext _ = context;
    return Container(
      color: Colors.white,
      child: IntlPhoneField(
        controller: controller,
        focusNode: focusNode,
        flagsButtonMargin: EdgeInsets.only(left: 5.w),
        dropdownIcon: const Icon(Icons.arrow_drop_down, color: kcPrimaryColor),
        disableLengthCheck: disableLengthCheck ?? true,
        dropdownTextStyle: TextStyle(fontSize: 15.sp),
        cursorColor: kcPrimaryColor,
        autofocus: false,
        style: inputTheme(_)
            .hintStyle
            ?.copyWith(fontSize: 15.sp, height: 1.4, color: kcPrimaryColorDark),
        decoration: InputDecoration(
          counterStyle: inputTheme(_).hintStyle?.copyWith(fontSize: 10.sp),
          fillColor: inputTheme(_).fillColor,
          // hintText: S.of(context).phoneNumber,
          hintText: 'Phone number',
          hintStyle: inputTheme(_).hintStyle,
          enabledBorder: inputTheme(_).enabledBorder,
          border: inputTheme(_).border,
          focusedBorder: inputTheme(_).focusedBorder,
        ),
        initialCountryCode: "GB",
        onChanged: onChanged,
        onCountryChanged: onCodeChange,
        validator: (p0) {
          if (p0?.number == null || p0!.number.isEmpty) {
            return 'Please enter your phone number';
          }
          if (p0.number.startsWith('0')) {
            return 'Enter your phone number without 0';
          }
          if (p0.number.length < 10) {
            return 'Invalid Mobile Number';
          }
          if (p0.number.length > 11) {
            return 'Invalid Mobile Number ';
          }
          return null;
        },
      ),
    );
  }

  InputDecorationThemeData inputTheme(_) => Theme.of(_).inputDecorationTheme;
}
