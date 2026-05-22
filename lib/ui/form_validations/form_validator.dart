// ignore_for_file: depend_on_referenced_packages

import 'package:city_customer_app/extensions/string_extensions.dart';
import 'package:get/get.dart';

class FormFieldsValidator {
  static String? validateNameText(String? value) {
    if (value!.containsNumber()) {
      // return 'No numbers allowed';
      return "Enter name without numbers";
    }

    //   if (value.length >= 150) {
    //     return S.of(getContext).nameTooLongText;
    //   }
    //   if (value.containsAnySpecialCharacter()) {
    //     // return 'No special characters allowed';
    //     return S.of(getContext).noSpecialCharactersText;
    //   }
    return null;
  }

  static String? validateEmailText(String? value) {
    if (value!.isValidEmail() || value.isEmpty) {
      return null;
    }
    if (value.length >= 150) {
      // return 'Email too long';
      // return "S.of(getContext).emailTooLongText";
      return "Email too long";
    }
    if (!value.isValidEmail()) {
      return 'Please enter a valid email address';
      // return "S.of(getContext).notValidEmailText";
    }
    return null;
  }

  // static String? isEmpty(String? value) {
  //   if (value!.isEmpty) return S.of(getContext).fieldRequiredText;
  //   return null;
  // }

  static String? validatePhoneNumber(String? value) {
    if (value!.isPhoneNumber || value.isEmpty) {
      return null;
    } else if (!value.isPhoneNumber) {
      return 'Invalid phone number';
      // return "S.of(getContext).invalidPhoneNumberText";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password!.isEmpty) {
      return null;
    } else if (isNotValidPassword(password)) {
      // return "S.of(getContext).notValidPassText";
      return "Password must be 8-32 characters with 1 uppercase,1 number and 1 special character";
    } else {
      return null;
    }
  }

  static String? validateCPassword(String? password, String? cPassword) {
    if (cPassword!.isEmpty) {
      return null;
    } else if (password != cPassword) {
      // return "S.of(getContext).notValidPassText";
      return "Password and confirm password are not matching";
    } else {
      return null;
    }
  }

  static String? validateFieldEmpty(String? text) {
    if (text?.isEmpty ?? true) {
      return "Field is required";
    }
    return null;
  }

  ///
  /// Return true if Password doesn't contain Capital letter, or
  /// any special Character, or any number, or its length is not in
  /// the range of 8 - 32 characters.
  ///
  static isNotValidPassword(String password) {
    return !password.containsUpperCaseLetter() ||
        !password.containsAnySpecialCharacter() ||
        !password.containsNumber() ||
        password.isNotPasswordLength();
  }

  // static String? validatePassword(String? password) {
  //   if (password!.isEmpty) {
  //     return null;
  //   } else if (!password.containsUpperCaseLetter()) {
  //     return S.of(getContext).upperCaseLetterText;
  //   } else if (!password.containsAnySpecialCharacter()) {
  //     return S.of(getContext).specialCharacterText;
  //   } else if (!password.containsNumber()) {
  //     return S.of(getContext).oneNumberText;
  //   } else if (password.isPasswordLength()) {
  //     return S.of(getContext).passLengthText;
  //   } else {
  //     return null;
  //   }
  // }
}
