import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/helpers/grid/app_grids.dart';
import '../controller/lifestyle_and_interests_controller.dart';
import 'lifestyle_interest_tile.dart';

class LifestyleInterestsGrid extends StatelessWidget {
  const LifestyleInterestsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final lic = LifestyleAndInterestsController.to;

    return Obx(() {
      final items = lic.showAllInterests.value
          ? lic.lifestyleInterests
          : lic.lifestyleInterests.sublist(0, 12);

      return AppGridView(
        items: items, 
        itemBuilder: (_, item, _) {
          return LifestyleInterestTile(item: item);
        },
      );
    });
  }
}
