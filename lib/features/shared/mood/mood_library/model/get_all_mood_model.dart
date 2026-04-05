class GetAllMoodItemModel {
  GetAllMoodItemModel({
    this.id,
    this.title,
    this.image,
    this.key,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final String? title;
  final String? image;
  final int? key;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory GetAllMoodItemModel.fromJson(Map<String, dynamic> json) {
    return GetAllMoodItemModel(
      id: json["_id"],
      title: json["title"],
      image: json["image"],
      key: json["key"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }
}
