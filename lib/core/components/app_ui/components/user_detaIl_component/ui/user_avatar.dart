import '../../../../../../app/helper_widgets_export.dart';

class UserAvatar extends StatelessWidget {
  final String imageUrl;
  final bool? isFromProfile;

  const UserAvatar({super.key, required this.imageUrl, this.isFromProfile});

  @override
  Widget build(BuildContext context) {
    print(' imageUrl : $imageUrl');
    return Container(
      decoration: 0.circleBrdr(brdrW: 2.5, brdrClr: c.bottomSheetBackground),
      child: NetworkImageWidget(
        imageUrl: imageUrl,
        isCircle: true,
        hasBrdr: false,
        radius: isFromProfile == true ? 35 : S.w * 0.12,
        isUser: true,
        enablePreview: true,
      ),
    );
  }
}
