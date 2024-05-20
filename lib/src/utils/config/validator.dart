// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:dating_app/imports.dart';

class Validator {
  /// Validate Email
  static String validateEmail(String value) {
    Pattern pattern = r'^[a-zA-Z\u00C0-\u00FF0-9.]+@[a-zA-Z\u00C0-\u00FF0-9]+\.[a-zA-Z\u00C0-\u00FF]+';
    RegExp regex = RegExp(pattern.toString());
    if (value.toLowerCase().isEmpty) {
      return "${toLabelValue(StringConstants.please_enter.tr)} ${toLabelValue(StringConstants.email_address.tr)}";
    } else if (!regex.hasMatch(value)) {
      return "${toLabelValue(StringConstants.please_enter_valid.tr)} ${toLabelValue(StringConstants.email_address.tr)}";
    } else {
      return "";
    }
  }

  /// Validate Password
  static String validatePassword(String password, [String? fieldname, int minLength = 6]) {
    if (password.trim() == "" || password.isEmpty) {
      return "${toLabelValue(StringConstants.please_enter)} $fieldname";
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length > minLength;

    if (!hasUppercase) {
      return toLabelValue(StringConstants.pass_validation_msg);
    } else if (!hasDigits) {
      return toLabelValue(StringConstants.pass_validation_msg);
    } else if (!hasLowercase) {
      return toLabelValue(StringConstants.pass_validation_msg);
    } else if (!hasSpecialCharacters) {
      return toLabelValue(StringConstants.pass_validation_msg);
    } else if (!hasMinLength) {
      return toLabelValue(StringConstants.pass_validation_msg);
    } else {
      return '';
    }
  }

  //Validate ConfirmPass
  static String validateConfirmPassword(String password, confirmpass, [int minLength = 6]) {
    if (confirmpass == "") {
      return "${toLabelValue(StringConstants.please_enter)} ${toLabelValue(StringConstants.confirm_pass.tr)}";
    } else if (password.trim() != confirmpass.trim()) {
      return toLabelValue(StringConstants.pass_confirmpass_should_same);
    } else {
      return "";
    }
  }

  ///   Validate Blank Field
  static String blankValidation(String txtField, name) {
    if (txtField == "" || txtField.trim() == "") {
      return "${toLabelValue(StringConstants.please_enter.tr)} " + toLabelValue(name) + '.';
    } else {
      return "";
    }
  }

  /// Length Validation
  static String lengthValidation(String txtField, name) {
    if (txtField == "" || txtField.trim() == "" || txtField.characters.length > 500) {
      return name + " should not be greater than 50 characters.";
    } else {
      return "";
    }
  }
}
