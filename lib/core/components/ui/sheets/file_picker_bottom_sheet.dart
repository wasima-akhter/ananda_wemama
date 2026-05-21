import '../../../../app/helper_widgets_export.dart';
import 'drag_handle_for_sheets.dart';

class FilePickerBottomSheet extends StatelessWidget {
  final void Function()? onTapGallery;
  final void Function()? onTapCamera;
  final void Function()? onTapFile;
  const FilePickerBottomSheet({
    super.key,
    this.onTapGallery,
    this.onTapCamera,
    this.onTapFile,
  });

  @override
  Widget build(BuildContext context) {
    double height = S.w * 0.13;
    return Column(
      children: [
        DragHandleForSheets(),
        Gap(itemGap * 2),
        Text(Strings.selectPhotoOrFile, style: TxtStyle.inter(fs: 16, w: 600)),
        Gap(itemGap * 5.5),

        Row(
          spacing: itemGap * 2,
          children: [
            // Expanded(
            //   child: CusGestureDetector(
            //     onTap: onTapGallery,
            //     child: CircleAvatar(
            //       backgroundColor: grey200,
            //       radius: S.w * 0.13 * 0.6,
            //       child: Image.asset(ImagesPath.gallery, height: height),
            //     ),
            //   ),
            // ),
            Expanded(
              child: CusGestureDetector(
                onTap: onTapCamera,
                child: Image.asset(ImagesPath.camera, height: height),
              ),
            ),
            Expanded(
              child: CusGestureDetector(
                onTap: onTapFile,
                child: Image.asset(ImagesPath.folderAttach, height: height),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
