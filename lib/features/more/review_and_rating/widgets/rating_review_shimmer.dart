import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cont_shimmer.dart';

class ReviewAndRating1stPartShimmer extends StatelessWidget {
  const ReviewAndRating1stPartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title: "What others think..."
        ContShimmer(h: 18, w: 200, rad: 6).mB(10),

        ContShimmer(h: 14, w: 100, rad: 3),
        Gap(itemGap * 2),
        Row(
          children: [
            ContShimmer(h: 11, w: 20, rad: 3), // rating number
            Gap(5),
            Row(children: List.generate(5, (index) => ContShimmer(h: 10, w: 10, rad: 3).mR(2))),
            Gap(5),
            ContShimmer(h: 11, w: 50, rad: 3), // total reviews
          ],
        ).mB(12),

        // Review & Rating row
        ContainerBordered(
          vp: 20,
          hp: 12,
          boxShadow: boxShadowAllSides,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContShimmer(h: 14, w: 100, rad: 3),
              Gap(itemGap),
              ...List.generate(5, (index) {
                return Row(
                  children: [
                    ContShimmer(h: 10, w: 20, rad: 3), // star number
                    Gap(5),
                    Expanded(child: ContShimmer(h: 6, rad: 5)),
                  ],
                ).mB(6);
              }),
            ],
          ),
        ),

        Gap(itemGap * 3),
        // Single review template
        ...List.generate(
          2,
          (index) => ContainerBordered(
            vp: 20,
            hp: 12,
            boxShadow: boxShadowAllSides,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContShimmer(h: 14, w: 150, rad: 6).mB(6), // reviewer name
                ContShimmer(h: 12, w: double.infinity, rad: 6).mB(4),
                ContShimmer(h: 12, w: double.infinity, rad: 6).mB(4),
                ContShimmer(h: 12, w: double.infinity, rad: 6).mB(6),
              ],
            ),
          ).mB(12),
        ),
        Gap(itemGap * 2),
        // Read all reviews button
        Center(child: ContShimmer(h: 40, w: 120, rad: 15).mB(10)),
      ],
    ).get10cm;
  }
}
