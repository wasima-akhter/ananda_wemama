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
      id: json["_id"],
      participants: json["participants"] == null
          ? []
          : List<Participant>.from(json["participants"]!.map((x) => Participant.fromJson(x))),
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }
}

class Participant {
  Participant({this.id, this.name, this.profileImage});

  final String? id;
  final String? name;
  final String? profileImage;

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(id: json["_id"], name: json["name"], profileImage: json["profileImage"]);
  }
}
