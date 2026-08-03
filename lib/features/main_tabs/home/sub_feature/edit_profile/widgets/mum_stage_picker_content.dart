import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../post_auth_setup/mums_stage/controller/mums_stage_controller.dart';
import '../../../../../post_auth_setup/mums_stage/modules/mums_stage_list.dart';

class MumsStagePickerContent extends StatelessWidget {
  const MumsStagePickerContent({super.key, required this.controller});

  final MumsStageController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [MumsStageList()]));
  }
}
