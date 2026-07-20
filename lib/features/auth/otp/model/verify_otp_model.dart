class VerifyOtpDataModel {
  VerifyOtpDataModel({required this.user, required this.accessToken});

  final UserVerifyOtp? user;
  final String? accessToken;

  factory VerifyOtpDataModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpDataModel(
      user: json["user"] == null ? null : UserVerifyOtp.fromJson(json["user"]),
      accessToken: json["accessToken"],
    );
  }
}

class UserVerifyOtp {
  UserVerifyOtp({
    required this.id,
    required this.email,
    required this.role,
    required this.verificationCode,
    required this.isEmailVerified,
    required this.profile,
    required this.updatedAt,
    required this.profileId,
    required this.authId,
  });

  final String? id;
  final String? email;
  final String? role;
  final String? verificationCode;
  final bool? isEmailVerified;
  final String? profile;
  final DateTime? updatedAt;
  final String profileId;
  final String authId;

  factory UserVerifyOtp.fromJson(Map<String, dynamic> json) {
    return UserVerifyOtp(
      id: json["_id"],
      email: json["email"],
      role: json["role"],
      verificationCode: json["verificationCode"],
      isEmailVerified: json["isEmailVerified"],
      profile: json["profile"],
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      profileId: json['profileId'] ?? '',
      authId: json['authId'] ?? '',
    );
  }
}
