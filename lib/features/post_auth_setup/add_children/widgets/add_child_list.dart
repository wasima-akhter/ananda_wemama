import 'package:we_mama/features/post_auth_setup/add_children/controller/add_children_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import 'child_edit_card.dart';
import 'child_summary_tile.dart';

class AddChildrenList extends StatelessWidget {
  const AddChildrenList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddChildrenController.to;
    return
    // Obx(
    //   () => Column(
    //     children: controller.children.reversed.map((child) {
    //       final isEditing = controller.isEditing(child.id);
    //       return ChildExpandableCard(
    //         child: child,
    //         isEditing: isEditing,
    //         onEdit: () {
    //           controller.startEditing(child);
    //           controller.scrollToChild(child.id);
    //         },
    //         onDelete: () => controller.deleteChild(child.id),
    //       );
    //     }).toList(),
    //   ),
    // );
    Obx(
      () => ListView.separated(
        shrinkWrap: true,
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.children.length,
        separatorBuilder: (_, _) => Gap(6.h),
        itemBuilder: (_, index) {
          final child = controller.children[index];

          return Obx(() {
            final isEditing = controller.isEditing(child.id);

            return ChildExpandableCard(
              child: child,
              isEditing: isEditing,
              onEdit: () {
                controller.startEditing(child);
              },
              onDelete: () => controller.deleteChild(child.id),
            );
          });
        },
      ),
    );
  }
}

class ChildExpandableCard extends StatelessWidget {
  final ChildInfo child;
  final bool isEditing;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ChildExpandableCard({
    super.key,
    required this.child,
    required this.isEditing,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,

      child: isEditing ? _editCard() : _summaryCard(),
    );
  }

  Widget _summaryCard() {
    return ChildSummaryTile(
      dob: child.dateOfBirth.formatMMMMdyyyy,
      gender: child.gender.name.capitalizeFirst!,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }

  Widget _editCard() {
    final controller = Get.find<AddChildrenController>();

    return ChildEditCard(child: child);
  }
}
