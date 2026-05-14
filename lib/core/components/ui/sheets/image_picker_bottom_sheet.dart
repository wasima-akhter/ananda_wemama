import '../../../../app/helper_widgets_export.dart';
import 'drag_handle_for_sheets.dart';

class PickImageBottomSheet extends StatelessWidget {
  final void Function()? onTapGallery;
  final void Function()? onTapCamera;
  const PickImageBottomSheet({super.key, this.onTapGallery, this.onTapCamera});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;
    return Column(
      children: [
        DragHandleForSheets(),
        Gap(itemGap * 2),
        Text(Strings.selectPhoto, style: TxtStyle.inter(fs: 22, w: 600)),
        Gap(itemGap * 5.5),

        Row(
          children: [
            Expanded(
              child: CusGestureDetector(
                onTap: onTapGallery,
                child: Container(child: Image.asset(ImagesPath.gallery, height: 1.sw * 0.2)),
              ),
            ),
            Expanded(
              child: CusGestureDetector(
                onTap: onTapCamera,
                child: Image.asset(ImagesPath.camera, height: 1.sw * 0.18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
