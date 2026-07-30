import 'package:flutter/foundation.dart';
import 'package:flutter_new_badger/flutter_new_badger.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppStorage extends GetxService {
  // ---------------------------  Keys  ---------------------------
  static const _isLoggedInKey = 'isLoggedIn';
  static const _rememberMeKey = 'rememberMe';
  static const _seenOnboardingKey = 'seenOnboarding';

  // User info keys
  static const _userNameKey = 'userName';
  static const _userEmailKey = 'userEmail';
  static const _userPhoneKey = 'userPhone';
  static const _userRoleKey = 'userRole';

  // User Bank info keys
  static const _bankNameKey = 'bankName';
  static const _accountNameKey = 'accountName';
  static const _accountNumberKey = 'accountNumber';

  // Token / identifiers
  static const _accessTokenKey = 'accessToken';

  static const _imageUrlKey = 'imageUrl';

  static const _userTypeKey = 'userType';

  static const _notifUnreadCountKey = 'notifUnreadCount';
  static const _notifNewCountKey = 'notifNewCount';

  // Theme key
  static const _themeKey = 'theme'; // 'light' or 'dark'

  // Match search count keys
  static const _matchSearchCountKey = 'matchSearchCount';
  static const _matchSearchDateKey = 'matchSearchDate';

  // ---------------------------  MATCH SEARCH COUNT  ---------------------------
  void setMatchSearchCount({required int count, required String date}) {
    _storage.write(_matchSearchCountKey, count);
    _storage.write(_matchSearchDateKey, date);
  }

  int get getMatchSearchCount => _storage.read(_matchSearchCountKey) ?? 0;
  String get getMatchSearchDate => _storage.read(_matchSearchDateKey) ?? '';

  // ---------------------------  Reactive Values  ---------------------------
  RxBool isLoggedIn = false.obs;
  RxBool rememberMe = true.obs;
  RxBool seenOnboarding = false.obs;

  // ✅ NEW — notification counts
  RxInt unreadNotifCount = 0.obs;
  RxInt newNotifCount = 0.obs;

  late final GetStorage _storage;

  // ---------------------------  Singleton Access  ---------------------------
  static AppStorage get to => Get.find<AppStorage>();

  // ---------------------------  Private constructor  ---------------------------
  AppStorage._();

  // ---------------------------  Init  ---------------------------
  static Future<AppStorage> init() async {
    final service = AppStorage._();
    await GetStorage.init(); // Initialize storage
    service._storage = GetStorage();

    // Initialize reactive values
    service.isLoggedIn.value = service._storage.read(_isLoggedInKey) ?? false;
    service.rememberMe.value = service._storage.read(_rememberMeKey) ?? true;
    service.seenOnboarding.value =
        service._storage.read(_seenOnboardingKey) ?? false;

    // ✅ NEW — restore notification counts
    service.unreadNotifCount.value =
        service._storage.read(_notifUnreadCountKey) ?? 0;
    service.newNotifCount.value = service._storage.read(_notifNewCountKey) ?? 0;

    return service;
  }

  // ---------------------------  USER INFO  ---------------------------
  void setUserInfo({
    String? name,
    String? email,
    String? phone,
    String? role,
    String? imageUrl,
    String? address,
  }) {
    if (name != null) _storage.write(_userNameKey, name);
    if (email != null) _storage.write(_userEmailKey, email);
    if (phone != null) _storage.write(_userPhoneKey, phone);
    if (role != null) _storage.write(_userRoleKey, role);
    if (imageUrl != null) _storage.write(_imageUrlKey, imageUrl);
    if (address != null) _storage.write(_keyUserAddress, address);
  }

  UserInfoModel get getUserInfo => UserInfoModel(
    name: _storage.read(_userNameKey) ?? '',
    email: _storage.read(_userEmailKey) ?? '',
    phone: _storage.read(_userPhoneKey) ?? '',
    role: _storage.read(_userRoleKey) ?? '',
    imageUrl: _storage.read(_imageUrlKey) ?? '',
    address: _storage.read(_keyUserAddress) ?? '',
  );

  void setUserBankDetails({
    String? bankName,
    String? accountName,
    String? accountNumber,
  }) {
    if (bankName != null) _storage.write(_bankNameKey, bankName);
    if (accountName != null) _storage.write(_accountNameKey, accountName);
    if (accountNumber != null) _storage.write(_accountNumberKey, accountNumber);
  }

  // BankDetailsDataModel get getUserBankInfo => BankDetailsDataModel(
  //   bankName: _storage.read(_bankNameKey) ?? '',
  //   accountName: _storage.read(_accountNameKey) ?? '',
  //   accountNumber: _storage.read(_accountNumberKey) ?? '',
  // );
  // ---------------------------  ACCESS TOKEN  ---------------------------

  // ---------------------------  AUTH STATE  ---------------------------
  void setRememberMe(bool value) {
    _storage.write(_rememberMeKey, value);
    rememberMe.value = value;
  }

  bool get getRememberMe => _storage.read(_rememberMeKey) ?? true;

  void setLoggedIn(bool value) {
    _storage.write(_isLoggedInKey, value);
    isLoggedIn.value = value;
  }

  bool get getLoggedIn => _storage.read(_isLoggedInKey) ?? false;

  void setSeenOnboarding(bool value) {
    _storage.write(_seenOnboardingKey, value);
    seenOnboarding.value = value;
  }

  bool get getSeenOnboarding => _storage.read(_seenOnboardingKey) ?? false;

  // ---------------------------  TOKEN / IDENTIFIERS  ---------------------------
  void setToken(String token) => _storage.write(_accessTokenKey, token);
  String get getToken => _storage.read(_accessTokenKey) ?? '';

  void setUserPhone(String userPhone) =>
      _storage.write(_userPhoneKey, userPhone);
  String get getUserPhone => _storage.read(_userPhoneKey) ?? '';

  void setUserEmail(String userEmail) =>
      _storage.write(_userEmailKey, userEmail);
  String get getUserEmail => _storage.read(_userEmailKey) ?? '';

  ///---------------map address of user ----------------//

  // Address keys
  static const String _keyUserAddress = 'user_address';
  static const String _keyUserLatitude = 'user_latitude';
  static const String _keyUserLongitude = 'user_longitude';
  static const String _keyUserCity = 'user_city';

  // Save address

  void setUserAddress(String userAddress) =>
      _storage.write(_keyUserAddress, userAddress);

  void setUserLatitude(double latitude) =>
      _storage.write(_keyUserLatitude, latitude);

  void setUserLongitude(double longitude) =>
      _storage.write(_keyUserLongitude, longitude);

  void setUserCity(String city) => _storage.write(_keyUserCity, city);

  // Get address
  String get getUserAddress => _storage.read(_keyUserAddress) ?? '';

  double? get getUserLatitude => _storage.read(_keyUserLatitude);

  double? get getUserLongitude => _storage.read(_keyUserLongitude);

  String get getUserCity => _storage.read(_keyUserCity) ?? '';

  // Clear address
  void clearUserAddress() {
    _storage.remove(_keyUserAddress);
    _storage.remove(_keyUserLatitude);
    _storage.remove(_keyUserLongitude);
    _storage.remove(_keyUserCity);
  }

  // Check if address is saved
  bool get hasUserAddress {
    final lat = getUserLatitude;
    final lng = getUserLongitude;
    return lat != null && lng != null && lat != 0.0 && lng != 0.0;
  }

  // Get address as Map for API calls
  UserAddressDataModel get getUserAddressData => UserAddressDataModel(
    address: getUserAddress,
    latitude: getUserLatitude,
    longitude: getUserLongitude,
    city: getUserCity,
  );

  ////

  void setUserImageUrl(String userImageUrl) =>
      _storage.write(_imageUrlKey, userImageUrl);
  String get getUserImageUrl => _storage.read(_imageUrlKey) ?? '';

  static const _userIdKey = 'userId';

  void setUserId(String id) => _storage.write(_userIdKey, id);
  String get getUserId => _storage.read(_userIdKey) ?? '';

  // ---------------------------  USER TYPE  ---------------------------
  void saveUserType(int type) => _storage.write(_userTypeKey, type);
  int? get getUserType => _storage.read(_userTypeKey);

  void setUsername(String username) => _storage.write(_userNameKey, username);
  String get getUsername => _storage.read(_userNameKey) ?? '';

  // ---------------------------  location_popup_seen  ---------------------------

  //
  static const _hasLoggedInBeforeKey = "has_logged_in_before";

  void setHasLoggedInBefore() {
    final userId = getUserId;

    if (userId.isEmpty) return;

    _storage.write('${_hasLoggedInBeforeKey}_$userId', true);
  }

  bool get hasLoggedInBefore {
    final userId = getUserId;

    if (userId.isEmpty) return false;

    return _storage.read('${_hasLoggedInBeforeKey}_$userId') ?? false;
  }

  // ---------------------------  THEME  ---------------------------
  void setTheme(bool isDark) =>
      _storage.write(_themeKey, isDark ? 'dark' : 'light');
  bool get getIsDarkMode {
    final theme = _storage.read(_themeKey);
    if (theme == 'dark') return true;
    if (theme == 'light') return false;
    return false; // default to light if not set
  }

  //
  // ---------------------------  NOTIFICATION COUNTS  ---------------------------

  /// Call from any FCM handler (foreground / background tap / cold start)
  // ---------------------------  NOTIFICATION COUNTS  ---------------------------

  void setNotificationCounts({required int unread, required int newCount}) {
    _storage.write(_notifUnreadCountKey, unread);
    _storage.write(_notifNewCountKey, newCount);
    unreadNotifCount.value = unread;
    newNotifCount.value = newCount;
    _syncAppBadge(unread);
  }

  void clearNewNotifCount() {
    _storage.write(_notifNewCountKey, 0);
    newNotifCount.value = 0;
  }

  void setUnreadNotifCount(int unread) {
    _storage.write(_notifUnreadCountKey, unread);
    unreadNotifCount.value = unread;
    _syncAppBadge(unread);
  }

  int get getUnreadNotifCount => _storage.read(_notifUnreadCountKey) ?? 0;
  int get getNewNotifCount => _storage.read(_notifNewCountKey) ?? 0;

  void _syncAppBadge(int unread) {
    try {
      if (unread > 0) {
        FlutterNewBadger.setBadge(unread);
      } else {
        FlutterNewBadger.removeBadge();
      }
    } catch (e) {
      // FlutterNewBadger can throw on unsupported platforms/launchers — ignore safely
      debugPrint('⚠️ [AppStorage] badge sync failed: $e');
    }
  }

  //

  static const String _hasCheckedInKey = "has_checked_in";
  void setHasCheckedIn(bool value) {
    _storage.write(_hasCheckedInKey, value);
  }

  bool get hasCheckedIn => _storage.read(_hasCheckedInKey) ?? false;

  void clearCheckInStatus() {
    _storage.remove(_hasCheckedInKey);
  }

  // --------------------------- PUSH NOTIFICATION Settings ---------------------------

  static const _pushNotificationKey = 'pushNotification';

  RxBool pushNotification = true.obs;

  void setPushNotification(bool value) {
    _storage.write(_pushNotificationKey, value);

    pushNotification.value = value;
  }

  bool get getPushNotification => _storage.read(_pushNotificationKey) ?? true;

  //

  // ---------------------------  CLEAR / LOGOUT  ---------------------------
  void logout() {
    _storage.erase();

    // Restore things you DON'T want to lose

    final userId = getUserId;
    if (userId.isNotEmpty) {
      _storage.write('${_hasLoggedInBeforeKey}_$userId', hasLoggedInBefore);
    }

    _storage.write(_seenOnboardingKey, true);

    isLoggedIn.value = false;
    rememberMe.value = true;

    // IMPORTANT: onboarding should stay TRUE after first time
    seenOnboarding.value = true;

    // ✅ NEW — reset notification counts on logout
    unreadNotifCount.value = 0;
    newNotifCount.value = 0;
  }
}

class UserInfoModel {
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? imageUrl;
  final String? address;

  UserInfoModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.imageUrl,
    this.address,
  });
}

class UserAddressDataModel {
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? city;

  UserAddressDataModel({
    this.address,
    this.latitude,
    this.longitude,
    this.city,
  });
}
