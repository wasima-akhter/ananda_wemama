import 'package:mama_app/features/auth/core/auth_button_templates.dart';
import 'package:mama_app/features/auth/core/auth_scaffold.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/finish_setting_profile_controller.dart';

class FinishSettingProfileScreen extends StatelessWidget {
  const FinishSettingProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final msc = Get.find<FinishSettingProfileController>();

    final mumStageFormKey = GlobalKey<FormState>();

    return AuthScaffold(
      bottomWidget: AuthButton(
        isLoading: false,
        onTap: () => Get.toNamed(RoutePaths.addChildren),
        //  isLoading: msc.isLoading,
        //  msc.onTapContinue(mumStageFormKey),
      ).mB(10),

      // appBar: CommonAppBarContent(title: Strings.mumsStage),
      child: Column(
        children: [
          Column(
            children: [
              // Welcome tetxt
              Text(
                Strings.abc,
                textAlign: TextAlign.center,
                style: TxtStyle.dmSerifDisplayRegular(),
              ),

              Gap(itemGap),
              // if (subtitleText.isNotEmpty)
              //   Text(
              //     subtitleText.capEachWord(),
              //     textAlign: TextAlign.center,
              //     style: TxtStyle.poppinsSemiBold12Center(color: subtitleTextColor),
              //   ),
            ],
          ),
          Gap(10.h),
          Form(
            key: mumStageFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [Text("stage finish"), Gap(itemGap * 2.5)],
            ).getcm,
          ),
        ],
      ).getcm,
    );
  }
}
