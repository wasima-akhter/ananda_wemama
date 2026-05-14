class ContactAndSupportDataModel {
  ContactAndSupportDataModel({
    this.name,
    this.email,
    this.description,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? name;
  final String? email;
  final String? description;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory ContactAndSupportDataModel.fromJson(Map<String, dynamic> json) {
    return ContactAndSupportDataModel(
      name: json["name"],
      email: json["email"],
      description: json["description"],
      id: json["_id"],
      createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"].toString()) : null,

      updatedAt: json["updatedAt"] != null ? DateTime.tryParse(json["updatedAt"].toString()) : null,
      v: json["__v"],
    );
  }
}
