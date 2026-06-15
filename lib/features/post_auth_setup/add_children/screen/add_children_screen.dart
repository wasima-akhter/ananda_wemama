import 'package:mama_app/features/post_auth_setup/add_children/controller/add_children_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../auth/core/auth_button_templates.dart';
import '../../../auth/core/auth_scaffold.dart';

class AddChildrenScreen extends StatelessWidget {
  const AddChildrenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final msc = Get.find<AddChildrenController>();

    final mumStageFormKey = GlobalKey<FormState>();

    return AuthScaffold(
      bottomWidget: Obx(
        () => AuthButton(
          isLoading: msc.isLoading,
          onTap: () => Get.toNamed(RoutePaths.lifeStyleAndInterests),
        ).mB(10),
      ),

      // appBar: CommonAppBarContent(title: Strings.mumsStage),
      child: Form(
        key: mumStageFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [Text("data"), Gap(itemGap * 2.5)],
        ).getcm,
      ),
    );
  }
}
