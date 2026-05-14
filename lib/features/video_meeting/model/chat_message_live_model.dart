import '../../../core/constants/icon_and_image_paths.dart';

class ChatMessageLiveModel {
  final String text;
  final String senderId;
  final String senderName; // ← add
  final String senderAvatar; // ← add
  final bool isMe;
  final DateTime timestamp;

  ChatMessageLiveModel({
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.isMe,
    required this.timestamp,
  });
}

class RaiseHandModel {
  final String? uid;
  final String? name;
  final String? avatar; // ← add

  RaiseHandModel({
    this.uid,
    this.name,
    this.avatar, // ← add
  });
}

class ParticipantModel {
  final String? uid;
  final String? name;
  final String? avatar;
  final bool? isMuted;

  ParticipantModel({this.uid, this.name, this.avatar, this.isMuted});

  ParticipantModel copyWith({bool? isMuted}) {
    return ParticipantModel(uid: uid, name: name, avatar: avatar, isMuted: isMuted ?? this.isMuted);
  }
}

class JoinerModel {
  final String? uid;
  final String? name;
  final String? avatar;
  JoinerModel({this.uid, this.name, this.avatar});
}

final reactionList = [
  (ImagesPath.likeEmoji, 'LIKE'),
  (ImagesPath.heartEmoji, 'HEART'),
  (ImagesPath.careEmoji, 'CARE'),
  (ImagesPath.hahaEmoji, 'HAHA'),
  (ImagesPath.wowEmoji, 'WOW'),
  (ImagesPath.sadEmoji, 'SAD'),
  (ImagesPath.angryEmoji, 'ANGRY'),
];
