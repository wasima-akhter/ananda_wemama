import '../../../../app/helper_widgets_export.dart';
import '../../../../gen/assets.gen.dart';
import '../../../main_tabs/home/modules/profile_tile.dart';
import '../controller/account_settings_controller.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final epc = Get.find<AccountSettingsController>();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: bgClr,
        appBar: CommonAppBarContent(title: Strings.accountSettings),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileTile(
                title: Strings.changePassword,
                iconPath: Assets.icons.password,
                onTap: () {
                  Get.toNamed(RoutePaths.changePassword);
                },
              ),
              Gap(itemGap),
              ProfileTile(
                title: Strings.bankAccount,
                iconPath: Assets.icons.password,
                iconH: 30,

                onTap: () {
                  Get.toNamed(RoutePaths.bankDetails);
                },
              ),
              Gap(itemGap),
            ],
          ).getcm,
        ),
      ),
    );
  }
}
