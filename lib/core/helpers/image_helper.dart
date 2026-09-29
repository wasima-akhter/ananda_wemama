import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:we_mama/core/components/ui/media/safe_asset_image/safe_image_asset.dart';
import 'package:we_mama/gen/assets.gen.dart';

import '../../app/helper_widgets_export.dart' hide MultipartFile;
import '../components/app_ui/popup_widgets/file_size_excedeed_popup.dart';
import '../components/ui/dialogs/popups.dart';
import '../components/ui/media/image_error_builder.dart';
import '../components/ui/sheets/file_picker_bottom_sheet.dart';
import '../components/ui/sheets/image_picker_bottom_sheet.dart';
import 'image/image_compressor.dart';

SafeAssetImage get mamaLogoWithoutTxtImageSmall => SafeAssetImage(
  assetPath: Assets.images.weMamaHandsLogoIos.path,
  height: double.infinity,

  // height: ScreenSize.isSmallWidth ? S.w * 0.2 : S.w * 0.22,
);

ImageErrorBuilder defaultErrorBuilder({double? height, double? width}) =>
    ImageErrorBuilder(height: height, width: width);

//
final Map<String, String> _svgCache = {};
Future<String> svgPathWNewWidth({
  required String iconPath,
  required double strokeWidth,
}) async {
  final cacheKey = '$iconPath-$strokeWidth';

  if (_svgCache.containsKey(cacheKey)) {
    return _svgCache[cacheKey]!;
  }

  String svgStr = await rootBundle.loadString(iconPath);

  String modifiedSvg = svgStr.replaceAll(
    RegExp(r'stroke-width="[^"]+"'),
    'stroke-width="$strokeWidth"',
  );

  _svgCache[cacheKey] = modifiedSvg;

  return modifiedSvg;
}

Column get weMamaLogoWithTxt => Column(
  children: [
    Gap(itemGap * 3),
    SafeAssetImage(assetPath: ImagesPath.weMamaLogo, height: S.w * 0.3),
  ],
);
Column get weMamaLogoWithTitle => Column(
  children: [
    Gap(itemGap * 3),
    SafeAssetImage(
      assetPath: ImagesPath.wemamaHandsTitleLogo,
      // height: S.w * 0.26,
      width: 170.w,
      // height: 120.h,
    ),
  ],
);

CircleAvatar circledImageBgComponent({
  String? imagePath,
  Color? brdrClr,
  double? radius,
}) {
  return CircleAvatar(
    radius: (radius ?? 20).r,
    backgroundColor: c.inputBackground,
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: brdrClr ?? c.secondary),
        image: DecorationImage(
          image: AssetImage(imagePath ?? ImagesPath.userDemoL),
        ),
      ),
    ),
  );
}

Widget circledNetworkImageBgComponent({
  String? imagePath,
  Color? brdrClr,
  double? radius,
  bool? isUser,
  bool? enablePreview,
  String? name,
}) {
  return NetworkImageWidget(
    name: name,
    imageUrl: imagePath,
    isCircle: true,
    radius: radius ?? 20,
    enablePreview: enablePreview ?? true,
    isUser: isUser,
  );
}

Future<dynamic> showPickImageBottomSheet({
  double? heightFactor,
  bool isScrollControlled = true,
  final void Function()? onTapGallery,
  final void Function()? onTapCamera,
}) {
  return Get.bottomSheet(
    ignoreSafeArea: false,
    isDismissible: true,
    enableDrag: true,

    SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.only(bottom: S.bottomInset),

        child: SizedBox(
          height: bSheetH * 0.5 * (heightFactor ?? 1),

          // width: 1.sw,
          child: PickImageBottomSheet(
            onTapGallery: onTapGallery,
            onTapCamera: onTapCamera,
          ),
        ).getBtmSheetM,
      ),
    ),

    isScrollControlled: isScrollControlled,
    backgroundColor: bgClr, // needed for rounded corners
  );
}

Future<dynamic> showPickAnyFileBottomSheet({
  double? heightFactor,
  bool isScrollControlled = true,
  final void Function()? onTapGallery,
  final void Function()? onTapCamera,
  final void Function()? onTapFile,
}) {
  return Get.bottomSheet(
    ignoreSafeArea: false,
    isDismissible: true,
    enableDrag: true,

    AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: S.bottomInset),

      child: SizedBox(
        height: bSheetH * 0.45 * (heightFactor ?? 1),

        // width: 1.sw,
        child: FilePickerBottomSheet(
          onTapFile: onTapFile,
          onTapGallery: onTapGallery,
          onTapCamera: onTapCamera,
        ),
      ).getBtmSheetM,
    ),

    isScrollControlled: isScrollControlled,
    backgroundColor: bgClr, // needed for rounded corners
  );
}

////////////
///
bool isImageFile(XFile file) {
  final path = file.path.toLowerCase();
  return path.endsWith('.jpg') ||
      path.endsWith('.jpeg') ||
      path.endsWith('.png') ||
      path.endsWith('.webp');
}

String getSafeFileName(String url, String contentType) {
  final uri = Uri.parse(url);
  String name = p.basename(uri.path);

  if (!name.contains('.')) {
    if (contentType.contains('jpeg')) {
      name = 'image.jpg';
    } else if (contentType.contains('png')) {
      name = 'image.png';
    } else {
      name = 'image.jpg'; // fallback safest
    }
  }

  // force backend-friendly extension
  if (name.endsWith('.webp') || name.endsWith('.gif')) {
    name = name.replaceAll(RegExp(r'\.(webp|gif)$'), '.jpg');
  }

  return name;
}

String safePathFromUri(String rawPath) {
  return Uri.decodeFull(Uri.decodeFull(rawPath)); // double-decode safety
}

XFile sanitizeXFile(XFile file) {
  final dir = p.dirname(file.path);
  final ext = p.extension(file.path); // e.g. ".jpg"
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final cleanName = 'image_$timestamp$ext'; // e.g. "image_1234567890.jpg"
  final cleanPath = p.join(dir, cleanName);

  // Create a symlink or copy with the clean name
  final original = File(file.path);
  final cleaned = original.copySync(cleanPath);

  return XFile(cleaned.path);
}

// Helper to get correct MediaType from file path
MediaType imageMediaType(String path) {
  final ext = path.split('.').last.toLowerCase();
  switch (ext) {
    case 'png':
      return MediaType('image', 'png');
    case 'jpg':
    case 'jpeg':
    default:
      return MediaType('image', 'jpeg');
  }
}

///
// ------------------------------------
//
// -------------------------------------------

const int maxFileSizeInBytes = 1 * 1024 * 1024; // 3 MB

Future<bool> validateFileSize(dynamic data) async {
  if (data is! dio.FormData) return true;

  for (final field in data.files) {
    final multipartFile = field.value;

    final length = multipartFile.length;

    if (length > maxFileSizeInBytes) {
      await showAnimatedDialog(
        context: Get.context!,
        barrierDismissible: true,
        child: const FileSizeExceededPopup(),
      );

      return false;
    }
  }

  return true;
}

class MultipartHelper {
  // ✅ Images only
  static Future<dio.MultipartFile?> compressedImage(File file) async {
    final compressed = await ImageCompressor.compressUntilUnder1MB(file);
    if (compressed == null) {
      print("Image compression failed");
      return null;
    }
    final bytes = await compressed.readAsBytes();
    print("Compressed path: ${compressed.path}");
    print("Compressed exists: ${await compressed.exists()}");
    print("Compressed size: ${await compressed.length()}");
    final filename = compressed.path.split('/').last;
    return dio.MultipartFile.fromBytes(bytes, filename: filename);
  }

  // ✅ Any file — compresses images, sends others as-is
  static Future<dio.MultipartFile> anyFile(XFile xfile) async {
    final file = File(xfile.path);

    if (isImageFile(xfile)) {
      final compressed = await ImageCompressor.compressUntilUnder1MB(file);
      final target = compressed ?? file;
      final bytes = await target.readAsBytes();
      final filename = target.path.split('/').last;
      print("🖼️ Image compressed: ${bytes.length} bytes — $filename");
      return dio.MultipartFile.fromBytes(bytes, filename: filename);
    } else {
      final bytes = await file.readAsBytes();
      final filename = xfile.name;
      print("📎 File (raw): ${bytes.length} bytes — $filename");
      return dio.MultipartFile.fromBytes(bytes, filename: filename);
    }
  }

  // returns compressed file only
  static Future<File?> compressedImageHttp(File file) async {
    final compressed = await ImageCompressor.compressUntilUnder1MB(file);

    if (compressed == null) {
      print("Image compression failed");
      return null;
    }

    print("Compressed path: ${compressed.path}");
    print("Compressed exists: ${await compressed.exists()}");

    print("Compressed size: ${await compressed.length()}");

    return compressed;
  }
}
