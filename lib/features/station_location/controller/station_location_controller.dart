import '../../../app/controller_export.dart';
import '../../../core/network/helpers/location_helpers.dart';
import '../../../core/services/location/location_service.dart';

class StationLocationController extends GetxController {
  // ─────────────────────────────────────────────
  // State
  // ─────────────────────────────────────────────

  final selectedCity = "".obs;
  final selectedAddress = "".obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final isLoadingLocation = false.obs;

  String get displayLocation =>
      selectedAddress.value.isNotEmpty ? selectedAddress.value : Strings.select;

  bool get hasLocation => latitude.value != 0.0 && longitude.value != 0.0;

  // ─────────────────────────────────────────────
  // City Map
  // ─────────────────────────────────────────────

  final Map<String, Map<String, double>> cityCoordinates = {
    "Lagos": {"lat": 6.5244, "lng": 3.3792},
    "Kano": {"lat": 12.0022, "lng": 8.5919},
    "Ibadan": {"lat": 7.3775, "lng": 3.9470},
    "Abuja": {"lat": 9.0765, "lng": 7.3986},
    "Port Harcourt": {"lat": 4.8156, "lng": 7.0498},
    "Benin City": {"lat": 6.3350, "lng": 5.6258},
    "Maiduguri": {"lat": 11.8333, "lng": 13.1500},
    "Zaria": {"lat": 11.1113, "lng": 7.7228},
    "Abeokuta": {"lat": 7.1510, "lng": 3.3452},
    "Jos": {"lat": 9.8965, "lng": 8.8583},
    "Ilorin": {"lat": 8.5000, "lng": 4.5500},
    "Oyo": {"lat": 7.8500, "lng": 3.9333},
    "Enugu": {"lat": 6.4550, "lng": 7.5486},
    "Owerri": {"lat": 5.4850, "lng": 7.0350},
    "Calabar": {"lat": 4.9500, "lng": 8.3200},
    "Uyo": {"lat": 5.0333, "lng": 7.9167},
    "Bauchi": {"lat": 10.3100, "lng": 9.8400},
    "Kaduna": {"lat": 10.5100, "lng": 7.4400},
    "Akure": {"lat": 7.2500, "lng": 5.2000},
    "Makurdi": {"lat": 7.7333, "lng": 8.5333},
    "Sokoto": {"lat": 13.0627, "lng": 5.2435},
    "Warri": {"lat": 5.5167, "lng": 5.7500},
    "Onitsha": {"lat": 6.1667, "lng": 6.7833},
    "Ado Ekiti": {"lat": 7.6231, "lng": 5.2200},
    "Ilesa": {"lat": 7.6248, "lng": 4.7451},
    "Minna": {"lat": 9.6139, "lng": 6.5564},
    "Lokoja": {"lat": 7.8000, "lng": 6.7333},
    "Umuahia": {"lat": 5.5239, "lng": 7.4869},
    "Akwanga": {"lat": 8.9333, "lng": 8.5333},
    "Gombe": {"lat": 10.2898, "lng": 11.1675},
  };

  List<String> get cities => cityCoordinates.keys.toList();

  // ─────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocation();
  }

  void _loadSavedLocation() {
    final address = storage.getUserAddress;
    final lat = storage.getUserLatitude;
    final lng = storage.getUserLongitude;

    if (address.isNotEmpty) selectedAddress.value = address;
    if (lat != null && lat != 0.0) latitude.value = lat;
    if (lng != null && lng != 0.0) longitude.value = lng;
  }

  // ─────────────────────────────────────────────
  // Public Actions
  // ─────────────────────────────────────────────

  /// Gets current GPS location and syncs to backend silently.
  Future<void> getAndSaveInBackendCurrLoc() async {
    if (isLoadingLocation.value) return;
    isLoadingLocation.value = true;

    try {
      final location = await LocationHelper.getCurrentLocation();
      if (location == null)
        return; // GPS off or denied — overlay handles UI feedback

      latitude.value = location.latitude;
      longitude.value = location.longitude;
      selectedAddress.value = location.address;
      selectedCity.value = location.city ?? '';

      await _saveLocationToBackend();
    } catch (e) {
      print("❌ getAndSaveInBackendCurrLoc error: $e");
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// Manually selects a city and syncs to backend.
  Future<void> selectCity(String city) async {
    if (isLoadingLocation.value) return;
    isLoadingLocation.value = true;

    try {
      final coords = cityCoordinates[city];
      if (coords == null) return;

      selectedCity.value = city;
      selectedAddress.value = city;
      latitude.value = coords['lat']!;
      longitude.value = coords['lng']!;

      await _saveLocationToBackend();
    } catch (e) {
      print("❌ selectCity error: $e");
    } finally {
      isLoadingLocation.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // Private
  // ─────────────────────────────────────────────

  Future<void> _saveLocationToBackend() async {
    try {
      final success = await Get.find<LocationService>().updateLocation(
        address: selectedAddress.value,
        latitude: latitude.value,
        longitude: longitude.value,
        city: selectedCity.value.isNotEmpty ? selectedCity.value : null,
      );

      if (!success) throw Exception("API returned failure");

      storage.setUserAddress(selectedAddress.value);
      if (selectedCity.value.isNotEmpty)
        storage.setUserCity(selectedCity.value);

      print("✅ Location saved to backend");
    } catch (e) {
      print("❌ _saveLocationToBackend error: $e");
      // Silent fail — overlay is the only user-facing feedback for location state
    }
  }
}
