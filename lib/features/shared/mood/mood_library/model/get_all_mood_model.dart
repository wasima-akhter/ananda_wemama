class GetAllMoodItemModel {
  GetAllMoodItemModel({
    this.id,
    this.title,
    this.mood,
    this.image,
    this.key,

    this.createdAt,
    this.updatedAt,
    this.v,
    this.description,
  });

  final String? id;
  final String? title;
  final String? mood;
  final String? image;
  final String? description;
  final int? key;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory GetAllMoodItemModel.fromJson(Map<String, dynamic> json) {
    return GetAllMoodItemModel(
      id: json["_id"],
      title: json["title"],
      mood: json["mood"],
      image: json["image"],
      description: json["description"],
      key: json["key"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }
}
