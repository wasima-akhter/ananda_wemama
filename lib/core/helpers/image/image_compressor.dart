import 'dart:developer' show log;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/extension/string_extension.dart';

class ImageCompressor {
  static Future<File?> compressUntilUnder1MB(File file) async {
    const int targetSizeBytes = 900 * 1024;
    int quality = 85;

    final dir = await getTemporaryDirectory();
    // ✅ Always save as .jpg regardless of input format
    final targetPath =
        '${dir.path}/compressed_${file.path.split('/').last.split('.').first}.jpg';

    Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: quality,
      minWidth: 1024,
      minHeight: 1024,
      format: CompressFormat.jpeg, // ✅ Force JPEG
    );

    if (compressedBytes == null) return null;

    while (compressedBytes!.length > targetSizeBytes && quality > 10) {
      quality -= 10;
      compressedBytes = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: quality,
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg, // ✅ Force JPEG
      );
      if (compressedBytes == null) return null;
    }

    final result = await File(targetPath).writeAsBytes(compressedBytes);

    log(
      'Final compressed size: ${compressedBytes.length} bytes at quality $quality',
    );
    return result;
  }
  // static Future<File?> compressUntilUnder1MB(File file) async {
  //   const int targetSizeBytes = 900 * 1024; // 900 KB to be safe
  //   int quality = 85;
  //   File? result;

  //   // First try: resize + compress
  //   Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
  //     file.absolute.path,
  //     quality: quality,
  //     minWidth: 1024,
  //     minHeight: 1024,
  //   );

  //   if (compressedBytes == null) return null;

  //   // Reduce quality until under target
  //   while (compressedBytes!.length > targetSizeBytes && quality > 10) {
  //     quality -= 10;
  //     compressedBytes = await FlutterImageCompress.compressWithFile(
  //       file.absolute.path,
  //       quality: quality,
  //       minWidth: 800,
  //       minHeight: 800,
  //     );
  //     if (compressedBytes == null) return null;
  //   }

  //   // Save to cache
  //   final dir = await getTemporaryDirectory();
  //   final targetPath = '${dir.path}/compressed_${file.path.split('/').last}';
  //   result = await File(targetPath).writeAsBytes(compressedBytes);

  //   log(
  //     'Final compressed size: ${compressedBytes.length} bytes at quality $quality',
  //   );
  //   return result;
  // }

  static Future<File?> compressImage(File file, {int quality = 70}) async {
    try {
      final dir = await getTemporaryDirectory();

      final targetPath =
          "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: 1080,
        minHeight: 1080,
        format: CompressFormat.jpeg,
      );

      if (compressedFile == null) {
        "Image compression failed".showToast();
        return null;
      }

      return File(compressedFile.path);
    } catch (e) {
      log("Compression Error: $e");
      return null;
    }
  }

  static Future<File?> compressUntilUnder3MB(File file) async {
    int quality = 90;

    File currentFile = file;

    while (await currentFile.length() > (3 * 1024 * 1024) && quality > 10) {
      final compressed = await compressImage(currentFile, quality: quality);

      if (compressed == null) {
        return null;
      }

      currentFile = compressed;

      quality -= 10;
    }

    /// final safety check
    if (await currentFile.length() > (3 * 1024 * 1024)) {
      return null;
    }

    return currentFile;
  }
}
