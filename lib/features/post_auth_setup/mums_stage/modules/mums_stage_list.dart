import '../../../../app/helper_widgets_export.dart';
import '../controller/mums_stage_controller.dart';
import 'mums_stage_tile.dart';

class MumsStageList extends GetView<MumsStageController> {
  const MumsStageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: List.generate(
          controller.stageList.length,
          (index) => MumsStageTile(
            item: controller.stageList[index],
            isSelected: controller.isSelected(controller.stageList[index].id),
          ),
        ),
      ),
    );
  }
}
