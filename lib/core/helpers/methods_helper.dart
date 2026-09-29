import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:we_mama/core/config/app_info.dart';

import '../../app/helper_widgets_export.dart';
import '../../features/main_nav/controller/main_nav_controller.dart';
import '../../features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../components/ui/helpers/shapes/custom_divider.dart';

T findCont<T extends GetxController>() {
  return Get.find<T>();
}

String currentProfileId() {
  if (Get.isRegistered<ProfileController>()) {
    return Get.find<ProfileController>().userProfileData.value?.id ?? '';
  } else {
    return '';
  }
}

String currentProfileName() {
  if (Get.isRegistered<ProfileController>()) {
    return Get.find<ProfileController>().userProfileData.value?.name ?? '';
  } else {
    return '';
  }
}

String currentUserImage() {
  if (Get.isRegistered<ProfileController>()) {
    return Get.find<ProfileController>().userProfileData.value?.profileImage ??
        '';
  } else {
    return '';
  }
}

UIState getUIStateList({required bool isLoading, required List list}) {
  if (isLoading) return UIState.loading;
  if (list.isEmpty) return UIState.empty;
  return UIState.data;
}

UIState getUIStateDetail({required bool isLoading}) {
  if (isLoading) return UIState.loading;
  return UIState.data;
}

TextStyle get componentTxtStyle => TxtStyle.inter(fs: 12, w: 600);
TextStyle amountTxtStyle({Color? clr}) =>
    TxtStyle.interSemiB(fs: 14, w: 600, color: clr ?? c.textSecondary);

List<BoxShadow> boxShadow({bool? isLess}) => [
  BoxShadow(
    color: grey200.withOpacity(isLess == true ? 0.1 : 0.5), // light grey
    blurRadius: isLess == true ? 6 : 12,
    offset: isLess == true
        ? Offset(2, 2)
        : Offset(6, 6), // right (x) and bottom (y)
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

List<BoxShadow> boxShadowBottom({Color? color, double? blur}) => [
  BoxShadow(
    color:
        color ?? c.secondary.withValues(alpha: 0.3), // use your secondary color
    offset: const Offset(0, 3), // positive y moves shadow downward
    blurRadius: blur ?? 2, // no blur
    spreadRadius: 0, // no extra spread
  ),
];

List<BoxShadow> boxShadowBottomRight({Color? color}) => [
  BoxShadow(
    color: color ?? c.secondary.withOpacity(0.25),
    offset: const Offset(1, 1), // right (x) and bottom (y)
    blurRadius: 1,
    spreadRadius: 0,
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
}) => CustomBtnWTxt(
  onTap: onTap,
  isSmall: true,
  btnTxt: btnTxt,
  isLoading: isLoading,
);

// open gallery

int roleId = 1; // 1 = user, 2= supplier
String makeImageUrl({required String imageUrl}) {
  final path = imageUrl.trim();

  if (path.isEmpty) {
    return '';
  }

  if (path.startsWith('http://') || path.startsWith('https://')) {
    return path;
  }

  return '$baseUrl/$path';
}

Future<bool> willPopFunction({required DateTime? currentBackPressTime}) async {
  final now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
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
  if (latitude != null &&
      longitude != null &&
      latitude.isNotEmpty &&
      longitude.isNotEmpty) {
    try {
      final lat = double.tryParse(latitude);
      final lng = double.tryParse(longitude);

      if (lat != null && lng != null) {
        final placemarks = await placemarkFromCoordinates(lat, lng);
        print("placemarks with ${placemarks.toString()}");

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          // Build readable address
          final parts = [
            p.street,
            p.subLocality,
            p.locality,
            p.administrativeArea,
            p.country,
          ];
          line2 = parts
              .where((e) => e != null && e.isNotEmpty)
              .join(", ")
              .capEachWord();
        }
      }
    } catch (e) {
      // ignore errors and fallback to placeholder
      line2 = placeholder;
    }
  }

  return [line1, line2];
}

Future<String> getOneLineAddress({
  required String latitude,
  required String longitude,
  String placeholder = "N/A",
}) async {
  print("getOneLineAddress called with lat=$latitude, lng=$longitude");

  try {
    final lat = double.tryParse(latitude);
    final lng = double.tryParse(longitude);

    if (lat != null && lng != null) {
      final placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        final parts = [
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
          p.country,
        ];

        return parts
            .where((e) => e != null && e.isNotEmpty)
            .join(", ")
            .capEachWord();
      }
    }
  } catch (e) {
    print("Reverse geocoding error: $e");
  }

  return placeholder;
}

///////////////////////

String makeCurrencyValue(String value) {
  return "${Strings.currency} $value";
}

CustomDivider get greyDividerFull =>
    CustomDivider(clr: grey200, isFullWidth: true, h: 0.6);

String get generateChannel => DateTime.now().millisecondsSinceEpoch.toString();

void goToMainNavWithTab(int tabIndex) {
  Get.toNamed(RoutePaths.mainNav);

  Get.find<MainNavController>().goToTab(tabIndex);
}

//

Future<void> downloadFile(
  String url,
  void Function(double progress)? onProgress,
) async {
  try {
    print("⬇️ Original URL: $url");

    final headResponse = await Dio().head(url);
    final contentType = headResponse.headers.value('content-type') ?? '';

    String fileName = p.basename(url.split('?').first);

    if (fileName.isEmpty || !fileName.contains('.')) {
      if (contentType.contains('pdf')) {
        fileName = 'document.pdf';
      } else if (contentType.contains('image/jpeg')) {
        fileName = 'image.jpg';
      } else if (contentType.contains('image/png')) {
        fileName = 'image.png';
      } else if (contentType.contains('video')) {
        fileName = 'video.mp4';
      } else {
        fileName = 'file';
      }
    }

    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/$fileName';

    await Dio().download(
      url,
      tempPath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = received / total;
          onProgress?.call(progress);

          print("📥 Progress: ${(progress * 100).toStringAsFixed(0)}%");
        }
      },
    );

    final lower = fileName.toLowerCase();

    if (lower.endsWith(".jpg") ||
        lower.endsWith(".jpeg") ||
        lower.endsWith(".png") ||
        lower.endsWith(".webp") ||
        lower.endsWith(".gif")) {
      await Gal.putImage(tempPath);
      Snack.showSuccess("Image saved to gallery");
    } else if (lower.endsWith(".mp4") || lower.endsWith(".mov")) {
      await Gal.putVideo(tempPath);
      Snack.showSuccess("Video saved to gallery");
    } else {
      await _saveToDownloads(tempPath: tempPath, fileName: fileName);
    }

    final tempFile = File(tempPath);
    if (await tempFile.exists()) await tempFile.delete();
  } catch (e) {
    print("❌ Download error: $e");
    "Download failed".showToast();
  }
}

Future<void> _saveToDownloads({
  required String tempPath,
  required String fileName,
}) async {
  try {
    /// App-specific external storage
    final dir = await getExternalStorageDirectory();

    if (dir == null) {
      throw Exception("Storage directory unavailable");
    }

    final downloadDir = Directory('${dir.path}/Downloads');

    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    final savePath = '${downloadDir.path}/$fileName';

    final savedFile = await File(tempPath).copy(savePath);

    print("✅ File saved at: ${savedFile.path}");

    Snack.showSuccess("File saved successfully");
  } catch (e) {
    print("❌ Save error: $e");
    "Failed to save file".showToast();
  }
}

void closeAllSnackbar() {
  // Close snackbar queue
  Get.closeAllSnackbars();

  // Close any open dialog (safe guard)
  // if (Get.isDialogOpen ?? false) {
  //   Get.back();
  // }
}

List<Widget> buildSeparatedItems({
  required int itemCount,
  required Widget Function(int index) itemBuilder,
  required Widget separator,
}) {
  final widgets = <Widget>[];

  for (int i = 0; i < itemCount; i++) {
    widgets.add(itemBuilder(i));

    if (i != itemCount - 1) {
      widgets.add(separator);
    }
  }

  return widgets;
}
