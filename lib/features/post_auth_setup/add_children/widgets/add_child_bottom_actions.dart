import '../../../../app/helper_widgets_export.dart';
import '../../../auth/core/auth_button_templates.dart';
import '../controller/add_children_controller.dart';

class AddChildrenBottomActions extends StatelessWidget {
  const AddChildrenBottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddChildrenController.to;
    return Column(
      children: [
        Gap(8.h),
        Obx(
          () => AuthButton(
            isLoading: controller.isLoading,
            onTap: () => Get.toNamed(RoutePaths.lifeStyleAndInterests),
          ),
        ),
      ],
    );
  }
}
