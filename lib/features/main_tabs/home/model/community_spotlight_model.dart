class CommunitySpotlightModel {
  CommunitySpotlightModel({this.communitySpotlight, this.liveSession});

  final CommunitySpotlightData? communitySpotlight;
  final LiveSession? liveSession;

  factory CommunitySpotlightModel.fromJson(Map<String, dynamic> json) {
    return CommunitySpotlightModel(
      communitySpotlight: json["communitySpotlight"] == null
          ? null
          : CommunitySpotlightData.fromJson(json["communitySpotlight"]),
      liveSession: json["liveSession"] == null ? null : LiveSession.fromJson(json["liveSession"]),
    );
  }
}

class CommunitySpotlightData {
  CommunitySpotlightData({this.id, this.name, this.totalMember, this.createdAt, this.lastPost});

  final String? id;
  final String? name;
  final int? totalMember;
  final DateTime? createdAt;
  final LastPost? lastPost;

  factory CommunitySpotlightData.fromJson(Map<String, dynamic> json) {
    return CommunitySpotlightData(
      id: json["_id"],
      name: json["name"],
      totalMember: json["totalMember"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      lastPost: json["lastPost"] == null ? null : LastPost.fromJson(json["lastPost"]),
    );
  }
}

class LastPost {
  LastPost({this.id, this.content, this.totalLike, this.totalComment, this.createdAt});

  final String? id;
  final String? content;
  final int? totalLike;
  final int? totalComment;
  final DateTime? createdAt;

  factory LastPost.fromJson(Map<String, dynamic> json) {
    return LastPost(
      id: json["_id"],
      content: json["content"],
      totalLike: json["totalLike"],
      totalComment: json["totalComment"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }
}

class LiveSession {
  LiveSession({this.id, this.expert, this.title, this.description, this.time, this.date});

  final String? id;
  final Expert? expert;
  final String? title;
  final String? description;
  final DateTime? time;
  final DateTime? date;

  factory LiveSession.fromJson(Map<String, dynamic> json) {
    return LiveSession(
      id: json["_id"],
      expert: json["expert"] == null ? null : Expert.fromJson(json["expert"]),
      title: json["title"],
      description: json["description"],
      time: DateTime.tryParse(json["time"] ?? ""),
      date: DateTime.tryParse(json["date"] ?? ""),
    );
  }
}

class Expert {
  Expert({this.id, this.name, this.email, this.image, this.profession});

  final String? id;
  final String? name;
  final String? email;
  final String? image;
  final Profession? profession;

  factory Expert.fromJson(Map<String, dynamic> json) {
    return Expert(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      image: json["image"],
      profession: json["profession"] == null ? null : Profession.fromJson(json["profession"]),
    );
  }
}

class Profession {
  Profession({this.designation, this.title, this.experience});

  final List<String>? designation;
  final String? title;
  final int? experience;

  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(
      designation: json["designation"] == null
          ? []
          : List<String>.from(json["designation"]!.map((x) => x)),
      title: json["title"],
      experience: json["experience"],
    );
  }
}
