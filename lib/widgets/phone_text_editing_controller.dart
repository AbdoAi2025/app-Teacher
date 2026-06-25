import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class PhoneTextEditingController extends TextEditingController {
  final ValueNotifier<String> countryCodeNotifier;

  factory PhoneTextEditingController({String initialCountryCode = '+20', String? text}) {
    if (text != null && text.startsWith('+')) {
      final code = _extractDialCode(text);
      return PhoneTextEditingController._(countryCode: code, text: text.substring(code.length));
    }
    return PhoneTextEditingController._(countryCode: initialCountryCode, text: text ?? '');
  }

  PhoneTextEditingController._({required String countryCode, String text = ''})
      : countryCodeNotifier = ValueNotifier(countryCode),
        super(text: text);

  String get countryCode => countryCodeNotifier.value;
  set countryCode(String value) => countryCodeNotifier.value = value;

  @override
  set value(TextEditingValue newValue) {
    final stripped = _stripLeadingZero(newValue.text);
    super.value = stripped != newValue.text
        ? newValue.copyWith(
            text: stripped,
            selection: TextSelection.collapsed(offset: stripped.length),
          )
        : newValue;
  }

  /// Validates the local phone number combined with the selected country code.
  String? validate([String? _]) {
    final local = text.trim();
    if (local.isEmpty) return AppStringsKeys.phoneNumberIsRequired.tr;
    final localDigits = local.replaceAll(RegExp(r'[^\d]'), '');
    if (localDigits.length < 10) {
      return AppStringsKeys.phoneNumberMustBeAtLeast10Digits.tr;
    }
    final countryDigits = countryCode.replaceAll(RegExp(r'[^\d]'), '');
    if (countryDigits.length + localDigits.length > 15) {
      return AppStringsKeys.phoneNumberMustNotExceed15Digits.tr;
    }
    return null;
  }

  /// Returns the full international phone number for API submission.
  String getPhone() {

    if(text.isEmpty) return "";
    var local = text.trim();
    if (countryCode == '+20' && local.startsWith('0')) {
      local = local.substring(1);
    }
    return '$countryCode$local';
  }

  /// Parses a full international phone string and sets country code + local number.
  void setFromFullPhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      text = '';
      countryCode = '+20';
      return;
    }
    if (!phone.startsWith('+')) {
      text = phone;
      countryCode = '+20';
      return;
    }
    final code = _extractDialCode(phone);
    countryCode = code;
    text = phone.substring(code.length);
  }

  /// Strips the country code prefix and cleans raw phone numbers from contacts.
  String processContactPhone(String rawPhone) {
    var phone = rawPhone;
    if (phone.startsWith(countryCode)) {
      phone = phone.replaceFirst(countryCode, '');
    }
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  String _stripLeadingZero(String phone) =>
      countryCode == '+20' && phone.startsWith('0') ? phone.substring(1) : phone;

  static String _extractDialCode(String phone) {
    const three = ['+212','+213','+216','+218','+249','+966','+971','+974','+965','+962','+961','+963','+964','+968','+972','+973','+967'];
    for (final c in three) { if (phone.startsWith(c)) return c; }
    const two = ['+20','+27','+30','+31','+32','+33','+34','+36','+39','+40','+41','+43','+44','+45','+46','+47','+48','+49','+51','+52','+53','+54','+55','+56','+57','+58','+60','+61','+62','+63','+64','+65','+66','+81','+82','+84','+86','+90','+91','+92','+93','+94','+95','+98'];
    for (final c in two) { if (phone.startsWith(c)) return c; }
    if (phone.startsWith('+1')) return '+1';
    if (phone.startsWith('+7')) return '+7';
    return '+20';
  }

  @override
  void dispose() {
    countryCodeNotifier.dispose();
    super.dispose();
  }
}