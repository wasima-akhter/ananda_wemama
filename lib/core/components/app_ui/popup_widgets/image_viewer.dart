import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../app/helper_widgets_export.dart';

class ImageViewerPopup extends StatelessWidget {
  final dynamic imageSource;

  const ImageViewerPopup({super.key, required this.imageSource});

  bool get isNetwork =>
      imageSource is String && imageSource.toString().startsWith('http');

  bool get isFile => imageSource is File || imageSource is XFile;

  String? get assetPath {
    if (imageSource is String && !isNetwork) {
      return imageSource;
    }
    return null;
  }

  File? get file {
    if (imageSource is File) return imageSource;
    if (imageSource is XFile) return File(imageSource.path);
    return null;
  }

  Widget _buildImage() {
    // NETWORK IMAGE
    if (isNetwork) {
      return Image.network(
        imageSource,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _placeholder();
        },
      );
    }

    // FILE IMAGE
    if (file != null) {
      return Image.file(
        file!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _placeholder();
        },
      );
    }

    // ASSET IMAGE
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _placeholder();
        },
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: bgClr,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(Icons.broken_image, size: 60, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "Image not available",
            style: TxtStyle.outfit(color: Colors.grey, fs: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// IMAGE WITH ZOOM
        Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 1,
            maxScale: 4,
            child: _buildImage(),
          ),
        ),

        /// CLOSE BUTTON
        Positioned(
          top: 40,
          right: 20,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 22),
            ),
          ),
        ),
      ],
    );
  }
}
