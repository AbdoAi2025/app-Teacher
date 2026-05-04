enum OtpChannel {
  EMAIL("EMAIL"),
  SMS("SMS");

  const OtpChannel(this.value);

  final String value;

  String toJson() => name;

  static OtpChannel fromJson(String json) {
    return OtpChannel.values.firstWhere(
      (e) => e.name == json,
      orElse: () => OtpChannel.EMAIL,
    );
  }
}