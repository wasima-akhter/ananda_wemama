import 'package:we_mama/features/post_auth_setup/add_children/controller/add_children_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../auth/core/auth_scaffold.dart';
import '../widgets/add_child_bottom_actions.dart';
import '../widgets/add_child_header_section.dart';
import '../widgets/add_child_list.dart';
import '../widgets/add_child_list_header.dart';
import '../widgets/child_create_card.dart';

class AddChildrenScreen extends StatelessWidget {
  const AddChildrenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddChildrenController>();

    return AuthScaffold(
      bottomWidget: AddChildrenBottomActions(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddChildrenHeaderSection(),

          Gap(10.h),

          const ChildCreateCard(),
          Gap(16.h),

          Obx(() {
            if (controller.children.isNotEmpty) {
              return Column(children: [AddChildrenListHeader(), Gap(12.h)]);
            }

            return const SizedBox.shrink();
          }),

          AddChildrenList(),
        ],
      ).getcm,
    );
  }
}
