class SinglePostModel {
  final String? id;
  final String? content;
  final int? totalLike;
  int? totalComment;
  final bool? isAnonymous;
  final bool? isPinned;
  final bool? isCommentLocked;
  final bool? isLiked;
  final PostCreatorModel? creator;
  final PostCommunityModel? community;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SinglePostModel({
    this.id,
    this.content,
    this.totalLike,
    this.totalComment,
    this.isAnonymous,
    this.isPinned,
    this.isCommentLocked,
    this.isLiked,
    this.creator,
    this.community,
    this.createdAt,
    this.updatedAt,
  });

  factory SinglePostModel.fromJson(Map<String, dynamic> json) {
    return SinglePostModel(
      id: json['_id'],
      content: json['content'],
      totalLike: json['totalLike'],
      totalComment: json['totalComment'],
      isAnonymous: json['isAnonymous'],
      isPinned: json['isPinned'],
      isCommentLocked: json['isCommentLocked'],
      isLiked: json['isLiked'],
      creator: json['creator'] != null
          ? PostCreatorModel.fromJson(json['creator'])
          : null,
      community: json['community'] != null
          ? PostCommunityModel.fromJson(json['community'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

class PostCreatorModel {
  final String? id;
  final String? name;
  final String? profileImage;
  final String? city;

  PostCreatorModel({this.id, this.name, this.profileImage, this.city});

  factory PostCreatorModel.fromJson(Map<String, dynamic> json) {
    return PostCreatorModel(
      id: json['_id'],
      name: json['name'],
      profileImage: json['profileImage'],
      city: json['city'],
    );
  }
}

class PostCommunityModel {
  final String? id;
  final String? name;
  final String? image;
  final int? totalMember;
  final int? totalPost;

  PostCommunityModel({
    this.id,
    this.name,
    this.image,
    this.totalMember,
    this.totalPost,
  });

  factory PostCommunityModel.fromJson(Map<String, dynamic> json) {
    return PostCommunityModel(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      totalMember: json['totalMember'],
      totalPost: json['totalPost'],
    );
  }
}
