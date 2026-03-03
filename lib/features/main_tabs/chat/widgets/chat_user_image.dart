import '../../../../app/helper_widgets_export.dart';

class ChatUserImage extends StatelessWidget {
  final String imageUrl;
  final String name;
  const ChatUserImage({super.key, required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "?";
    return imageUrl.isNotEmpty
        ? NetworkImageWidget(imageUrl: imageUrl, radius: 25, isCircle: true)
        : Container(
            decoration: 0.circleBrdr(),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: c.inputBackground,
              child: Text(letter, style: TxtStyle.outfitSmTitle),
            ),
          );
  }
}
