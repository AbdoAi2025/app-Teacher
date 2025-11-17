import 'package:shared_preferences/shared_preferences.dart';

enum WhatsAppShareOption {
  whatsapp,
  whatsappBusiness,
  other,
}

class WhatsAppSharePreferences {
  static const String _dontAskAgainKey = "whatsapp_share_dont_ask_again";
  static const String _selectedOptionKey = "whatsapp_share_selected_option";

  /// Check if user has selected "don't ask me again"
  static Future<bool> getDontAskAgain() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dontAskAgainKey) ?? false;
  }

  /// Set the "don't ask me again" preference
  static Future<void> setDontAskAgain(bool dontAsk) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dontAskAgainKey, dontAsk);
  }

  /// Get the user's previously selected sharing option
  static Future<WhatsAppShareOption?> getSelectedOption() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? optionString = prefs.getString(_selectedOptionKey);
    if (optionString == null) return null;

    switch (optionString) {
      case 'whatsapp':
        return WhatsAppShareOption.whatsapp;
      case 'whatsappBusiness':
        return WhatsAppShareOption.whatsappBusiness;
      case 'other':
        return WhatsAppShareOption.other;
      default:
        return null;
    }
  }

  /// Set the user's selected sharing option
  static Future<void> setSelectedOption(WhatsAppShareOption option) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String optionString;

    switch (option) {
      case WhatsAppShareOption.whatsapp:
        optionString = 'whatsapp';
        break;
      case WhatsAppShareOption.whatsappBusiness:
        optionString = 'whatsappBusiness';
        break;
      case WhatsAppShareOption.other:
        optionString = 'other';
        break;
    }

    await prefs.setString(_selectedOptionKey, optionString);
  }

  /// Clear all preferences (for reset functionality)
  static Future<void> clearPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dontAskAgainKey);
    await prefs.remove(_selectedOptionKey);
  }
}