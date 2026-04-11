class LiveSessionInfoModel {
  LiveSessionInfoModel({this.channelName, this.token, this.uid});

  final String? channelName;
  final String? token;
  final int? uid;

  factory LiveSessionInfoModel.fromJson(Map<String, dynamic> json) {
    return LiveSessionInfoModel(
      channelName: json["channelName"],
      token: json["token"],
      uid: json["uid"],
    );
  }
}
