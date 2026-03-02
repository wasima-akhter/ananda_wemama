import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/network_image_widget.dart';

class UserPhotoWidget extends StatelessWidget {
  final XFile? selImage;
  final String? imageUrl;
  const UserPhotoWidget({super.key, this.selImage, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (selImage != null) {
      return Container(
        width: (S.w * 0.2).w,
        height: (S.w * 0.2).w,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // makes it circular
          image: DecorationImage(
            image: FileImage(File(selImage!.path)), // FIX
            fit: BoxFit.cover,
          ),

          color: bgClr, // fallback background color
        ),
      );
    } else {
      return NetworkImageWidget(
        imageUrl: imageUrl,
        // imageUrl: Strings.fakeImageUrl,
        isCircle: true,
      );
    }
  }
}
