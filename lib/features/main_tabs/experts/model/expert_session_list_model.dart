import '../../../../core/helpers/parser_helper.dart';

class ExpertSessionsListModel {
  const ExpertSessionsListModel({this.sessions = const []});

  final List<Session> sessions;

  factory ExpertSessionsListModel.fromList(List<dynamic>? json) {
    return ExpertSessionsListModel(
      sessions: SafeParser.list(json, Session.fromJson),
    );
  }
}

/*
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
    this.deepLinkUrl,
    this.reminderEnabled = false,
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

  final bool reminderEnabled;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  // deeplinkUrl
  final String? deepLinkUrl;

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

      deepLinkUrl: SafeParser.str(json['deepLinkUrl']),

      doctorUid: json['doctorUid'],
      recordingUid: json['recordingUid'],
      duration: json['duration'],
      finishedAt: json['finishedAt'],

      date: SafeParser.date(json['date']),
      startedAt: SafeParser.date(json['startedAt']),

      createdAt: SafeParser.date(json['createdAt']),
      updatedAt: SafeParser.date(json['updatedAt']),

      isApproved: SafeParser.boolVal(json['isApproved']),
      reminderEnabled: SafeParser.boolVal(json['reminderEnabled']),

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
*/

class Session {
  const Session({
    this.id = '',
    this.expert,
    this.status = '',
    this.title = '',
    this.description = '',
    this.time = '',
    this.date,
    this.dateTime,
    this.timezone = '',
    this.channelName = '',
    this.doctorUid,
    this.recordingUid,
    this.resourceId = '',
    this.sid = '',
    this.recordingMp4Url = '',
    this.recordingHlsUrl = '',
    this.recordingStatus = '',
    this.recordingStartedAt,
    this.recordingStoppedAt,
    this.recordingLastEvent = '',
    this.recordingLastEventAt,
    this.recordingError = '',
    this.hostConnectionStatus = '',
    this.hostJoinedAt,
    this.hostDisconnectedAt,
    this.hostReconnectDeadlineAt,
    this.hostJoinCount = 0,
    this.hostLeaveCount = 0,
    this.activeAudienceUids = const [],
    this.activeAudienceUsers = const [],
    this.audienceCount = 0,
    this.peakAudienceCount = 0,
    this.audienceJoinCount = 0,
    this.audienceLeaveCount = 0,
    this.autoEndedByWebhook = false,
    this.endReason = '',
    this.endedBy = '',
    this.lastAgoraRtcEventType,
    this.lastAgoraRtcEventAt,
    this.duration,
    this.startedAt,
    this.finishedAt,
    this.isApproved = false,
    this.recordingFiles = const [],
    this.createdAt,
    this.updatedAt,
    this.v = 0,
    this.deepLinkUrl,
    this.reminderEnabled = false,
  });

  final String id;
  final Expert? expert;

  final String status;
  final String title;
  final String description;

  /// Existing fields kept for compatibility.
  final String time;
  final DateTime? date;

  /// New API field: dateTime
  final DateTime? dateTime;

  /// New API field: timezone
  final String timezone;

  final String channelName;

  final dynamic doctorUid;
  final dynamic recordingUid;
  final dynamic duration;
  final dynamic finishedAt;

  final String resourceId;
  final String sid;

  final String recordingMp4Url;
  final String recordingHlsUrl;

  // ============================================================
  // Recording
  // ============================================================

  final String recordingStatus;

  final DateTime? recordingStartedAt;
  final DateTime? recordingStoppedAt;

  final String recordingLastEvent;
  final DateTime? recordingLastEventAt;

  final String recordingError;

  // ============================================================
  // Host
  // ============================================================

  final String hostConnectionStatus;

  final DateTime? hostJoinedAt;
  final DateTime? hostDisconnectedAt;
  final DateTime? hostReconnectDeadlineAt;

  final int hostJoinCount;
  final int hostLeaveCount;

  // ============================================================
  // Audience
  // ============================================================

  final List<dynamic> activeAudienceUids;
  final List<dynamic> activeAudienceUsers;

  final int audienceCount;
  final int peakAudienceCount;
  final int audienceJoinCount;
  final int audienceLeaveCount;

  // ============================================================
  // Session ending
  // ============================================================

  final bool autoEndedByWebhook;

  final String endReason;
  final String endedBy;

  final dynamic lastAgoraRtcEventType;
  final DateTime? lastAgoraRtcEventAt;

  // ============================================================
  // Existing
  // ============================================================

  final DateTime? startedAt;

  final bool isApproved;

  final List<RecordingFile> recordingFiles;

  final bool reminderEnabled;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? deepLinkUrl;

  final int v;

  // ============================================================
  // FROM JSON
  // ============================================================

  factory Session.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Session();
    }

    // API currently returns dateTime instead of date/time.
    final dateTime = SafeParser.date(json['dateTime']);

    return Session(
      id: SafeParser.id(json['_id']),

      expert: SafeParser.object(json['expert'], Expert.fromJson),

      status: SafeParser.str(json['status']),
      title: SafeParser.str(json['title']),
      description: SafeParser.str(json['description']),

      // Keep supporting the old fields.
      time: SafeParser.str(json['time']),
      date: SafeParser.date(json['date']),

      // New API format.
      dateTime: dateTime,
      timezone: SafeParser.str(json['timezone']),

      channelName: SafeParser.str(json['channelName']),

      resourceId: SafeParser.str(json['resourceId']),
      sid: SafeParser.str(json['sid']),

      recordingMp4Url: SafeParser.str(json['recordingMp4Url']),

      recordingHlsUrl: SafeParser.str(json['recordingHlsUrl']),

      // ========================================================
      // Recording
      // ========================================================
      recordingStatus: SafeParser.str(json['recordingStatus']),

      recordingStartedAt: SafeParser.date(json['recordingStartedAt']),

      recordingStoppedAt: SafeParser.date(json['recordingStoppedAt']),

      recordingLastEvent: SafeParser.str(json['recordingLastEvent']),

      recordingLastEventAt: SafeParser.date(json['recordingLastEventAt']),

      recordingError: SafeParser.str(json['recordingError']),

      // ========================================================
      // Host
      // ========================================================
      hostConnectionStatus: SafeParser.str(json['hostConnectionStatus']),

      hostJoinedAt: SafeParser.date(json['hostJoinedAt']),

      hostDisconnectedAt: SafeParser.date(json['hostDisconnectedAt']),

      hostReconnectDeadlineAt: SafeParser.date(json['hostReconnectDeadlineAt']),

      hostJoinCount: SafeParser.intVal(json['hostJoinCount']),

      hostLeaveCount: SafeParser.intVal(json['hostLeaveCount']),

      // ========================================================
      // Audience
      // ========================================================
      activeAudienceUids: _dynamicList(json['activeAudienceUids']),

      activeAudienceUsers: _dynamicList(json['activeAudienceUsers']),

      audienceCount: SafeParser.intVal(json['audienceCount']),

      peakAudienceCount: SafeParser.intVal(json['peakAudienceCount']),

      audienceJoinCount: SafeParser.intVal(json['audienceJoinCount']),

      audienceLeaveCount: SafeParser.intVal(json['audienceLeaveCount']),

      // ========================================================
      // Ending
      // ========================================================
      autoEndedByWebhook: SafeParser.boolVal(json['autoEndedByWebhook']),

      endReason: SafeParser.str(json['endReason']),

      endedBy: SafeParser.str(json['endedBy']),

      lastAgoraRtcEventType: json['lastAgoraRtcEventType'],

      lastAgoraRtcEventAt: SafeParser.date(json['lastAgoraRtcEventAt']),

      // ========================================================
      // Existing
      // ========================================================
      doctorUid: json['doctorUid'],
      recordingUid: json['recordingUid'],
      duration: json['duration'],

      finishedAt: json['finishedAt'] is String
          ? SafeParser.date(json['finishedAt'])
          : json['finishedAt'],

      startedAt: SafeParser.date(json['startedAt']),

      createdAt: SafeParser.date(json['createdAt']),

      updatedAt: SafeParser.date(json['updatedAt']),

      isApproved: SafeParser.boolVal(json['isApproved']),

      reminderEnabled: SafeParser.boolVal(json['reminderEnabled']),

      v: SafeParser.intVal(json['__v']),

      deepLinkUrl: SafeParser.str(json['deepLinkUrl']),

      recordingFiles: SafeParser.list<RecordingFile>(
        json['recordingFiles'],
        RecordingFile.fromJson,
      ),
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() => {
    '_id': id,

    'status': status,
    'title': title,
    'description': description,

    'time': time,
    'date': date?.toIso8601String(),

    'dateTime': dateTime?.toIso8601String(),
    'timezone': timezone,

    'channelName': channelName,

    'doctorUid': doctorUid,
    'recordingUid': recordingUid,

    'resourceId': resourceId,
    'sid': sid,

    'recordingMp4Url': recordingMp4Url,
    'recordingHlsUrl': recordingHlsUrl,

    // Recording
    'recordingStatus': recordingStatus,
    'recordingStartedAt': recordingStartedAt?.toIso8601String(),
    'recordingStoppedAt': recordingStoppedAt?.toIso8601String(),
    'recordingLastEvent': recordingLastEvent,
    'recordingLastEventAt': recordingLastEventAt?.toIso8601String(),
    'recordingError': recordingError,

    // Host
    'hostConnectionStatus': hostConnectionStatus,
    'hostJoinedAt': hostJoinedAt?.toIso8601String(),
    'hostDisconnectedAt': hostDisconnectedAt?.toIso8601String(),
    'hostReconnectDeadlineAt': hostReconnectDeadlineAt?.toIso8601String(),
    'hostJoinCount': hostJoinCount,
    'hostLeaveCount': hostLeaveCount,

    // Audience
    'activeAudienceUids': activeAudienceUids,
    'activeAudienceUsers': activeAudienceUsers,
    'audienceCount': audienceCount,
    'peakAudienceCount': peakAudienceCount,
    'audienceJoinCount': audienceJoinCount,
    'audienceLeaveCount': audienceLeaveCount,

    // Ending
    'autoEndedByWebhook': autoEndedByWebhook,
    'endReason': endReason,
    'endedBy': endedBy,
    'lastAgoraRtcEventType': lastAgoraRtcEventType,
    'lastAgoraRtcEventAt': lastAgoraRtcEventAt?.toIso8601String(),

    // Existing
    'duration': duration,
    'startedAt': startedAt?.toIso8601String(),
    'finishedAt': finishedAt is DateTime
        ? finishedAt.toIso8601String()
        : finishedAt,

    'isApproved': isApproved,

    'recordingFiles': recordingFiles.map((e) => e.toJson()).toList(),

    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),

    'deepLinkUrl': deepLinkUrl,

    'reminderEnabled': reminderEnabled,

    '__v': v,
  };

  // ============================================================
  // HELPERS
  // ============================================================

  static List<dynamic> _dynamicList(dynamic value) {
    if (value is List) {
      return List<dynamic>.from(value);
    }

    return const [];
  }
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
