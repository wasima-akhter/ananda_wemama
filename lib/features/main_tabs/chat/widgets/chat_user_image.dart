import '../../../../app/helper_widgets_export.dart';

class ChatUserImage extends StatelessWidget {
  final String imageUrl;
  final String name;

  const ChatUserImage({super.key, required this.imageUrl, required this.name});

  static const double avatarRadius = 18;

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "?";

    return
    // imageUrl.isNotEmpty
    //     ?
    NetworkImageWidget(
      name: name,
      imageUrl: imageUrl,
      radius: avatarRadius,
      isCircle: true,
      isUser: true,
      isSmall: true,
      enablePreview: true,
    );
    // : Container(
    //     width: avatarRadius * 2,
    //     height: avatarRadius * 2,
    //     decoration: BoxDecoration(
    //       shape: BoxShape.circle,
    //       color: c.inputBackground,
    //       border: Border.all(color: c.inputBorder),
    //     ),
    //     alignment: Alignment.center,
    //     child: Text(letter, style: TxtStyle.outfitSemiB(fs: 14)),
    //   );
  }
}
