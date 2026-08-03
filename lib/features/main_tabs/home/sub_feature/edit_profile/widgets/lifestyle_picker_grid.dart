import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../post_auth_setup/lifestyle_and_interests/controller/lifestyle_and_interests_controller.dart';
import '../../../../../post_auth_setup/lifestyle_and_interests/widgets/lifestyle_interest_tile.dart';

class LifestyleInterestsPickerGrid extends StatelessWidget {
  const LifestyleInterestsPickerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final lic = LifestyleAndInterestsController.to;

    return GridView.builder(
      itemCount: lic.lifestyleInterests.length,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),

      itemBuilder: (_, index) {
        return LifestyleInterestTile(item: lic.lifestyleInterests[index]);
      },
    );
  }
}
