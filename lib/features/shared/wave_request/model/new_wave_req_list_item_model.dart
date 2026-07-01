class NewWaveListItemModel {
  NewWaveListItemModel({
    this.id,
    this.participants,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final List<Participant>? participants;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory NewWaveListItemModel.fromJson(Map<String, dynamic> json) {
    return NewWaveListItemModel(
      id: json["_id"] as String?,
      participants: (json["participants"] as List<dynamic>? ?? [])
          .map((e) => Participant.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json["status"] as String?,
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"].toString())
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"].toString())
          : null,
      v: json["__v"] as int?,
    );
  }
}

class Participant {
  Participant({this.id, this.name, this.profileImage});

  final String? id;
  final String? name;
  final String? profileImage;

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json["_id"],
      name: json["name"],
      profileImage: json["profileImage"],
    );
  }
}
