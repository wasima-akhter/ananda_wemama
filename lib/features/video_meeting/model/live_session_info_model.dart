class LiveSessionInfoModel {
  LiveSessionInfoModel({
    this.channelName,
    this.uid,
    this.rtcToken,
    this.rtmToken,
    this.userName,
    this.userAvatar,
  });

  final String? channelName;
  final String? rtmToken;
  final String? rtcToken;

  final String? userName;
  final String? userAvatar;
  final int? uid;

  factory LiveSessionInfoModel.fromJson(Map<String, dynamic> json) {
    return LiveSessionInfoModel(
      channelName: json["channelName"],
      rtmToken: json["rtmToken"],
      rtcToken: json["rtcToken"],
      userName: json["userName"],
      userAvatar: json["userAvatar"],
      uid: json["uid"],
    );
  }
}

// channelName,
//   rtcToken,
//   rtmToken:chatToken,
//   uid,
//   userName: user?.name
