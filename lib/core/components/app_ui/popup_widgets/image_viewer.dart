import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../app/helper_widgets_export.dart';

class ImageViewerPopup extends StatelessWidget {
  final dynamic imageSource;

  const ImageViewerPopup({super.key, required this.imageSource});

  ImageProvider _resolveImage() {
    if (imageSource is File) {
      return FileImage(imageSource);
    }

    if (imageSource is XFile) {
      return FileImage(File(imageSource.path));
    }

    // default: network or asset string
    final path = imageSource.toString();

    if (path.startsWith('http')) {
      return NetworkImage(path);
    }

    return AssetImage(path);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// BACKGROUND + ZOOMABLE IMAGE
        Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 1,
            maxScale: 4,
            child: Image(image: _resolveImage(), fit: BoxFit.contain),
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
