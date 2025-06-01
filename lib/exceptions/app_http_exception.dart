
class AppHttpException  implements Exception {

  final String? message;

  AppHttpException(this.message);

  @override
  String toString() {
    return message ?? "";
  }

}
