import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:developer' show log;

import '../../utils/extension/string_extension.dart';

class ImageCompressor {
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
