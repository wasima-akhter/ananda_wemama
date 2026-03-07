import '../../../../app/helper_widgets_export.dart';

class UserAvatar extends StatelessWidget {
  final String imageUrl;
  final bool? isFromProfile;

  const UserAvatar({super.key, required this.imageUrl, this.isFromProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: 0.circleBrdr(brdrW: 4, brdrClr: c.secondary.withOpacity(0.5)),
      child: NetworkImageWidget(
        imageUrl: imageUrl,
        isCircle: true,
        radius: isFromProfile == true ? 35 : S.w * 0.15,
      ),
    );
  }
}
