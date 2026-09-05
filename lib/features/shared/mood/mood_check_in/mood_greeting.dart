import '../../../../app/helper_widgets_export.dart';
import '../../../../core/helpers/string_helper.dart';
import '../../../main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import 'mood_check_in_controller.dart';

class MoodGreeting extends StatelessWidget {
  const MoodGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(() {
          final userName =
              ProfileController.to.userProfileData.value?.name ?? '';
          return Text(
            "${MoodCheckInController.to.getGreetingMessage()}, ${userName.isNotEmpty ? getFirstWord(userName).cap : "Ada"}",
            style: TxtStyle.outfitSemiB(fs: 18, w: 600),
          );
        }),

        Gap(4),

        SvgIcon(iconPath: IconsPath.leaf),
      ],
    ).mL(4);
  }
}
