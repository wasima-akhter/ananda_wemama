class Endpoints {
  static const login = "auth/login-user";

  //
  static const uploadFcmToken = "auth/save-fcm-token";

  //
  static const socialRegister = "auth/register-user-social-account";
  static const socialLogin =
      "auth/login-user-social-account"; // {{local-url}}/auth/login-user-social-account

  static const register = "auth/register-user";
  static const verifyCode = "auth/verify-code";
  static const resendCode = "auth/send-verify-code";

  static const contactSupportSubmit = "settings/submit-contact-us";
  static const termsAndConditions = "settings/get-terms-and-conditions";
  static const privacyPolicy = "settings/get-privacy-policy";

  static const profileDetail = "profile/get-profile-detail";
  static const updateProfile = "profile/update-profile";
  static const completeProfile = "profile/complete-profile";
  static const changePassword = "profile/change-password";
  static const resetPassword = "auth/reset-password";

  static String get notifications => "notification/get-all-notification";
  static String get sendChatFile => "chat/upload-chat-files";
  static String get blockedUsers => "chat/get-blocked-user";
  static String blockUser({required String userId}) {
    return "chat/block-user-app?userId=$userId";
  }

  static String unblockUser({
    required String blockedUserId,
    required String blockeRUserId,
  }) {
    return "chat/unblock-user-app?blockerId=$blockeRUserId&blockedId=$blockedUserId";
  }

  static String get reportUser => "report/new-report";

  static String notificationIsSeenUpdate({required String notificationId}) {
    return "notification/mark-notification-seen/$notificationId";
  }

  // mood library
  static const getAllMood = "mood/get-all-mood";
  static String getAllMoodContents({required String moodId}) {
    return "mood/get-all-mood-content?moodId=$moodId";
  }

  // add location
  static const addLocation = "profile/add-location";

  static String getMatch({required String lat, required String long}) {
    return "profile/match-user?latitude=$lat&longitude=$long";
  }

  static String getExpertSessionList({
    required String sessionStatus,
    required String page,
    required String searchTxt,
  }) {
    return "expert/get-all-session-app?sessionStatus=$sessionStatus&page=$page&searchText=$searchTxt";
  }

  static String getUserProfile({required String userId}) {
    return "profile/get-friend-profile?profileId=$userId";
  }

  /// Dynamic endpoint for nearest suppliers and price stats
  static String joinLiveSessionInfo({required String channelName}) {
    return "agora/join-live?channelName=$channelName";
  }

  static String uploadSessionQuesUrl = "expert/add-new-question";

  // Community
  static String createCommunity = "community/create-community";
  static String updateCommunity = "community/edit-community";
  static String getMyCommunity = "community/get-my-community";
  static String getJoinedCommunity =
      "community/get-joined-community?searchText=";
  static String getSuggestedCommunity = "community/get-community-suggestion";
  static String getSearchedCommunity({required String searchTxt}) =>
      "community/search-community?searchText=$searchTxt";

  static String getCommunityDetail({required String id}) =>
      "community/get-community-detail/$id";
  static String postToggleLike = "post/toggle-like";
  static String pinPost({required String id}) => "post/pin-post/$id";
  static String lockCommentOfPost({required String id}) =>
      "post/lock-comment/$id";
  static String createNewPost = "post/create-new-post";
  static String postAddComment = "post/add-comment";
  static String joinCommunity({required String communityId}) =>
      "community/join-community?communityId=$communityId";
  static String getAllCommentsOfAPost({required String postId}) =>
      "post/get-all-comment/$postId";
  static String deletePost({required String postId}) =>
      "post/delete-post/$postId";

  //
  static String get communitySpotlight => "community/get-community-spotlight";
  static String get gentleReminder => "gentle-reminder/get-today-reminder";
  static String get addTodayMood => "mood/add-today-mood";

  // Chat
  static String getSearchedChatList({required String searchTxt}) =>
      "chat/search-chat?searchText=$searchTxt";

  static String getAllReviews({required String supplierId}) {
    return "review/get-all-review/$supplierId";
  }

  static String createReview = "review/create-new-review";

  //

  // session details by session Id
  static String getSessionDetailById({required String id}) =>
      "expert/get-session-detail/$id";
}
