import 'package:we_mama/core/helpers/string_helper.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/helpers/shapes/custom_divider.dart';

class OnboardLoginSection extends StatelessWidget {
  const OnboardLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Strings.alreadyHaveAnAccount,
          style: TxtStyle.outfitSemiB(fs: 14, h: 1.0, color: Colors.black),
        ),

        CusGestureDetector(
          onTap: () => Get.toNamed(RoutePaths.signin),
          child: ContainerBordered(
            child: Column(
              children: [
                Text(
                  Strings.loginWithSpace.capEachWord(),
                  style: TxtStyle.outfitSemiB(
                    fs: 14,
                    w: 600,
                    h: 1.0,
                    color: c.primary,
                  ),
                ),
                CustomDivider(
                  w: findTextWidth(
                    text: Strings.loginWithSpace.capEachWord(),
                    style: TxtStyle.outfitSemiB(
                      fs: 14,
                      w: 600,
                      h: 1.0,
                      color: c.primary,
                    ),
                  ),
                  h: 1,
                  clr: c.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
