import 'dart:developer';

class ProfileDataModel {
  ProfileDataModel({
    this.id,
    this.auth,
    this.name,
    this.email,
    this.phone,
    this.images = const [],
    this.location,
    this.address,
    this.children = const [],
    this.dob,
    this.dobObject, // ← new: full DOB object format
    this.state,
    this.city,
    this.bio,
    this.interesteds = const [],

    this.mumStages = const [], // ← new: list format
    this.subscription,
    this.matchCount,
    this.streakCount, // ← new
    this.agoraUid, // ← new
    this.createdAt,
    this.updatedAt,
    this.v,
    this.profileImage,
    this.referral,
    this.waveLimit,
    // new response fields
    this.isDeleted,
    this.matchLimitDate,
    this.matchSeenUsers = const [],
    this.totalMatching,
    // FCM
    this.fcmTokens = const [],
  });

  final String? id;
  final String? auth;
  final String? agoraUid; // ← new
  final String? name;
  final String? email;
  final String? phone;
  final String? profileImage;

  final List<String> images;
  final LocationCordsDataModel? location;

  final String? address;
  final List<ProfileChildren> children;

  // DOB — both formats
  final DateTime? dob; // flat DateTime (old format)
  final ProfileDobModel? dobObject; // ← new: {date, isPublic} object format

  final String? state;
  final String? city;
  final String? bio;

  final List<String> interesteds;

  // mumStage — both formats
  final List<String> mumStages; // ← new: list format

  final ProfileReferralModel? referral;

  final ProfileSubscriptionModel? subscription;

  final int? matchCount;
  final int? streakCount; // ← new

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final int? v;

  //

  final List<String> fcmTokens;
  //new ones
  final WaveLimitModel? waveLimit;

  final bool? isDeleted;

  final DateTime? matchLimitDate;

  final List<MatchSeenUserModel> matchSeenUsers;

  final int? totalMatching;

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    // ── DOB: handle both formats ──────────────────────────────────────────
    DateTime? dobFlat;
    ProfileDobModel? dobObj;

    final rawDob = json["DOB"];
    log(
      "rawDob runtimeType: ${rawDob.runtimeType}, value: $rawDob",
    ); // ← add this
    if (rawDob is Map<String, dynamic>) {
      dobObj = ProfileDobModel.fromJson(rawDob);
      dobFlat = dobObj.date; // derive flat date from object too
    } else if (rawDob is String) {
      dobFlat = DateTime.tryParse(rawDob);
    }

    // ── mumStage: handle both formats ─────────────────────────────────────
    String? mumStageSingle;
    List<String> mumStageList = [];

    final rawMumStage = json["mumStage"];
    if (rawMumStage is List) {
      mumStageList = List<String>.from(rawMumStage.map((x) => x.toString()));
      mumStageSingle = mumStageList.isNotEmpty ? mumStageList.first : null;
    } else if (rawMumStage is String) {
      mumStageSingle = rawMumStage;
      mumStageList = [rawMumStage];
    }

    return ProfileDataModel(
      id: json["_id"],
      auth: json["auth"],
      agoraUid: json["agoraUid"]?.toString(), // ← new (nullable)
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      profileImage: json["profileImage"]?.toString(),

      images: json["images"] == null
          ? []
          : List<String>.from(json["images"].map((x) => x.toString())),

      location: json["location"] == null
          ? null
          : LocationCordsDataModel.fromJson(json["location"]),

      address: json["address"]?.toString(),

      children: json["children"] == null
          ? []
          : List<ProfileChildren>.from(
              json["children"].map(
                (x) => ProfileChildren.fromJson(x as Map<String, dynamic>),
              ),
            ),

      dob: dobFlat,
      dobObject: dobObj,

      state: json["state"],
      city: json["city"],
      bio: json["bio"],

      interesteds: json["interesteds"] == null
          ? []
          : List<String>.from(json["interesteds"].map((x) => x.toString())),

      mumStages: mumStageList,

      referral: json["referral"] == null
          ? null
          : ProfileReferralModel.fromJson(json["referral"]),

      subscription: json["subscription"] == null
          ? null
          : ProfileSubscriptionModel.fromJson(json["subscription"]),

      matchCount: json["matchCount"],
      streakCount: json["streakCount"], // ← new

      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"].toString())
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"].toString())
          : null,

      v: json["__v"],

      //
      fcmTokens: json["fcmTokens"] == null
          ? []
          : List<String>.from(json["fcmTokens"].map((x) => x.toString())),

      //
      waveLimit: json["waveLimit"] == null
          ? null
          : WaveLimitModel.fromJson(json["waveLimit"]),
      //
      isDeleted: parseBool(json["isDeleted"]),

      matchLimitDate: json["matchLimitDate"] != null
          ? DateTime.tryParse(json["matchLimitDate"].toString())
          : null,

      matchSeenUsers: json["matchSeenUsers"] == null
          ? []
          : List<MatchSeenUserModel>.from(
              json["matchSeenUsers"].map(
                (x) => MatchSeenUserModel.fromJson(x as Map<String, dynamic>),
              ),
            ),

      totalMatching: parseInt(json["totalMatching"]),
    );
  }
}

class MatchSeenUserModel {
  MatchSeenUserModel({this.user, this.seenAt, this.id});

  final String? user;
  final DateTime? seenAt;
  final String? id;

  factory MatchSeenUserModel.fromJson(Map<String, dynamic> json) {
    return MatchSeenUserModel(
      user: json["user"]?.toString(),

      seenAt: json["seenAt"] != null
          ? DateTime.tryParse(json["seenAt"].toString())
          : null,

      id: json["_id"]?.toString(),
    );
  }
}

bool? parseBool(dynamic value) {
  if (value is bool) return value;

  if (value is String) {
    return value.toLowerCase() == "true";
  }

  return null;
}

int? parseInt(dynamic value) {
  if (value is int) return value;

  if (value is String) {
    return int.tryParse(value);
  }

  return null;
}

class WaveLimitModel {
  final int limit;
  final int used;
  final int remaining;
  final bool isUnlimited;

  WaveLimitModel({
    this.limit = 0,
    this.used = 0,
    this.remaining = 0,
    this.isUnlimited = false,
  });

  factory WaveLimitModel.fromJson(Map<String, dynamic> json) {
    return WaveLimitModel(
      limit: json["limit"] ?? 0,
      used: json["used"] ?? 0,
      remaining: json["remaining"] ?? 0,
      isUnlimited: json["isUnlimited"] ?? false,
    );
  }
}

class ProfileReferralModel {
  ProfileReferralModel({this.code, this.isRedeemed, this.redeemedAt});

  final String? code;
  final bool? isRedeemed;
  final DateTime? redeemedAt;

  factory ProfileReferralModel.fromJson(Map<String, dynamic> json) {
    return ProfileReferralModel(
      code: json["code"]?.toString(),
      isRedeemed: json["isRedeemed"] as bool?,
      redeemedAt: json["redeemedAt"] != null
          ? DateTime.tryParse(json["redeemedAt"].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "isRedeemed": isRedeemed,
      "redeemedAt": redeemedAt?.toIso8601String(),
    };
  }
}

// ── New: DOB object model ─────────────────────────────────────────────────────
class ProfileDobModel {
  ProfileDobModel({this.date, this.isPublic});

  final DateTime? date;
  final bool? isPublic;

  factory ProfileDobModel.fromJson(Map<String, dynamic> json) {
    log("----ProfileDobModel raw json: $json");
    log(
      "----isPublic raw value: ${json["isPublic"]} | type: ${json["isPublic"].runtimeType}",
    );
    return ProfileDobModel(
      date: json["date"] != null
          ? DateTime.tryParse(json["date"].toString())
          : null,
      isPublic: json["isPublic"],
    );
  }
}

class ProfileChildren {
  ProfileChildren({this.gender, this.dob, this.id});

  final String? gender;
  final DateTime? dob;
  final String? id;

  factory ProfileChildren.fromJson(Map<String, dynamic> json) {
    return ProfileChildren(
      gender: json["gender"],
      dob: DateTime.tryParse(json["dob"] ?? ""),
      id: json["_id"],
    );
  }
}

class LocationCordsDataModel {
  LocationCordsDataModel({this.type, this.coordinates = const []});

  final String? type;
  final List<double> coordinates;

  factory LocationCordsDataModel.fromJson(Map<String, dynamic> json) {
    return LocationCordsDataModel(
      type: json["type"],
      coordinates: json["coordinates"] == null
          ? []
          : List<double>.from(
              json["coordinates"].map((x) => (x as num).toDouble()),
            ),
    );
  }
}

class ProfileSubscriptionModel {
  ProfileSubscriptionModel({
    this.isSubscribed,
    this.planType, // ← new
    this.planPrice, // ← new
    this.subscribedAt,
    this.expiredAt,
  });

  final bool? isSubscribed;
  final String? planType; // ← new
  final num? planPrice; // ← new

  final DateTime? subscribedAt;
  final DateTime? expiredAt;

  factory ProfileSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return ProfileSubscriptionModel(
      isSubscribed: json["isSubscribed"],
      planType: json["planType"]?.toString(), // ← new
      planPrice: json["planPrice"] as num?, // ← new
      subscribedAt: json["subscribedAt"] != null
          ? DateTime.tryParse(json["subscribedAt"].toString())
          : null,
      expiredAt: json["expiredAt"] != null
          ? DateTime.tryParse(json["expiredAt"].toString())
          : null,
    );
  }
}
