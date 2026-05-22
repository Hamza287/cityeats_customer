// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:city_customer_app/ui/form_validations/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String NewPassValueKey = 'new_pass';
const String CPasswordValueKey = 'c_password';

final Map<String, TextEditingController>
    _NewPasswordViewTextEditingControllers = {};

final Map<String, FocusNode> _NewPasswordViewFocusNodes = {};

final Map<String, String? Function(String?)?> _NewPasswordViewTextValidations =
    {
  NewPassValueKey: FormFieldsValidator.validatePassword,
  CPasswordValueKey: FormFieldsValidator.validatePassword,
};

mixin $NewPasswordView {
  TextEditingController get newPassController =>
      _getFormTextEditingController(NewPassValueKey);
  TextEditingController get cPasswordController =>
      _getFormTextEditingController(CPasswordValueKey);

  FocusNode get newPassFocusNode => _getFormFocusNode(NewPassValueKey);
  FocusNode get cPasswordFocusNode => _getFormFocusNode(CPasswordValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_NewPasswordViewTextEditingControllers.containsKey(key)) {
      return _NewPasswordViewTextEditingControllers[key]!;
    }

    _NewPasswordViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _NewPasswordViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_NewPasswordViewFocusNodes.containsKey(key)) {
      return _NewPasswordViewFocusNodes[key]!;
    }
    _NewPasswordViewFocusNodes[key] = FocusNode();
    return _NewPasswordViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    newPassController.addListener(() => _updateFormData(model));
    cPasswordController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    newPassController.addListener(() => _updateFormData(model));
    cPasswordController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          NewPassValueKey: newPassController.text,
          CPasswordValueKey: cPasswordController.text,
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

    for (var controller in _NewPasswordViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _NewPasswordViewFocusNodes.values) {
      focusNode.dispose();
    }

    _NewPasswordViewTextEditingControllers.clear();
    _NewPasswordViewFocusNodes.clear();
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

  String? get newPassValue => this.formValueMap[NewPassValueKey] as String?;
  String? get cPasswordValue => this.formValueMap[CPasswordValueKey] as String?;

  set newPassValue(String? value) {
    this.setData(
      this.formValueMap..addAll({NewPassValueKey: value}),
    );

    if (_NewPasswordViewTextEditingControllers.containsKey(NewPassValueKey)) {
      _NewPasswordViewTextEditingControllers[NewPassValueKey]?.text =
          value ?? '';
    }
  }

  set cPasswordValue(String? value) {
    this.setData(
      this.formValueMap..addAll({CPasswordValueKey: value}),
    );

    if (_NewPasswordViewTextEditingControllers.containsKey(CPasswordValueKey)) {
      _NewPasswordViewTextEditingControllers[CPasswordValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasNewPass =>
      this.formValueMap.containsKey(NewPassValueKey) &&
      (newPassValue?.isNotEmpty ?? false);
  bool get hasCPassword =>
      this.formValueMap.containsKey(CPasswordValueKey) &&
      (cPasswordValue?.isNotEmpty ?? false);

  bool get hasNewPassValidationMessage =>
      this.fieldsValidationMessages[NewPassValueKey]?.isNotEmpty ?? false;
  bool get hasCPasswordValidationMessage =>
      this.fieldsValidationMessages[CPasswordValueKey]?.isNotEmpty ?? false;

  String? get newPassValidationMessage =>
      this.fieldsValidationMessages[NewPassValueKey];
  String? get cPasswordValidationMessage =>
      this.fieldsValidationMessages[CPasswordValueKey];
}

extension Methods on FormStateHelper {
  setNewPassValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[NewPassValueKey] = validationMessage;
  setCPasswordValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[CPasswordValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    newPassValue = '';
    cPasswordValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      NewPassValueKey: getValidationMessage(NewPassValueKey),
      CPasswordValueKey: getValidationMessage(CPasswordValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _NewPasswordViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _NewPasswordViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      NewPassValueKey: getValidationMessage(NewPassValueKey),
      CPasswordValueKey: getValidationMessage(CPasswordValueKey),
    });
