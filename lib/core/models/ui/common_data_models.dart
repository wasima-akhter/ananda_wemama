import '../../enums/ui_enums.dart';

class IdentityCardDataModel {
  final String title;
  final String phone;
  final String email;
  final String? address;
  final String? imageUrl;
  final String? avgRating;
  final String? totalRating;

  IdentityCardDataModel({
    required this.title,
    required this.phone,
    required this.email,
    this.avgRating,
    this.totalRating,
    this.imageUrl,
    this.address,
  });
}

class CreateCommunityArgModel {
  final String communityImg;
  final String communityName;
  final String? communityId;
  final bool isEdit;

  CreateCommunityArgModel({
    required this.communityImg,
    required this.communityName,
    required this.isEdit,
    this.communityId,
  });
}

class PostDetailArgModel {
  final String communityId;
  final String postId;

  const PostDetailArgModel({required this.communityId, required this.postId});
}

class CommonTitleIconpathModel {
  final String title;
  final String? subtitle;
  final String iconPath;

  CommonTitleIconpathModel({
    required this.title,
    required this.iconPath,
    this.subtitle,
  });
}

class ChatInboxArgPassModel {
  final String chatId;
  final bool isBlocked;
  final bool autoHello; // ← add this

  ChatInboxArgPassModel({
    required this.chatId,
    required this.isBlocked,
    this.autoHello = false,
  });
}

class MoodInsightArgs {
  final MoodType moodType;
  final String itemId;
  final bool fromHome; // ✅ if true → back button goes to moodLibrary

  const MoodInsightArgs({
    required this.moodType,
    required this.itemId,
    this.fromHome = false,
  });
}
