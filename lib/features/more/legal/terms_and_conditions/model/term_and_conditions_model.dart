class TermsAndConditionsDataModel {
  TermsAndConditionsDataModel({this.id, this.description, this.createdAt, this.updatedAt});

  final String? id;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory TermsAndConditionsDataModel.fromJson(Map<String, dynamic> json) {
    return TermsAndConditionsDataModel(
      id: json["_id"],
      description: json["description"],
      createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"].toString()) : null,

      updatedAt: json["updatedAt"] != null ? DateTime.tryParse(json["updatedAt"].toString()) : null,
    );
  }
}
