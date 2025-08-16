class ImgsModel {
  final String id;
  final String name;
  final String url;
  final String description;

  ImgsModel({
    required this.id,
    required this.name,
    required this.url,
    required this.description,
  });

  factory ImgsModel.fromJson(Map<String, dynamic> json) {
    return ImgsModel(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      description: json['description'] as String,
    );
  }
}
