
class CheckAppVersionRequest {
  CheckAppVersionRequest({
      this.platform, 
      this.androidVersion, 
      this.iosVersion,});

  CheckAppVersionRequest.fromJson(dynamic json) {
    platform = json['platform'];
    androidVersion = json['androidVersion'];
    iosVersion = json['IOSVersion'];
  }
  int? platform;
  double? androidVersion;
  double? iosVersion;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['platform'] = platform;
    if(androidVersion != null){
      map['androidVersion'] = androidVersion;
    }
    if(iosVersion != null){
      map['iosVersion'] = iosVersion;
    }
    return map;
  }

}