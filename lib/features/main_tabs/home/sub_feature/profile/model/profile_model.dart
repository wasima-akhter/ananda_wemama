/*
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
    this.state,
    this.city,
    this.bio,
    this.interesteds = const [],
    this.mumStage,
    this.subscription,
    this.matchCount,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.profileImage,
  });

  final String? id;
  final String? auth;
  final String? name;
  final String? email;
  final String? phone;
  final String? profileImage;

  final List<String> images;
  final LocationCordsDataModel? location;

  final String? address;
  final List<ProfileChildren> children;

  final DateTime? dob;

  final String? state;
  final String? city;
  final String? bio;

  final List<String> interesteds;

  final String? mumStage;

  final ProfileSubscriptionModel? subscription;

  final int? matchCount;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final int? v;

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileDataModel(
      id: json["_id"],
      auth: json["auth"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      profileImage: json["profileImage"]?.toString(),

      images: json["images"] == null
          ? []
          : List<String>.from(json["images"].map((x) => x.toString())),

      location: json["location"] == null ? null : LocationCordsDataModel.fromJson(json["location"]),

      address: json["address"]?.toString(),

      children: json["children"] == null
          ? []
          : List<ProfileChildren>.from(
              json["children"].map((x) => ProfileChildren.fromJson(x as Map<String, dynamic>)),
            ),

      dob: json["DOB"] != null ? DateTime.tryParse(json["DOB"].toString()) : null,

      state: json["state"],
      city: json["city"],
      bio: json["bio"],

      interesteds: json["interesteds"] == null
          ? []
          : List<String>.from(json["interesteds"].map((x) => x.toString())),

      mumStage: json["mumStage"],

      subscription: json["subscription"] == null
          ? null
          : ProfileSubscriptionModel.fromJson(json["subscription"]),

      matchCount: json["matchCount"],

      createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"].toString()) : null,

      updatedAt: json["updatedAt"] != null ? DateTime.tryParse(json["updatedAt"].toString()) : null,

      v: json["__v"],
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
          : List<double>.from(json["coordinates"].map((x) => (x as num).toDouble())),
    );
  }
}

class ProfileSubscriptionModel {
  ProfileSubscriptionModel({this.isSubscribed, this.subscribedAt, this.expiredAt});

  final bool? isSubscribed;
  final DateTime? subscribedAt;
  final DateTime? expiredAt;

  factory ProfileSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return ProfileSubscriptionModel(
      isSubscribed: json["isSubscribed"],
      subscribedAt: json["subscribedAt"] != null
          ? DateTime.tryParse(json["subscribedAt"].toString())
          : null,
      expiredAt: json["expiredAt"] != null ? DateTime.tryParse(json["expiredAt"].toString()) : null,
    );
  }
}
*/

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

  final ProfileSubscriptionModel? subscription;

  final int? matchCount;
  final int? streakCount; // ← new

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final int? v;

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
    );
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
