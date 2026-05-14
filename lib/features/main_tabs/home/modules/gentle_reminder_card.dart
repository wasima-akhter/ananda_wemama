import '../../../../app/helper_widgets_export.dart';

class GentleReminderCard extends StatelessWidget {
  const GentleReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.cardReminder,
      rad: 20,
      hp: 16,
      vp: 12,
      boxShadow: boxShadowBottom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.todaysReminder.capEachWord(), style: TxtStyle.outfitSmTitle),
          Gap(4),
          Text(Strings.restCounts.capEachWord(), style: TxtStyle.outfitSmSecNor),
        ],
      ),
    );
  }
}
