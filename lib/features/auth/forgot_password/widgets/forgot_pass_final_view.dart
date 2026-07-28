import 'package:we_mama/features/auth/core/auth_button_templates.dart';

import '../../../../app/helper_widgets_export.dart';

class ForgotPassFinalView extends StatelessWidget {
  final bool isLoading;
  final void Function()? onTap;
  const ForgotPassFinalView({super.key, required this.isLoading, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(S.h * 0.2),
        // Main title
        Text(
          Strings.gladToSeeUAgain.capEachWord(),
          style: TxtStyle.dmSerifDisplayRegular(),
        ),
        Gap(itemGap),

        // Subtitle
        Text(
          Strings.passwordChangedContinueLogin.capEachWord(),
          textAlign: TextAlign.center,
          style: TxtStyle.poppinsSemiBold12Center(),
        ),
        Gap(itemGap * 3),

        AuthButton(isLoading: isLoading, onTap: onTap),

        Gap(itemGap * 1.5 + Get.mediaQuery.viewPadding.bottom),
      ],
    );
  }
}
