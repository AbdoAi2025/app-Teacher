
class AppHttpException  implements Exception {

  final int? statusCode;
  final String? message;

  AppHttpException(this.message ,[ this.statusCode]);

  @override
  String toString() {
    return message ?? "";
  }

}
