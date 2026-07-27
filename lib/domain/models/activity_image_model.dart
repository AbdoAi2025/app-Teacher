class ActivityImageModel {
  final int id;
  final String url;
  final DateTime? createdAt;

  ActivityImageModel({required this.id, required this.url, this.createdAt});

  factory ActivityImageModel.fromJson(Map<String, dynamic> json) {
    return ActivityImageModel(
      id: json['id'] as int,
      url: json['url'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}