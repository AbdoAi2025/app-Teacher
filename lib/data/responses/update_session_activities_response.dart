/// sessionId : ""
/// message : "data updated successfully"

class UpdateSessionActivitiesResponse {
  UpdateSessionActivitiesResponse({
      this.sessionId, 
      this.message,});

  UpdateSessionActivitiesResponse.fromJson(dynamic json) {
    sessionId = json['sessionId'];
    message = json['message'];
  }
  String? sessionId;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sessionId'] = sessionId;
    map['message'] = message;
    return map;
  }

}