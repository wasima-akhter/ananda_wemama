import '../../../../../app/helper_widgets_export.dart';
import '../../../../../gen/assets.gen.dart';
import '../../modules/onboard2/onboard2_feature_card.dart';

class Onboard3BottomSection extends StatelessWidget {
  const Onboard3BottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OnboardFeatureCard(
          icon: Assets.icons.userDouble,
          title: "Meet mums nearby",
          subtitle: "who understand your journey",
        ),
      ],
    );
  }
}
