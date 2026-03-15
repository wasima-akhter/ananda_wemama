import '../../../../../../../app/controller_export.dart';
import '../../../../../../../core/services/auth/signout_service.dart';
import '../../../../../../../core/services/profile/profile_info_service.dart';
import '../model/profile_model.dart';

class ProfileController extends GetxController {
  // Observable fields for UI
  final username = "".obs;
  final phone = "".obs;
  final email = "".obs;
  final avgRating = "".obs;
  final totalRating = "".obs;

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  // User model
  final userProfileData = Rxn<ProfileDataModel>();

  // Sign out loading state
  var isSignOutLoading_ = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFromStorage(); // Load cached values first
    fetchMyProfile(); // Then fetch fresh data from API
  }

  /// Load saved profile from storage for initial UI render
  void loadFromStorage() {
    username.value = storage.getUsername;
    phone.value = storage.getUserPhone;
    email.value = storage.getUserEmail;
    avgRating.value = storage.getUserAvgRating;
    totalRating.value = storage.getUserTotalRating;
  }

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
        );

        // also save the lat long
        if (data.location != null) {
          storage.setUserLongitude(data.location?.coordinates?.first ?? 0.0);
          storage.setUserLatitude(data.location?.coordinates?.last ?? 0.0);
        }

        // Update observables to trigger UI rebuild
        username.value = data.name ?? '';
        phone.value = data.phone ?? '';
        email.value = data.email ?? '';
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
