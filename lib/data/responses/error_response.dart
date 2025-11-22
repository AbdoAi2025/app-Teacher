import 'package:teacher_app/utils/LogUtils.dart';

/// status : "failed"
/// message : "there is another session started, end it first then start new session"

class ErrorResponse {
  ErrorResponse({
      this.status, 
      this.message,
      this.errorType,
  });

  ErrorResponse.fromJson(dynamic json) {

    try{

      if(json == null) return;

      if (json['status'] != null) {
        status = json['status'];
      }

      if (json['message'] != null) {
        message = json['message'];
      }

      if (json['errorType'] != null) {
        errorType = json['errorType'];
      }
    }catch(ex){
      appLog("ErrorResponse ex:${ex.toString()}");
    }

  }
  String? status;
  String? message;
  int? errorType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['errorType'] = errorType;
    return map;
  }

}