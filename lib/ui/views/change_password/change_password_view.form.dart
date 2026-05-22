// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:city_customer_app/ui/form_validations/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String PasswordValueKey = 'password';
const String NewPasswordValueKey = 'new_password';
const String ConfirmPasswordValueKey = 'confirm_password';

final Map<String, TextEditingController>
    _ChangePasswordViewTextEditingControllers = {};

final Map<String, FocusNode> _ChangePasswordViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _ChangePasswordViewTextValidations = {
  PasswordValueKey: FormFieldsValidator.validatePassword,
  NewPasswordValueKey: FormFieldsValidator.validatePassword,
  ConfirmPasswordValueKey: null,
};

mixin $ChangePasswordView {
  TextEditingController get passwordController =>
      _getFormTextEditingController(PasswordValueKey);
  TextEditingController get newPasswordController =>
      _getFormTextEditingController(NewPasswordValueKey);
  TextEditingController get confirmPasswordController =>
      _getFormTextEditingController(ConfirmPasswordValueKey);

  FocusNode get passwordFocusNode => _getFormFocusNode(PasswordValueKey);
  FocusNode get newPasswordFocusNode => _getFormFocusNode(NewPasswordValueKey);
  FocusNode get confirmPasswordFocusNode =>
      _getFormFocusNode(ConfirmPasswordValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_ChangePasswordViewTextEditingControllers.containsKey(key)) {
      return _ChangePasswordViewTextEditingControllers[key]!;
    }

    _ChangePasswordViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _ChangePasswordViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_ChangePasswordViewFocusNodes.containsKey(key)) {
      return _ChangePasswordViewFocusNodes[key]!;
    }
    _ChangePasswordViewFocusNodes[key] = FocusNode();
    return _ChangePasswordViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    passwordController.addListener(() => _updateFormData(model));
    newPasswordController.addListener(() => _updateFormData(model));
    confirmPasswordController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    passwordController.addListener(() => _updateFormData(model));
    newPasswordController.addListener(() => _updateFormData(model));
    confirmPasswordController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          PasswordValueKey: passwordController.text,
          NewPasswordValueKey: newPasswordController.text,
          ConfirmPasswordValueKey: confirmPasswordController.text,
        }),
    );

    if (_autoTextFieldValidation || forceValidate) {
      updateValidationData(model);
    }
  }

  bool validateFormFields(FormViewModel model) {
    _updateFormData(model, forceValidate: true);
    return model.isFormValid;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _ChangePasswordViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _ChangePasswordViewFocusNodes.values) {
      focusNode.dispose();
    }

    _ChangePasswordViewTextEditingControllers.clear();
    _ChangePasswordViewFocusNodes.clear();
  }
}

extension ValueProperties on FormStateHelper {
  bool get hasAnyValidationMessage => this
      .fieldsValidationMessages
      .values
      .any((validation) => validation != null);

  bool get isFormValid {
    if (!_autoTextFieldValidation) this.validateForm();

    return !hasAnyValidationMessage;
  }

  String? get passwordValue => this.formValueMap[PasswordValueKey] as String?;
  String? get newPasswordValue =>
      this.formValueMap[NewPasswordValueKey] as String?;
  String? get confirmPasswordValue =>
      this.formValueMap[ConfirmPasswordValueKey] as String?;

  set passwordValue(String? value) {
    this.setData(
      this.formValueMap..addAll({PasswordValueKey: value}),
    );

    if (_ChangePasswordViewTextEditingControllers.containsKey(
        PasswordValueKey)) {
      _ChangePasswordViewTextEditingControllers[PasswordValueKey]?.text =
          value ?? '';
    }
  }

  set newPasswordValue(String? value) {
    this.setData(
      this.formValueMap..addAll({NewPasswordValueKey: value}),
    );

    if (_ChangePasswordViewTextEditingControllers.containsKey(
        NewPasswordValueKey)) {
      _ChangePasswordViewTextEditingControllers[NewPasswordValueKey]?.text =
          value ?? '';
    }
  }

  set confirmPasswordValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ConfirmPasswordValueKey: value}),
    );

    if (_ChangePasswordViewTextEditingControllers.containsKey(
        ConfirmPasswordValueKey)) {
      _ChangePasswordViewTextEditingControllers[ConfirmPasswordValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasPassword =>
      this.formValueMap.containsKey(PasswordValueKey) &&
      (passwordValue?.isNotEmpty ?? false);
  bool get hasNewPassword =>
      this.formValueMap.containsKey(NewPasswordValueKey) &&
      (newPasswordValue?.isNotEmpty ?? false);
  bool get hasConfirmPassword =>
      this.formValueMap.containsKey(ConfirmPasswordValueKey) &&
      (confirmPasswordValue?.isNotEmpty ?? false);

  bool get hasPasswordValidationMessage =>
      this.fieldsValidationMessages[PasswordValueKey]?.isNotEmpty ?? false;
  bool get hasNewPasswordValidationMessage =>
      this.fieldsValidationMessages[NewPasswordValueKey]?.isNotEmpty ?? false;
  bool get hasConfirmPasswordValidationMessage =>
      this.fieldsValidationMessages[ConfirmPasswordValueKey]?.isNotEmpty ??
      false;

  String? get passwordValidationMessage =>
      this.fieldsValidationMessages[PasswordValueKey];
  String? get newPasswordValidationMessage =>
      this.fieldsValidationMessages[NewPasswordValueKey];
  String? get confirmPasswordValidationMessage =>
      this.fieldsValidationMessages[ConfirmPasswordValueKey];
}

extension Methods on FormStateHelper {
  setPasswordValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[PasswordValueKey] = validationMessage;
  setNewPasswordValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[NewPasswordValueKey] = validationMessage;
  setConfirmPasswordValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ConfirmPasswordValueKey] =
          validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    passwordValue = '';
    newPasswordValue = '';
    confirmPasswordValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      PasswordValueKey: getValidationMessage(PasswordValueKey),
      NewPasswordValueKey: getValidationMessage(NewPasswordValueKey),
      ConfirmPasswordValueKey: getValidationMessage(ConfirmPasswordValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _ChangePasswordViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _ChangePasswordViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      PasswordValueKey: getValidationMessage(PasswordValueKey),
      NewPasswordValueKey: getValidationMessage(NewPasswordValueKey),
      ConfirmPasswordValueKey: getValidationMessage(ConfirmPasswordValueKey),
    });
