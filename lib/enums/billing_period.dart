enum BillingPeriod {
  MONTHLY,
  YEARLY;

  String toJson() => name;

  static BillingPeriod fromJson(String json) {
    return BillingPeriod.values.firstWhere(
      (e) => e.name == json,
      orElse: () => BillingPeriod.MONTHLY,
    );
  }
}