import 'package:flutter/foundation.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../core/components/app_ui/components/user_detaIl_component/controller/user_detail_controller.dart';
import '../../../../../../core/services/push_notification/controller/push_notification_controller.dart';
import '../controller/profile_controller.dart';
import '../widgets/profile_section.dart';
import '../widgets/profile_settings_tiles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<ProfileController>();
    final udc = Get.find<UserDetailController>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.profile),
      onRefresh: pc.fetchMyProfile,
      floatingActionButton: // Temporary debug button — put it anywhere during testing
          // e.g. in your home screen or profile screen
          kDebugMode
          ? ElevatedButton(
              onPressed: () {
                PushNotificationController.to.sendTestNotification(
                  'FOREGROUND',
                );
              },
              child: const Text('Test Foreground Notification'),
            )
          : null,
      child: Column(
        children: [
          ProfileSection(pc: pc, udc: udc),

          Gap(itemGap * 2),

          ProfileSettingsTiles(pc: pc),

          Gap(itemGap),
        ],
      ).getcm,
    );
  }
}
