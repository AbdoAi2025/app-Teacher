enum SessionStatus {
  active(0),
  inactive(1);

  final int value;
  const SessionStatus(this.value);

  static SessionStatus fromValue(int value) {
    return SessionStatus.values.firstWhere(
          (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SessionStatus value: $value'),
    );
  }
}


extension SessionStatusToString on SessionStatus {
  String get label {
    switch (this) {
      case SessionStatus.active:
        return 'Active';
      case SessionStatus.inactive:
        return 'Inactive';
    }
  }
}
