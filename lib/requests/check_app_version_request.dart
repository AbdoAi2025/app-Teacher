
class CheckAppVersionRequest {
  CheckAppVersionRequest({
      this.platform, 
      this.version,});

  CheckAppVersionRequest.fromJson(dynamic json) {
    platform = json['platform'];
    version = json['version'];
  }
  int? platform;
  double? version;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['platform'] = platform;
    map['version'] = version;

    return map;
  }

}