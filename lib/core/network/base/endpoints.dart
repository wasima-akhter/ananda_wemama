class Endpoints {
  static const login = "auth/login-user";

  static const register = "auth/register-user";
  static const verifyCode = "auth/verify-code";
  static const resendCode = "auth/send-verify-code";

  static const contactSupportSubmit = "settings/submit-help-and-support";
  static const termsAndConditions = "settings/get-terms-and-conditions";
  static const privacyPolicy = "settings/get-privacy-policy";

  static const profileDetail = "profile/get-profile-detail";
  static const updateProfile = "profile/update-profile";
  static const completeProfile = "profile/complete-profile";
  static const changePassword = "profile/change-password";
  static const resetPassword = "auth/reset-password";

  static const addBankDetails = "profile/add-bank-details";

  static const getBankCodes = "paystack/get-bank-list";

  static const notifications = "notification/get-all-notification";

  static String notificationIsSeenUpdate({required String notificationId}) {
    return "notification/make-notification-seen/$notificationId";
  }

  static const supplierDetails = "supplier/supplier-details";

  static const addLocation = "profile/add-location";

  static String getMatch({required String lat, required String long}) {
    return "profile/match-user?latitude=$lat&longitude=$long";
  }

  static String getUserProfile({required String userId}) {
    return "profile/get-friend-profile?profileId=$userId";
  }

  /// Dynamic endpoint for nearest suppliers and price stats
  static String findNearestSuppliersAndPriceStats({
    required double latitude,
    required double longitude,
    int radiusKm = 30, // optional default radius
  }) {
    return "supplier/find-nearest-supplier?latitude=$latitude&longitude=$longitude&radiusKm=$radiusKm";
  }

  /// specific status based customer orderlist
  static String customerAllOrders({required String orderStatus}) {
    final status = orderStatus;
    return "order/customer-all-order?orderStatus=$status";
  }

  static String supplierAllOrders({required String orderStatus}) {
    final status = orderStatus;
    return "order/supplier-all-order?orderStatus=$status";
  }

  static String customerOrderDetails({required String customerOrderId}) {
    return "order/customer-single-order/$customerOrderId";
  }

  static String supplierOrderDetails({required String supplierOrderId}) {
    return "order/supplier-single-order/$supplierOrderId";
  }

  static String cancelOrderDetails({required String customerOrderId}) {
    return "order/cancel-order/$customerOrderId";
  }

  static String supplierOrderAction({
    required String actionEndpoint,
    required String supplierOrderId,
  }) {
    return "order/$actionEndpoint/$supplierOrderId";
  }

  static String customerOrderAction({
    required String actionEndpoint,
    required String customerOrderId,
  }) {
    return "order/$actionEndpoint/$customerOrderId";
  }

  static String customerSpentReport({required String time}) {
    return "inventory/customer-spent-stat?time=$time";
    // inventory/customer-spent-stat?time=this-year
  }

  static String getRevenueHistory({required String time}) {
    return "supplier/get-supplier-revenue?time=$time";
  }

  static String getAllReviews({required String supplierId}) {
    return "review/get-all-review/$supplierId";
  }

  static String createReview = "review/create-new-review";
}
