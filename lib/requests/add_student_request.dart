/// gradeId : 1073741824
/// phone : "string"
/// parentPhone : "string"
/// name : "string"
/// password : "string"

class AddStudentRequest {
  AddStudentRequest({
      this.gradeId, 
      this.phone, 
      this.parentPhone, 
      this.name, 
      this.password,});

  AddStudentRequest.fromJson(dynamic json) {
    gradeId = json['gradeId'];
    phone = json['phone'];
    parentPhone = json['parentPhone'];
    name = json['name'];
    password = json['password'];
  }
  String? gradeId;
  String? phone;
  String? parentPhone;
  String? name;
  String? password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    var phone = removeLeadingZero(this.phone);
    var parentPhone = removeLeadingZero(this.parentPhone);
    map['gradeId'] = gradeId;
    map['phone'] = phone.isEmpty ? "" : "+20$phone";
    map['parentPhone'] = parentPhone.isEmpty ? "" : "+20$parentPhone";

    map['name'] = name;
    map['password'] = password;
    return map;
  }

  String removeLeadingZero(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "";
    }
    if (phone.startsWith('0')) {
      return phone.substring(1); // Remove first character (0)
    }
    return phone; // Return as-is if no leading zero
  }

}