import '../../../../app/helper_widgets_export.dart';
import '../../../utils/validator/validators.dart';

class NetworkCircleAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const NetworkCircleAvatar({super.key, this.imageUrl, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    if (isValidUrl(imageUrl)) {
      return CircleAvatar(
        radius: radius.r,
        backgroundColor: Colors.grey[200],
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError: (_, __) {
          // Show placeholder on error
          ClipOval(
            child: SvgIcon(iconPath: IconsPath.imagePlaceholder, height: 25.h),
          );
        },
      );
    } else {
      // fallback if URL is invalid
      return CircleAvatar(
        radius: radius.r,
        backgroundColor: Colors.grey[200],
        child: SvgIcon(iconPath: IconsPath.imagePlaceholder, height: 25.h),
      );
    }
  }
}
