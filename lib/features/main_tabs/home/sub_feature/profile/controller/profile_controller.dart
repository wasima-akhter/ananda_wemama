import '../../../../../../../app/controller_export.dart';
import '../../../../../../../core/services/auth/signout_service.dart';
import '../../../../../../../core/services/profile/profile_info_service.dart';
import '../model/profile_model.dart';

class ProfileController extends GetxController {
  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  // User model
  final userProfileData = Rxn<ProfileDataModel>();

  // Sign out loading state
  var isSignOutLoading_ = false.obs;

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
        userProfileData.value = data; // <-- triggers HomeSupplierController's ever()

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
          storage.setUserLongitude(data.location?.coordinates?.first ?? 0.0);
          storage.setUserLatitude(data.location?.coordinates?.last ?? 0.0);
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading_.value = false;
    }
  }

  ///
  /// Sign out the user safely
  Future<void> onTapLogout() async {
    if (isSignOutLoading_.value) return;

    isSignOutLoading_.value = true;

    try {
      SignoutService().signOut();

      await Future.delayed(const Duration(milliseconds: 1500));

      isSignOutLoading_.value = false;
      GNav.pushNamedReplace(RoutePaths.signin);
    } catch (e) {
      print("Logout error: $e");
      isSignOutLoading_.value = false;
    }
  }
}
