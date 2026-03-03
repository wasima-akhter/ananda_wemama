import 'package:geocoding/geocoding.dart';
import 'package:mama_app/core/config/app_info.dart';

import '../../app/helper_widgets_export.dart';
import '../common_widgets/custom_divider.dart';

T findCont<T extends GetxController>() {
  return Get.find<T>();
}

TextStyle get componentTxtStyle => TxtStyle.inter(fs: 12, w: 600);
TextStyle amountTxtStyle({Color? clr}) =>
    TxtStyle.interSemiB(fs: 14, w: 600, color: clr ?? c.textSecondary);

List<BoxShadow> boxShadow({bool? isLess}) => [
  BoxShadow(
    color: grey200.withOpacity(isLess == true ? 0.1 : 0.5), // light grey
    blurRadius: isLess == true ? 6 : 12,
    offset: isLess == true ? Offset(2, 2) : Offset(6, 6), // right (x) and bottom (y)
  ),
];
List<BoxShadow> get boxShadowAllSides => [
  BoxShadow(
    color: Colors.black.withOpacity(0.05), // #0000000D
    offset: const Offset(1, 1), // x:1, y:1
    blurRadius: 10, // blur
    spreadRadius: 0, // same as Figma
  ),
];

List<BoxShadow> get boxShadowTopOnly => [
  BoxShadow(
    color: Colors.black.withOpacity(0.1), // intensity: 10%
    offset: const Offset(0, -3), // negative y moves shadow upward
    blurRadius: 6, // smoothness
    spreadRadius: 0, // no extra spread
  ),
];

List<BoxShadow> boxShadowBottom({Color? color}) => [
  BoxShadow(
    color: color ?? c.secondary.withOpacity(0.25), // use your secondary color
    offset: const Offset(0, 3), // positive y moves shadow downward
    blurRadius: 2, // no blur
    spreadRadius: 0, // no extra spread
  ),
];
List<BoxShadow> boxShadowAllSide({double? shadowIntensity}) => [
  BoxShadow(
    color: Colors.black.withOpacity(shadowIntensity ?? 0.1), // #0000000D
    offset: const Offset(1, 1), // x:1, y:1
    blurRadius: 10, // blur
    spreadRadius: 0, // same as Figma
  ),

  //         offset: Offset(x, y)

  // x > 0 → shadow goes to the right

  // y > 0 → shadow goes to the bottom

  // blurRadius: 6 → softness of the shadow edges

  // Lower opacity = softer/lighter shadow
];

CustomBtnWTxt filledBtnWTxt({
  Color? btnColor,
  void Function()? onTap,
  required String btnTxt,
  required bool isLoading,
}) => CustomBtnWTxt(onTap: onTap, isSmall: true, btnTxt: btnTxt, isLoading: isLoading);

// open gallery

int roleId = 1; // 1 = user, 2= supplier

String makeImageUrl({required String imageUrl}) {
  if (imageUrl.contains("http")) {
    return imageUrl;
  } else {
    return "${baseUrl}/$imageUrl";
  }
}

Future<bool> willPopFunction({required DateTime? currentBackPressTime}) async {
  final now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
    currentBackPressTime = now;
    // showToast("Press again to exit");
    return false;
  }

  return true; // let system handle exit
}

String getFullAddress({
  String? location,
  String? latitude,
  String? longitude,
  String placeholder = "N/A",
}) {
  // Trim and check if each value is valid
  final loc = (location ?? "").trim();
  final lat = (latitude ?? "").trim();
  final lng = (longitude ?? "").trim();

  // If all are empty, return placeholder
  if (loc.isEmpty && lat.isEmpty && lng.isEmpty) {
    return placeholder;
  }

  // Build address string safely
  final parts = <String>[];
  if (loc.isNotEmpty) parts.add(loc);
  if (lat.isNotEmpty && lng.isNotEmpty) {
    parts.add("Lat: $lat, Lng: $lng");
  } else if (lat.isNotEmpty) {
    parts.add("Lat: $lat");
  } else if (lng.isNotEmpty) {
    parts.add("Lng: $lng");
  }

  return parts.join(" • "); // Using • as separator, can change to comma
}

/// Returns a 2-line address safely
/// line1 = house name / number (location)
/// line2 = lat/lng info or placeholder

/// Returns a 2-line address safely
/// line1 = house name / number (location)
/// line2 = street, locality, city, country (reverse geocoded)
Future<List<String>> getTwoLineAddress({
  String? location,
  String? latitude,
  String? longitude,
  String placeholder = "N/A",
}) async {
  final loc = (location ?? "").trim();
  final line1 = loc.isNotEmpty ? loc : placeholder;

  String line2 = placeholder;

  print("getTwoLineAddress called with lat=$latitude, lng=$longitude");

  // Only attempt reverse geocoding if lat/lng are valid numbers
  if (latitude != null && longitude != null && latitude.isNotEmpty && longitude.isNotEmpty) {
    try {
      final lat = double.tryParse(latitude);
      final lng = double.tryParse(longitude);

      if (lat != null && lng != null) {
        final placemarks = await placemarkFromCoordinates(lat, lng);
        print("placemarks with ${placemarks.toString()}");

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          // Build readable address
          final parts = [p.street, p.subLocality, p.locality, p.administrativeArea, p.country];
          line2 = parts.where((e) => e != null && e.isNotEmpty).join(", ").capEachWord();
        }
      }
    } catch (e) {
      // ignore errors and fallback to placeholder
      line2 = placeholder;
    }
  }

  return [line1, line2];
}

String makeCurrencyValue(String value) {
  return "${Strings.currency} $value";
}

bool isRate(String name) {
  return name.toLowerCase().contains(Strings.rate.toLowerCase());
}

CustomDivider get greyDividerFull => CustomDivider(clr: grey200, isFullWidth: true, h: 0.6);

String getTypeOfFilterTime(String criteria) {
  switch (criteria) {
    case Strings.thisWeek:
      return "this-week";
    case Strings.thisMonth:
      return "this-month";
    case Strings.thisYear:
      return "this-year";
  }
  return "this-week";
}

String get generateChannel => DateTime.now().millisecondsSinceEpoch.toString();
