class SendWaveResponseModel {
  SendWaveResponseModel({
    this.participants,
    this.status,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final List<String>? participants;
  final String? status;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory SendWaveResponseModel.fromJson(Map<String, dynamic> json) {
    return SendWaveResponseModel(
      participants: json["participants"] == null
          ? []
          : List<String>.from(json["participants"]!.map((x) => x)),
      status: json["status"],
      id: json["_id"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }
}
