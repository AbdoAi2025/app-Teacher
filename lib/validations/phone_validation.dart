import 'package:form_field_validator/form_field_validator.dart';

class PhoneValidation extends TextFieldValidator {

  PhoneValidation({required String errorText}) : super(errorText);

  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String? value) {
    return isValidEgyptianPhoneNumber(value ?? "");
  }

  @override
  String? call(String? value) {
    return isValid(value) ? null : errorText;
  }

  // bool isValidEgyptianPhoneNumber(String phone) {
  //   // Remove any whitespace or hyphens
  //   final cleanedPhone = phone.replaceAll(RegExp(r'[\s-]'), '');
  //
  //   // Regex for Egyptian phone numbers (without +20)
  //   // Starts with 0, followed by:
  //   // - Mobile: 1[0-2,5,6,9] then 8 digits (total 11 digits)
  //   // - Landline: 2-5 then 7-8 digits (total 9-10 digits)
  //   final regex = RegExp(
  //     r'^(01[0-2,5,6,9]\d{8}|0[2-5]\d{7,8})$',
  //   );
  //
  //   return regex.hasMatch(cleanedPhone);
  // }

  bool isValidEgyptianPhoneNumber(String phone, {bool strict = false}) {
    // Remove all non-digit characters (spaces, +, -, etc.)
    final cleanedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Regex for Egyptian phone numbers (0 is optional)
    // - Mobile: (0)?1[0-2,5,6,9] followed by 8 digits (total 10 or 11 digits)
    // - Landline: (0)?[2-5] followed by 7-8 digits (total 8-10 digits)
    final regex = RegExp(
      r'^(0)?(1[0-2,5,6,9]\d{8}|[2-5]\d{7,8})$',
    );

    // If strict mode, enforce 11 digits for mobile (e.g., 01012345678)
    if (strict) {
      return regex.hasMatch(cleanedPhone) &&
          (cleanedPhone.startsWith('01') ? cleanedPhone.length == 11 : true);
    }

    return regex.hasMatch(cleanedPhone);
  }
}