import '../../../../core/helpers/parser_helper.dart';
import '../../experts/model/expert_session_list_model.dart';

 class CommunitySpotlightModel {
  const CommunitySpotlightModel({
    this.communitySpotlight,

    this.liveSession = const [],
  });

  final CommunitySpotlightData? communitySpotlight;

  final List<Session> liveSession;

  factory CommunitySpotlightModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CommunitySpotlightModel();

    return CommunitySpotlightModel(
      communitySpotlight: SafeParser.object(
        json['communitySpotlight'],

        CommunitySpotlightData.fromJson,
      ),

      liveSession: SafeParser.list<Session>(
        json['liveSession'],

        Session.fromJson,
      ),
    );
  }
}

class CommunitySpotlightData {
  const CommunitySpotlightData({
    this.id = '',

    this.name = '',

    this.totalMember = 0,

    this.createdAt,

    this.lastPost,
  });

  final String id;

  final String name;

  final int totalMember;

  final DateTime? createdAt;

  final LastPost? lastPost;

  factory CommunitySpotlightData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CommunitySpotlightData();
    }

    return CommunitySpotlightData(
      id: SafeParser.id(json['_id']),

      name: SafeParser.str(json['name']),

      totalMember: SafeParser.intVal(json['totalMember']),

      createdAt: SafeParser.date(json['createdAt']),

      lastPost: SafeParser.object(json['lastPost'], LastPost.fromJson),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,

    'name': name,

    'totalMember': totalMember,

    'createdAt': createdAt?.toIso8601String(),

    'lastPost': lastPost?.toJson(),
  };
}

class LastPost {
  const LastPost({
    this.id = '',

    this.content = '',

    this.totalLike = 0,

    this.totalComment = 0,

    this.createdAt,
  });

  final String id;

  final String content;

  final int totalLike;

  final int totalComment;

  final DateTime? createdAt;

  factory LastPost.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const LastPost();
    }

    return LastPost(
      id: SafeParser.id(json['_id']),

      content: SafeParser.str(json['content']),

      totalLike: SafeParser.intVal(json['totalLike']),

      totalComment: SafeParser.intVal(json['totalComment']),

      createdAt: SafeParser.date(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,

    'content': content,

    'totalLike': totalLike,

    'totalComment': totalComment,

    'createdAt': createdAt?.toIso8601String(),
  };
}

class Expert {
  const Expert({
    this.id = '',

    this.name = '',

    this.email = '',

    this.image = '',

    this.profession,
  });

  final String id;

  final String name;

  final String email;

  final String image;

  final Profession? profession;

  factory Expert.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Expert();
    }

    return Expert(
      id: SafeParser.id(json['_id']),

      name: SafeParser.str(json['name']),

      email: SafeParser.str(json['email']),

      image: SafeParser.str(json['image']),

      profession: SafeParser.object(json['profession'], Profession.fromJson),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,

    'name': name,

    'email': email,

    'image': image,

    'profession': profession?.toJson(),
  };
}

class Profession {
  const Profession({
    this.designation = const [],

    this.title = '',

    this.experience = 0,
  });

  final List<String> designation;

  final String title;

  final int experience;

  factory Profession.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Profession();
    }

    return Profession(
      designation: SafeParser.stringList(json['designation']),

      title: SafeParser.str(json['title']),

      experience: SafeParser.intVal(json['experience']),
    );
  }

  Map<String, dynamic> toJson() => {
    'designation': designation,

    'title': title,

    'experience': experience,
  };
}
