import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../core/components/app_ui/cards/add_photos_card.dart';
import '../../../../../../core/components/ui/dialogs/popups.dart';

class DescriptionImagesGrid extends StatelessWidget {
  const DescriptionImagesGrid({
    super.key,
    required this.images,
    required this.onAdd,
    required this.onRemove,
  });

  final List<XFile> images;
  final Future<void> Function() onAdd;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    final showAddBtn = images.length < 4;
    final double imageSize = (S.w - S.w * 0.05 * 2 - 8.w * 4) / 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.w,
            children: [
              ...List.generate(
                images.length,
                (i) => CusGestureDetector(
                  onTap: () =>
                      showImageViewer(context: context, imageSource: images[i]),
                  child: _ImageTile(
                    path: images[i].path,
                    size: imageSize,
                    onRemove: () => onRemove(i),
                  ),
                ),
              ),
              if (showAddBtn)
                SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: AddPhotosCard(onTap: onAdd),
                ),
            ],
          ),
        ),
        Text(Strings.maximum4Photos, style: TxtStyle.outfit(fs: 11)),
      ],
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.path,
    required this.size,
    required this.onRemove,
  });

  final String path;
  final double size;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Container(
            decoration: BoxDecoration(
              color: c.scaffoldBackground,
              boxShadow: boxShadowBottom(),
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: 1.pa,
            width: size,
            height: size,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.75),
              ),
            ),
          ),
        ),
        Positioned(
          top: 3,
          right: 2,
          child: CusGestureDetector(
            onTap: onRemove,
            child: CircleAvatar(
              radius: 8.r,
              backgroundColor: ctransp,
              child: SvgIconColored(
                iconPath: IconsPath.closeCircle,
                iconColor: c.scaffoldBackground,
                height: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
