/// status : "failed"
/// message : "there is another session started, end it first then start new session"

class ErrorResponse {
  ErrorResponse({
      this.status, 
      this.message,});

  ErrorResponse.fromJson(dynamic json) {

    if(json == null) return;

    if (json['status'] != null) {
      status = json['status'];
    }

    if (json['message'] != null) {
      message = json['message'];
    }

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