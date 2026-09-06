import '../../../../core/helpers/parser_helper.dart';

class ChatListItemModel {
  const ChatListItemModel({
    this.id = '',
    this.otherUser,
    this.isBlocked = false,
    this.lastMessage = '',
    this.time,
  });

  final String id;
  final OtherUser? otherUser;
  final bool isBlocked;
  final String lastMessage;
  final DateTime? time;

  factory ChatListItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ChatListItemModel();
    }

    return ChatListItemModel(
      id: SafeParser.id(json['_id']),
      otherUser: SafeParser.object(json['otherUser'], OtherUser.fromJson),
      isBlocked: SafeParser.boolVal(json['isBlocked']),
      lastMessage: SafeParser.str(json['lastMessage']),
      time: SafeParser.date(json['time']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'otherUser': otherUser?.toJson(),
    'isBlocked': isBlocked,
    'lastMessage': lastMessage,
    'time': time?.toIso8601String(),
  };

  ChatListItemModel copyWith({
    String? id,
    OtherUser? otherUser,
    bool? isBlocked,
    String? lastMessage,
    DateTime? time,
  }) {
    return ChatListItemModel(
      id: id ?? this.id,
      otherUser: otherUser ?? this.otherUser,
      isBlocked: isBlocked ?? this.isBlocked,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
    );
  }
}

class OtherUser {
  const OtherUser({this.id = '', this.name = '', this.profileImage = ''});

  final String id;
  final String name;
  final String profileImage;

  factory OtherUser.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const OtherUser();
    }

    return OtherUser(
      id: SafeParser.id(json['_id']),
      name: SafeParser.str(json['name']),
      profileImage: SafeParser.str(json['profileImage']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'profileImage': profileImage,
  };

  OtherUser copyWith({String? id, String? name, String? profileImage}) {
    return OtherUser(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
