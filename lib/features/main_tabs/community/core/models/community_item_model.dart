class CommunityItemModel {
  CommunityItemModel({
    this.id,
    this.creator,
    this.name,
    this.image,
    this.members,
    this.totalMember,
    this.totalPost,
    this.isApproved,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isCreator,
    this.isMember,
  });

  final String? id;
  final String? creator;
  final String? name;
  final String? image;
  final List<String>? members;
  final int? totalMember;
  final int? totalPost;
  final bool? isApproved;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isCreator;
  final bool? isMember;

  final int? v;

  factory CommunityItemModel.fromJson(Map<String, dynamic> json) {
    return CommunityItemModel(
      id: json["_id"] ?? '',
      creator: json["creator"] ?? '',
      name: json["name"] ?? '',
      image: json["image"] ?? '',
      members: json["members"] == null
          ? []
          : List<String>.from(json["members"]!.map((x) => x)),
      totalMember: json["totalMember"] ?? 0,
      totalPost: json["totalPost"] ?? 0,
      isApproved: json["isApproved"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),

      isCreator: json["isCreator"] ?? false,
      isMember: json["isMember"] ?? false,

      v: json["__v"],
    );
  }
}
