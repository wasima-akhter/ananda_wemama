import '../../app/helper_widgets_export.dart';

class ImageDotAsset extends StatelessWidget {
  final String path;
  final double? height;
  const ImageDotAsset({super.key, required this.path, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(path, height: (height)?.h, fit: BoxFit.cover);
  }
}
