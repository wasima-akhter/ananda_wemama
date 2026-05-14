class ExpertSessionsListModel {
  ExpertSessionsListModel({this.meta, this.sessions});

  final Meta? meta;
  final List<Session>? sessions;

  factory ExpertSessionsListModel.fromJson(Map<String, dynamic> json) {
    return ExpertSessionsListModel(
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      sessions: json["sessions"] == null
          ? []
          : List<Session>.from(json["sessions"]!.map((x) => Session.fromJson(x))),
    );
  }
}

class Meta {
  Meta({this.page, this.limit, this.total, this.totalPage});

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json["page"],
      limit: json["limit"],
      total: json["total"],
      totalPage: json["totalPage"],
    );
  }
}

class Session {
  Session({
    this.id,
    this.expert,
    this.status,
    this.title,
    this.description,
    this.time,
    this.date,
    this.channelName,
    this.doctorUid,
    this.recordingUid,
    this.resourceId,
    this.sid,
    this.recordingMp4Url,
    this.recordingHlsUrl,
    this.duration,
    this.startedAt,
    this.finishedAt,
    this.isApproved,
    this.recordingFiles,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final Expert? expert;
  final String? status;
  final String? title;
  final String? description;
  final String? time;
  final DateTime? date;
  final String? channelName;
  final dynamic doctorUid;
  final dynamic recordingUid;
  final String? resourceId;
  final String? sid;
  final String? recordingMp4Url;
  final String? recordingHlsUrl;
  final dynamic duration;
  final DateTime? startedAt;
  final dynamic finishedAt;
  final bool? isApproved;
  final List<RecordingFile>? recordingFiles;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json["_id"],
      expert: json["expert"] == null ? null : Expert.fromJson(json["expert"]),
      status: json["status"],
      title: json["title"],
      description: json["description"],
      time: json["time"],
      date: DateTime.tryParse(json["date"] ?? ""),
      channelName: json["channelName"],
      doctorUid: json["doctorUid"],
      recordingUid: json["recordingUid"],
      resourceId: json["resourceId"],
      sid: json["sid"],
      recordingMp4Url: json["recordingMp4Url"],
      recordingHlsUrl: json["recordingHlsUrl"],
      duration: json["duration"],
      startedAt: DateTime.tryParse(json["startedAt"] ?? ""),
      finishedAt: json["finishedAt"],
      isApproved: json["isApproved"],
      recordingFiles: json["recordingFiles"] == null
          ? []
          : List<RecordingFile>.from(json["recordingFiles"]!.map((x) => RecordingFile.fromJson(x))),

      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }
}

class Expert {
  Expert({this.id, this.name, this.email, this.image, this.profession});

  final String? id;
  final String? name;
  final String? email;
  final String? image;
  final Profession? profession;

  factory Expert.fromJson(Map<String, dynamic> json) {
    return Expert(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      image: json["image"],
      profession: json["profession"] == null ? null : Profession.fromJson(json["profession"]),
    );
  }
}

class Profession {
  Profession({this.designation, this.title, this.experience});

  final List<String>? designation;
  final String? title;
  final int? experience;

  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(
      designation: json["designation"] == null
          ? []
          : List<String>.from(json["designation"]!.map((x) => x)),
      title: json["title"],
      experience: json["experience"],
    );
  }
}

class RecordingFile {
  RecordingFile({this.filename, this.url, this.type});

  final String? filename;
  final String? url;
  final String? type;

  factory RecordingFile.fromJson(Map<String, dynamic> json) {
    return RecordingFile(filename: json["filename"], url: json["url"], type: json["type"]);
  }
}
