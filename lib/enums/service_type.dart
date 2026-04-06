enum ServiceType {
  subscribe('SUBSCRIBE'),
  renew('RENEW'),
  upgrade('UPGRADE'),
  downgrade('DOWNGRADE');

  const ServiceType(this.value);
  final String value;

  static ServiceType fromJson(String json) {
    return ServiceType.values.firstWhere(
      (element) => element.value == json,
      orElse: () => ServiceType.subscribe,
    );
  }

  String toJson() => value;

  @override
  String toString() => value;
}