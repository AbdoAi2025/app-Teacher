class RegisterModel {
  final String name;
  final String userName;
  final String password;

  RegisterModel({
    required this.name,
    required this.userName,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': userName,
      'password': password,
    };
  }
}