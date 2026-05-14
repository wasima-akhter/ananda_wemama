class CompleteProfileModel {
  CompleteProfileModel({
    this.location,
    this.subscription,
    this.id,
    this.auth,
    this.name,
    this.email,
    this.phone,
    this.images = const [],
    this.address,
    this.children = const [],
    this.dob,
    this.state,
    this.city,
    this.bio,
    this.interesteds = const [],
    this.mumStage,
    this.matchCount = 0,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final Location? location;
  final Subscription? subscription;
  final String? id;
  final String? auth;
  final String? name;
  final String? email;
  final String? phone;
  final List<String> images;
  final String? address;
  final List<ProfileChildren> children;
  final DateTime? dob;
  final String? state;
  final String? city;
  final String? bio;
  final List<String> interesteds;
  final String? mumStage;
  final int matchCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory CompleteProfileModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CompleteProfileModel();

    return CompleteProfileModel(
      location: json["location"] != null ? Location.fromJson(json["location"]) : null,

      subscription: json["subscription"] != null
          ? Subscription.fromJson(json["subscription"])
          : null,

      id: json["_id"]?.toString(),
      auth: json["auth"]?.toString(),
      name: json["name"]?.toString(),
      email: json["email"]?.toString(),
      phone: json["phone"]?.toString(),

      images: json["images"] == null
          ? []
          : List<String>.from(json["images"].map((x) => x.toString())),

      address: json["address"]?.toString(),

      children: json["children"] == null
          ? []
          : List<ProfileChildren>.from(
              json["children"].map((x) => ProfileChildren.fromJson(x as Map<String, dynamic>)),
            ),

      dob: json["DOB"] != null ? DateTime.tryParse(json["DOB"].toString()) : null,

      state: json["state"]?.toString(),
      city: json["city"]?.toString(),
      bio: json["bio"]?.toString(),

      interesteds: json["interesteds"] is List
          ? List<String>.from(json["interesteds"].map((x) => x.toString()))
          : [],

      mumStage: json["mumStage"]?.toString(),

      matchCount: json["matchCount"] is int
          ? json["matchCount"]
          : int.tryParse(json["matchCount"]?.toString() ?? "0") ?? 0,

      createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"].toString()) : null,

      updatedAt: json["updatedAt"] != null ? DateTime.tryParse(json["updatedAt"].toString()) : null,

      v: json["__v"] is int ? json["__v"] : int.tryParse(json["__v"]?.toString() ?? ""),
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

class Location {
  Location({this.type, this.coordinates = const []});

  final String? type;
  final List<double> coordinates;

  factory Location.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Location();

    return Location(
      type: json["type"]?.toString(),
      coordinates: json["coordinates"] is List
          ? (json["coordinates"] as List).map((e) => (e as num).toDouble()).toList()
          : [],
    );
  }
}

class Subscription {
  Subscription({this.isSubscribed, this.subscribedAt, this.expiredAt});

  final bool? isSubscribed;
  final dynamic subscribedAt;
  final dynamic expiredAt;

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      isSubscribed: json["isSubscribed"],
      subscribedAt: json["subscribedAt"],
      expiredAt: json["expiredAt"],
    );
  }
}
