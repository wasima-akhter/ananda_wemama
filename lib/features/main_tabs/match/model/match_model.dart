import '../../../../core/helpers/parser_helper.dart';
import '../../home/sub_feature/profile/model/profile_model.dart';

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
