class RegisterModel {
  final String name;
  final String userName;
  final String password;
  final String phone;

  RegisterModel({
    required this.name,
    required this.userName,
    required this.password,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': userName,
      'password': password,
      'phone': phone,
    };
  }
}