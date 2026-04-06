enum PaymentProviderType {
  GOOGLE_PLAY("google_play", "Google Play Billing"),
  APP_STORE("app_store", "Apple App Store"),
  STRIPE("stripe", "Stripe"),
  PAYPAL("paypal", "PayPal"),
  PAYMOB("paymob", "PayMob"),
  FAWRY("fawry", "Fawry");

  const PaymentProviderType(this.code, this.displayName);

  final String code;
  final String displayName;

  String toJson() => name;

  static PaymentProviderType fromJson(String json) {
    return PaymentProviderType.values.firstWhere(
      (e) => e.name == json,
      orElse: () => PaymentProviderType.PAYMOB,
    );
  }
}