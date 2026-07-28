import 'package:we_mama/features/auth/core/auth_button_templates.dart';
import 'package:we_mama/features/auth/core/auth_scaffold.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/mums_stage_controller.dart';
import '../modules/mums_stage_header.dart';
import '../modules/mums_stage_list.dart';

class MumsStageScreen extends StatelessWidget {
  const MumsStageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final msc = Get.find<MumsStageController>();

    final mumStageFormKey = GlobalKey<FormState>();

    return AuthScaffold(
      bottomWidget: AuthButton(
        isLoading: false,
        onTap: msc.continueToNext,
        //  isLoading: msc.isLoading,
        //  msc.onTapContinue(mumStageFormKey),
      ).mB(10),

      // appBar: CommonAppBarContent(title: Strings.mumsStage),
      child: Form(
        key: mumStageFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            MumsStageHeader(),
            Gap(itemGap),
            MumsStageList(),
            Gap(itemGap * 2.5),
          ],
        ).getcm,
      ),
    );
  }
}
