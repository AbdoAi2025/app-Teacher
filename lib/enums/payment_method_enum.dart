enum PaymentMethodEnum {
  ONLINE("ONLINE"),
  WALLET("WALLET"),
  CASH("CASH");

  const PaymentMethodEnum(this.displayName);

  final String displayName;

  String toJson() => name;

  static PaymentMethodEnum fromJson(String json) {
    return PaymentMethodEnum.values.firstWhere(
      (e) => e.name == json,
      orElse: () => PaymentMethodEnum.ONLINE,
    );
  }

  static PaymentMethodEnum? fromDisplayName(String displayName) {
    try {
      return PaymentMethodEnum.values.firstWhere(
        (e) => e.displayName == displayName,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() => displayName;
}