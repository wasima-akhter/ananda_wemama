import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../app/helper_widgets_export.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({super.key, required this.width, required this.height})
    : shapeBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      );

  const ShimmerWidget.circular({super.key, required this.width, required this.height})
    : shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      color: c.inputBorder,

      // highlightColor: c.cardPrimary,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(color: c.inputBackground, shape: shapeBorder),
      ),
    );
  }
}
