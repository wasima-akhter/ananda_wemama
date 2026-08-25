class CommunityItemDetailModel {
  CommunityItemDetailModel({this.community, this.allPost});

  final Community? community;
  final List<AllPost>? allPost;

  factory CommunityItemDetailModel.fromJson(Map<String, dynamic> json) {
    return CommunityItemDetailModel(
      community: json['community'] is Map<String, dynamic>
          ? Community.fromJson(json['community'] as Map<String, dynamic>)
          : null,
      allPost: json['allPost'] is List
          ? (json['allPost'] as List)
                .whereType<Map<String, dynamic>>()
                .map(AllPost.fromJson)
                .toList()
          : [],
    );
  }
}

class AllPost {
  AllPost({
    this.id,
    this.creator,
    this.content,
    this.totalLike,
    this.totalComment,
    this.isPinned,
    this.createdAt,
    this.isLiked,
    this.isAnonymous,
    this.isCommentLocked,
  });

  final String? id;
  final Creator? creator;
  final String? content;

  int? totalLike;
  int? totalComment;

  final bool? isPinned;
  final DateTime? createdAt;
  final bool? isLiked;
  final bool? isAnonymous;
  final bool? isCommentLocked;

  factory AllPost.fromJson(Map<String, dynamic> json) {
    return AllPost(
      id: json['_id']?.toString(),

      creator: json['creator'] is Map<String, dynamic>
          ? Creator.fromJson(json['creator'] as Map<String, dynamic>)
          : null,

      content: json['content']?.toString(),

      totalLike: (json['totalLike'] as num?)?.toInt(),

      totalComment: (json['totalComment'] as num?)?.toInt(),

      isPinned: json['isPinned'] as bool?,

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,

      isLiked: json['isLiked'] as bool?,

      isAnonymous: json['isAnonymous'] as bool?,

      isCommentLocked: json['isCommentLocked'] as bool?,
    );
  }
}

class Creator {
  Creator({this.id, this.name, this.city, this.profileImage, this.location});

  final String? id;
  final String? name;
  final String? city;
  final String? profileImage;
  final CreatorLocation? location;

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      name: json['name']?.toString(),
      city: json['city']?.toString(),
      profileImage: json['profileImage']?.toString(),
      location: json['location'] is Map<String, dynamic>
          ? CreatorLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CreatorLocation {
  CreatorLocation({this.type, this.coordinates});

  final String? type;
  final List<double>? coordinates;

  factory CreatorLocation.fromJson(Map<String, dynamic> json) {
    return CreatorLocation(
      type: json['type']?.toString(),
      coordinates: (json['coordinates'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
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
  final Creator? creator;
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
      id: json['_id']?.toString(),

      creator: json['creator'] is Map<String, dynamic>
          ? Creator.fromJson(json['creator'] as Map<String, dynamic>)
          : null,

      name: json['name']?.toString(),

      image: json['image']?.toString(),

      totalMember: (json['totalMember'] as num?)?.toInt(),

      totalPost: (json['totalPost'] as num?)?.toInt(),

      isApproved: json['isApproved'] as bool?,

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,

      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,

      v: (json['__v'] as num?)?.toInt(),
    );
  }
}
