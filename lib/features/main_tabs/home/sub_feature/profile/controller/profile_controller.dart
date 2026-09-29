import '../../../../../../../app/controller_export.dart';
import '../../../../../../../core/services/auth/signout_service.dart';
import '../../../../../../../core/services/profile/profile_info_service.dart';
import '../../../../../../core/constants/icon_and_image_paths.dart';
import '../model/profile_model.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();
  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  // User model
  final userProfileData = Rxn<ProfileDataModel>();

  String get myImageUrl => userProfileData.value?.profileImage ?? '';

  @override
  void onInit() async {
    super.onInit();
    loadFromStorage(); // Load cached values first
    await fetchMyProfile(); // Then fetch fresh data from API
  }

  /// Load saved profile from storage for initial UI render
  void loadFromStorage() {}

  /// Fetch the latest profile from API
  Future<void> fetchMyProfile() async {
    if (isLoading_.value) return; // Prevent duplicate calls
    isLoading_.value = true;

    try {
      final data = await ProfileInfoService().fetchProfile();

      if (data != null) {
        userProfileData.value =
            data; // <-- triggers HomeSupplierController's ever()

        print("data fetching profile: ${(data)}");

        // Save to local storage
        storage.setUserInfo(
          email: data.email,
          name: data.name,
          phone: data.phone,
          address: data.address,
          imageUrl: data.profileImage,
        );

        storage.setUserId(data.id ?? '');

        // also save the lat long
        if (data.location != null) {
          storage.setUserLongitude(data.location?.coordinates.first ?? 0.0);
          storage.setUserLatitude(data.location?.coordinates.last ?? 0.0);
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading_.value = false;
    }
  }

  // Sign out loading state
  var isSignOutLoading_ = false.obs;

  ///
  /// Sign out the user safely
  Future<void> onTapLogout() async {
    if (isSignOutLoading_.value) return;

    isSignOutLoading_.value = true;

    try {
      SignoutService().signOut();

      await Future.delayed(const Duration(milliseconds: 1500));

      isSignOutLoading_.value = false;
      Get.offAllNamed(RoutePaths.signin);
    } catch (e) {
      print("Logout error: $e");
      isSignOutLoading_.value = false;
    }
  }

  //

  final passwordCtrl = TextEditingController();

  final showPassword = false.obs;

  String get passwordIcon =>
      !showPassword.value ? IconsPath.visibilityOff : IconsPath.visibilityOn;

  bool get isPasswordHidden => !showPassword.value;

  void togglePassword() {
    showPassword.value = !showPassword.value;
  }

  @override
  void onClose() {
    passwordCtrl.dispose();
    super.onClose();
  }

  // Sign out loading state
  var isDeleteAccountLoading_ = false.obs;

  ///

  /// Delete account
  Future<void> onTapDeteteAccount(String password) async {
    if (isDeleteAccountLoading_.value) return;

    isDeleteAccountLoading_.value = true;

    try {
      final success = await SignoutService().deleteAccountFromBackend(
        password: password,
      );

      if (!success) {
        isDeleteAccountLoading_.value = false;
        return;
      }

      await SignoutService().signOut();

      Get.back(); // close dialog

      Get.offAllNamed(RoutePaths.signin);
    } catch (e) {
      print("Delete account error: $e");
    } finally {
      isDeleteAccountLoading_.value = false;
    }
  }
}
