/*

class ExpertSessionsListModel {
  ExpertSessionsListModel({this.meta, this.sessions});

  final Meta? meta;
  final List<Session>? sessions;

  factory ExpertSessionsListModel.fromJson(Map<String, dynamic> json) {
    return ExpertSessionsListModel(
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      sessions: json["sessions"] == null
          ? []
          : List<Session>.from(
              json["sessions"]!.map((x) => Session.fromJson(x)),
            ),
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
          : List<RecordingFile>.from(
              json["recordingFiles"]!.map((x) => RecordingFile.fromJson(x)),
            ),

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
      profession: json["profession"] == null
          ? null
          : Profession.fromJson(json["profession"]),
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
    return RecordingFile(
      filename: json["filename"],
      url: json["url"],
      type: json["type"],
    );
  }
}

*/

import '../../../../core/helpers/parser_helper.dart';

class ExpertSessionsListModel {
  const ExpertSessionsListModel({this.meta, this.sessions = const []});

  final Meta? meta;
  final List<Session> sessions;

  factory ExpertSessionsListModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ExpertSessionsListModel();
    }

    return ExpertSessionsListModel(
      meta: SafeParser.object(json['meta'], Meta.fromJson),
      sessions: SafeParser.list<Session>(json['sessions'], Session.fromJson),
    );
  }
}

class Meta {
  const Meta({
    this.page = 0,
    this.limit = 0,
    this.total = 0,
    this.totalPage = 0,
  });

  final int page;
  final int limit;
  final int total;
  final int totalPage;

  factory Meta.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Meta();
    }

    return Meta(
      page: SafeParser.intVal(json['page']),
      limit: SafeParser.intVal(json['limit']),
      total: SafeParser.intVal(json['total']),
      totalPage: SafeParser.intVal(json['totalPage']),
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'total': total,
    'totalPage': totalPage,
  };
}

class Session {
  const Session({
    this.id = '',
    this.expert,
    this.status = '',
    this.title = '',
    this.description = '',
    this.time = '',
    this.date,
    this.channelName = '',
    this.doctorUid,
    this.recordingUid,
    this.resourceId = '',
    this.sid = '',
    this.recordingMp4Url = '',
    this.recordingHlsUrl = '',
    this.duration,
    this.startedAt,
    this.finishedAt,
    this.isApproved = false,
    this.recordingFiles = const [],
    this.createdAt,
    this.updatedAt,
    this.v = 0,
  });

  final String id;
  final Expert? expert;
  final String status;
  final String title;
  final String description;
  final String time;
  final DateTime? date;
  final String channelName;

  final dynamic doctorUid;
  final dynamic recordingUid;
  final dynamic duration;
  final dynamic finishedAt;

  final String resourceId;
  final String sid;
  final String recordingMp4Url;
  final String recordingHlsUrl;

  final DateTime? startedAt;
  final bool isApproved;

  final List<RecordingFile> recordingFiles;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final int v;

  factory Session.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Session();
    }

    return Session(
      id: SafeParser.id(json['_id']),

      expert: SafeParser.object(json['expert'], Expert.fromJson),

      status: SafeParser.str(json['status']),
      title: SafeParser.str(json['title']),
      description: SafeParser.str(json['description']),
      time: SafeParser.str(json['time']),
      channelName: SafeParser.str(json['channelName']),

      resourceId: SafeParser.str(json['resourceId']),
      sid: SafeParser.str(json['sid']),
      recordingMp4Url: SafeParser.str(json['recordingMp4Url']),
      recordingHlsUrl: SafeParser.str(json['recordingHlsUrl']),

      doctorUid: json['doctorUid'],
      recordingUid: json['recordingUid'],
      duration: json['duration'],
      finishedAt: json['finishedAt'],

      date: SafeParser.date(json['date']),
      startedAt: SafeParser.date(json['startedAt']),

      createdAt: SafeParser.date(json['createdAt']),
      updatedAt: SafeParser.date(json['updatedAt']),

      isApproved: SafeParser.boolVal(json['isApproved']),

      v: SafeParser.intVal(json['__v']),

      recordingFiles: SafeParser.list<RecordingFile>(
        json['recordingFiles'],
        RecordingFile.fromJson,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'status': status,
    'title': title,
    'description': description,
    'time': time,
    'date': date?.toIso8601String(),
    'channelName': channelName,
    'doctorUid': doctorUid,
    'recordingUid': recordingUid,
    'resourceId': resourceId,
    'sid': sid,
    'recordingMp4Url': recordingMp4Url,
    'recordingHlsUrl': recordingHlsUrl,
    'duration': duration,
    'finishedAt': finishedAt,
    'startedAt': startedAt?.toIso8601String(),
    'isApproved': isApproved,
    'recordingFiles': recordingFiles.map((e) => e.toJson()).toList(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}

class Expert {
  const Expert({
    this.id = '',

    this.name = '',

    this.email = '',

    this.image = '',

    this.profession,
  });

  final String id;

  final String name;

  final String email;

  final String image;

  final Profession? profession;

  factory Expert.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Expert();
    }

    return Expert(
      id: SafeParser.id(json['_id']),

      name: SafeParser.str(json['name']),

      email: SafeParser.str(json['email']),

      image: SafeParser.str(json['image']),

      profession: SafeParser.object(json['profession'], Profession.fromJson),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,

    'name': name,

    'email': email,

    'image': image,

    'profession': profession?.toJson(),
  };
}

class Profession {
  const Profession({
    this.designation = const [],

    this.title = '',

    this.experience = 0,
  });

  final List<String> designation;

  final String title;

  final int experience;

  factory Profession.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Profession();
    }

    return Profession(
      designation: SafeParser.stringList(json['designation']),

      title: SafeParser.str(json['title']),

      experience: SafeParser.intVal(json['experience']),
    );
  }

  Map<String, dynamic> toJson() => {
    'designation': designation,

    'title': title,

    'experience': experience,
  };
}

class RecordingFile {
  const RecordingFile({this.filename = '', this.url = '', this.type = ''});

  final String filename;

  final String url;

  final String type;

  factory RecordingFile.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const RecordingFile();
    }

    return RecordingFile(
      filename: SafeParser.str(json['filename']),

      url: SafeParser.str(json['url']),

      type: SafeParser.str(json['type']),
    );
  }

  Map<String, dynamic> toJson() => {
    'filename': filename,

    'url': url,

    'type': type,
  };
}
