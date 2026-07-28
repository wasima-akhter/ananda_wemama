import 'package:we_mama/gen/assets.gen.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../modules/onboard2/onboard2_feature_card.dart';

class Onboard2FeaturesSection extends StatelessWidget {
  const Onboard2FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      spacing: 10.h,
      children: [
        OnboardFeatureCard(
          icon: Assets.icons.shieldSupport,
          title: 'Supportive Community',
          subtitle: 'Built for women navigating \nmotherhood.',
        ),

        OnboardFeatureCard(
          icon: Assets.icons.userDouble,
          title: 'Meaningful Connection',
          subtitle: 'Find mums who truly \nunderstand.',
        ),

        OnboardFeatureCard(
          icon: Assets.icons.lockPrivacy,
          title: 'Privacy First',
          subtitle: 'Share at your own comfort \nlevel',
        ),
      ],
    );
  }
}
