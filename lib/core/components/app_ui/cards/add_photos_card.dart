import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../app/helper_widgets_export.dart';

class AddPhotosCard extends StatelessWidget {
  final void Function()? onTap;
  const AddPhotosCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CusGestureDetector(
      onTap: onTap,
      child: ContainerBordered(
        hasBrdr: true,
        vp: 11,
        hp: 7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgIconColored(iconPath: IconsPath.addPlusCircle, height: 21),
            // Gap(2.h),
            Text(Strings.addPhoto, style: TxtStyle.outfitxSmNor500),
          ],
        ),
      ),
    );
  }
}

class AddPhotoCard extends StatelessWidget {
  final void Function()? onTap;
  final XFile? imageFile;
  final VoidCallback? onRemove;

  const AddPhotoCard({super.key, this.onTap, this.imageFile, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final hasImage = imageFile != null;

    return CusGestureDetector(
      onTap: hasImage ? null : onTap,
      child: ContainerBordered(
        hasBrdr: true,
        vp: 0,
        hp: 0,
        h: 90,
        w: 90,
        rad: 12,
        child: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(imageFile!.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                  Positioned(
                    top: 6,
                    right: 6,
                    child: CusGestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgIconColored(iconPath: IconsPath.addPlusCircle, height: 21),
                  Gap(4),
                  Text(Strings.addPhoto, style: TxtStyle.outfitxSmNor500),
                ],
              ),
      ),
    );
  }
}
