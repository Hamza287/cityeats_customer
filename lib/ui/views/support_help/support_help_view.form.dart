// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:city_customer_app/ui/form_validations/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String EmailValueKey = 'email';
const String ObjectValueKey = 'object';
const String MessageValueKey = 'message';

final Map<String, TextEditingController>
    _SupportHelpViewTextEditingControllers = {};

final Map<String, FocusNode> _SupportHelpViewFocusNodes = {};

final Map<String, String? Function(String?)?> _SupportHelpViewTextValidations =
    {
  EmailValueKey: FormFieldsValidator.validateEmailText,
  ObjectValueKey: FormFieldsValidator.validateFieldEmpty,
  MessageValueKey: FormFieldsValidator.validateFieldEmpty,
};

mixin $SupportHelpView {
  TextEditingController get emailController =>
      _getFormTextEditingController(EmailValueKey);
  TextEditingController get objectController =>
      _getFormTextEditingController(ObjectValueKey);
  TextEditingController get messageController =>
      _getFormTextEditingController(MessageValueKey);

  FocusNode get emailFocusNode => _getFormFocusNode(EmailValueKey);
  FocusNode get objectFocusNode => _getFormFocusNode(ObjectValueKey);
  FocusNode get messageFocusNode => _getFormFocusNode(MessageValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_SupportHelpViewTextEditingControllers.containsKey(key)) {
      return _SupportHelpViewTextEditingControllers[key]!;
    }

    _SupportHelpViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _SupportHelpViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_SupportHelpViewFocusNodes.containsKey(key)) {
      return _SupportHelpViewFocusNodes[key]!;
    }
    _SupportHelpViewFocusNodes[key] = FocusNode();
    return _SupportHelpViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    emailController.addListener(() => _updateFormData(model));
    objectController.addListener(() => _updateFormData(model));
    messageController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    emailController.addListener(() => _updateFormData(model));
    objectController.addListener(() => _updateFormData(model));
    messageController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          EmailValueKey: emailController.text,
          ObjectValueKey: objectController.text,
          MessageValueKey: messageController.text,
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

    for (var controller in _SupportHelpViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _SupportHelpViewFocusNodes.values) {
      focusNode.dispose();
    }

    _SupportHelpViewTextEditingControllers.clear();
    _SupportHelpViewFocusNodes.clear();
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

  String? get emailValue => this.formValueMap[EmailValueKey] as String?;
  String? get objectValue => this.formValueMap[ObjectValueKey] as String?;
  String? get messageValue => this.formValueMap[MessageValueKey] as String?;

  set emailValue(String? value) {
    this.setData(
      this.formValueMap..addAll({EmailValueKey: value}),
    );

    if (_SupportHelpViewTextEditingControllers.containsKey(EmailValueKey)) {
      _SupportHelpViewTextEditingControllers[EmailValueKey]?.text = value ?? '';
    }
  }

  set objectValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ObjectValueKey: value}),
    );

    if (_SupportHelpViewTextEditingControllers.containsKey(ObjectValueKey)) {
      _SupportHelpViewTextEditingControllers[ObjectValueKey]?.text =
          value ?? '';
    }
  }

  set messageValue(String? value) {
    this.setData(
      this.formValueMap..addAll({MessageValueKey: value}),
    );

    if (_SupportHelpViewTextEditingControllers.containsKey(MessageValueKey)) {
      _SupportHelpViewTextEditingControllers[MessageValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasEmail =>
      this.formValueMap.containsKey(EmailValueKey) &&
      (emailValue?.isNotEmpty ?? false);
  bool get hasObject =>
      this.formValueMap.containsKey(ObjectValueKey) &&
      (objectValue?.isNotEmpty ?? false);
  bool get hasMessage =>
      this.formValueMap.containsKey(MessageValueKey) &&
      (messageValue?.isNotEmpty ?? false);

  bool get hasEmailValidationMessage =>
      this.fieldsValidationMessages[EmailValueKey]?.isNotEmpty ?? false;
  bool get hasObjectValidationMessage =>
      this.fieldsValidationMessages[ObjectValueKey]?.isNotEmpty ?? false;
  bool get hasMessageValidationMessage =>
      this.fieldsValidationMessages[MessageValueKey]?.isNotEmpty ?? false;

  String? get emailValidationMessage =>
      this.fieldsValidationMessages[EmailValueKey];
  String? get objectValidationMessage =>
      this.fieldsValidationMessages[ObjectValueKey];
  String? get messageValidationMessage =>
      this.fieldsValidationMessages[MessageValueKey];
}

extension Methods on FormStateHelper {
  setEmailValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[EmailValueKey] = validationMessage;
  setObjectValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ObjectValueKey] = validationMessage;
  setMessageValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[MessageValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    emailValue = '';
    objectValue = '';
    messageValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      EmailValueKey: getValidationMessage(EmailValueKey),
      ObjectValueKey: getValidationMessage(ObjectValueKey),
      MessageValueKey: getValidationMessage(MessageValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _SupportHelpViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _SupportHelpViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      EmailValueKey: getValidationMessage(EmailValueKey),
      ObjectValueKey: getValidationMessage(ObjectValueKey),
      MessageValueKey: getValidationMessage(MessageValueKey),
    });
