import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../core/components/ui/loaders/shimmer_widget.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      hasBrdr: true,
      brdrClr: c.secondary.withOpacity(0.3),
      contClr: c.inputBackground,
      child: Column(
        children: [
          // avatar shimmer
          ShimmerWidget.circular(width: 90, height: 90),
          Gap(itemGap),
          // name shimmer
          ShimmerWidget.rectangular(width: 140, height: 16),
          Gap(itemGap),
          // info rows
          ShimmerWidget.rectangular(width: double.infinity, height: 14),
          Gap(8),
          ShimmerWidget.rectangular(width: double.infinity, height: 14),
          Gap(8),
          ShimmerWidget.rectangular(width: 200, height: 14),
          Gap(itemGap),
          // images row shimmer
          Row(
            children: List.generate(
              4,
              (_) => Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: 4.pa,
                    child: ShimmerWidget.rectangular(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ).getcm,
    );
  }
}
