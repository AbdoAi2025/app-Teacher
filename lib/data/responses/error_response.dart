/// status : "failed"
/// message : "there is another session started, end it first then start new session"

class ErrorResponse {
  ErrorResponse({
      this.status, 
      this.message,});

  ErrorResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
  }
  String? status;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }

}