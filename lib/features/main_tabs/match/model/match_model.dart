import '../../../../core/helpers/parser_helper.dart';
import '../../home/sub_feature/profile/model/profile_model.dart';

/*
class MatchResponseModel {
  MatchResponseModel({
    this.id,
    this.name,
    this.email,
    this.images,
    this.address,
    this.children,
    this.dob,
    this.state,
    this.city,
    this.bio,
    this.interesteds,
    this.mumStage,
    this.distanceKm,
    this.profileImage,
    this.location,
  });

  final String? id;
  final String? name;
  final String? email;
  final List<String>? images;
  final String? profileImage;
  final LocationCordsDataModel? location;
  final String? address;
  final List<Child>? children;
  final DateTime? dob;
  final String? state;
  final String? city;
  final String? bio;
  final List<String>? interesteds;
  final String? mumStage;
  final double? distanceKm;

  factory MatchResponseModel.fromJson(Map<String, dynamic> json) {
    return MatchResponseModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
      address: json["address"],
      location: json["location"] == null ? null : LocationCordsDataModel.fromJson(json["location"]),
      profileImage: json["profileImage"]?.toString(),
      children: json["children"] == null
          ? []
          : List<Child>.from(json["children"]!.map((x) => Child.fromJson(x))),
      dob: DateTime.tryParse(json["DOB"] ?? ""),
      state: json["state"],
      city: json["city"],
      bio: json["bio"],
      interesteds: json["interesteds"] == null
          ? []
          : List<String>.from(json["interesteds"]!.map((x) => x)),
      mumStage: json["mumStage"],
      distanceKm: (json["distanceKm"] as num).toDouble(),
    );
  }
}

class Child {
  Child({this.gender, this.dob, this.id});

  final String? gender;
  final DateTime? dob;
  final String? id;

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      gender: json["gender"],
      dob: DateTime.tryParse(json["dob"] ?? ""),
      id: json["_id"],
    );
  }
}
*/

class MatchResponseModel {
  const MatchResponseModel({
    this.id = '',

    this.name = '',

    this.email = '',

    this.images = const [],

    this.profileImage = '',

    this.location,

    this.address = '',

    this.children = const [],

    this.dob,

    this.state = '',

    this.city = '',

    this.bio = '',

    this.interesteds = const [],

    this.mumStage = '',

    this.distanceKm = 0.0,
  });

  final String id;

  final String name;

  final String email;

  final List<String> images;

  final String profileImage;

  final LocationCordsDataModel? location;

  final String address;

  final List<Child> children;

  final DateTime? dob;

  final String state;

  final String city;

  final String bio;

  final List<String> interesteds;

  final String mumStage;

  final double distanceKm;

  factory MatchResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MatchResponseModel();

    return MatchResponseModel(
      id: SafeParser.id(json['_id']),

      name: SafeParser.str(json['name']),

      email: SafeParser.str(json['email']),

      address: SafeParser.str(json['address']),

      profileImage: SafeParser.str(json['profileImage']),

      state: SafeParser.str(json['state']),

      city: SafeParser.str(json['city']),

      bio: SafeParser.str(json['bio']),

      mumStage: SafeParser.str(json['mumStage']),

      dob: SafeParser.date(json['DOB']),

      distanceKm: SafeParser.dbl(json['distanceKm']),

      images: SafeParser.stringList(json['images']),

      interesteds: SafeParser.stringList(json['interesteds']),

      children: SafeParser.list<Child>(json['children'], Child.fromJson),

      location: SafeParser.object(
        json['location'],

        LocationCordsDataModel.fromJson,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,

    'name': name,

    'email': email,

    'images': images,

    'profileImage': profileImage,

    'address': address,

    'DOB': dob?.toIso8601String(),

    'state': state,

    'city': city,

    'bio': bio,

    'interesteds': interesteds,

    'mumStage': mumStage,

    'distanceKm': distanceKm,

    'location': location,

    'children': children.map((e) => e.toJson()).toList(),
  };
}

class Child {
  const Child({this.gender = '', this.dob, this.id = ''});

  final String gender;

  final DateTime? dob;

  final String id;

  factory Child.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Child();

    return Child(
      gender: SafeParser.str(json['gender']),

      id: SafeParser.id(json['_id']),

      dob: SafeParser.date(json['dob']),
    );
  }

  Map<String, dynamic> toJson() => {
    'gender': gender,

    'dob': dob?.toIso8601String(),

    '_id': id,
  };
}
