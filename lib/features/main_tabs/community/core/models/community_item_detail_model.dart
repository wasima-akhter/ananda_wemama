class CommunityItemDetailModel {
  CommunityItemDetailModel({this.community, this.allPost});

  final Community? community;
  final List<AllPost>? allPost;

  factory CommunityItemDetailModel.fromJson(Map<String, dynamic> json) {
    return CommunityItemDetailModel(
      community: json["community"] == null
          ? null
          : Community.fromJson(json["community"]),
      allPost: json["allPost"] == null
          ? []
          : List<AllPost>.from(
              json["allPost"]!.map((x) => AllPost.fromJson(x)),
            ),
    );
  }
}

class AllPost {
  AllPost({
    this.id,
    this.creator,
    this.content,
    this.totalLike,
    this.isPinned,
    this.createdAt,
    this.isLiked,
    this.isAnonymous,
    this.isCommentLocked,
  });

  final String? id;
  final Creator? creator;
  final String? content;
  final int? totalLike;
  final bool? isPinned;
  final DateTime? createdAt;
  final bool? isLiked;
  final bool? isAnonymous;
  final bool? isCommentLocked;

  factory AllPost.fromJson(Map<String, dynamic> json) {
    return AllPost(
      id: json["_id"],
      creator: json["creator"] == null
          ? null
          : Creator.fromJson(json["creator"]),
      content: json["content"],
      totalLike: json["totalLike"],
      isPinned: json["isPinned"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      isLiked: json["isLiked"],
      isAnonymous: json["isAnonymous"],
      isCommentLocked: json["isCommentLocked"],
    );
  }
}

class Creator {
  Creator({this.name, this.city, this.profileImage});

  final String? name;
  final String? city;
  final String? profileImage;

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      name: json["name"],
      city: json["city"],
      profileImage: json["profileImage"],
    );
  }
}

class Community {
  Community({
    this.id,
    this.creator,
    this.name,
    this.image,
    this.totalPost,
    this.isApproved,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.totalMember,
  });

  final String? id;
  final String? creator;
  final String? name;
  final String? image;
  final int? totalMember;
  final int? totalPost;
  final bool? isApproved;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json["_id"],
      creator: json["creator"],
      name: json["name"],
      image: json["image"],
      totalMember: json["totalMember"],
      totalPost: json["totalPost"],
      isApproved: json["isApproved"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }
}
