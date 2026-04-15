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
  final bool isEdit;

  CreateCommunityArgModel({
    required this.communityImg,
    required this.communityName,
    required this.isEdit,
  });
}

class CommonTitleIconpathModel {
  final String title;
  final String? subtitle;
  final String iconPath;

  CommonTitleIconpathModel({required this.title, required this.iconPath, this.subtitle});
}
