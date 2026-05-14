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
