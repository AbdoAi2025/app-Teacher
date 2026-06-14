class GenderModel {
  final String? type;

  GenderModel(this.type);

  bool get isMale => type?.toLowerCase() == 'male';
  bool get isFemale => type?.toLowerCase() == 'female';
}