import '../../../../../core/helpers/parser_helper.dart';

class TermsAndConditionsDataModel {
  const TermsAndConditionsDataModel({
    this.id = '',
    this.description = '',
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory TermsAndConditionsDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const TermsAndConditionsDataModel();
    }

    return TermsAndConditionsDataModel(
      id: SafeParser.id(json['_id']),
      description: SafeParser.str(json['description']),
      createdAt: SafeParser.date(json['createdAt']),
      updatedAt: SafeParser.date(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'description': description,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
