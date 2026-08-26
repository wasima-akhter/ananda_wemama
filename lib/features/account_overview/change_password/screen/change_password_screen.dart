import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/helpers/visibility_suffix.dart';
import '../../../../core/components/ui/inputs/cus_pass_type_text_form_field.dart';
import '../../../../core/utils/validator/validators.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cpc = Get.find<ChangePasswordController>();

    final cngPassFormKey = GlobalKey<FormState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: bgClrNew,
        appBar: CommonAppBarContent(title: Strings.changePassword),
        body: Center(
          child: Column(
            spacing: itemGap * 5,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: cngPassFormKey,
                child: Column(
                  spacing: itemGap * 1.5,
                  children: [
                    Obx(() {
                      return CusPassTypeTextFormField(
                        controller: cpc.oldPassCtrl,
                        focusNode: cpc.oldPassFocus,
                        hintText: Strings.oldPassword,
                        validator: (value) => validatePassword(value),

                        obscureText: cpc.isOldPassHidden,

                        prefix: SvgIcon(
                          iconPath: IconsPath.lock,
                          height: 22,
                        ).mOnly(left: 15, right: 6),
                        prefixSize: 34,

                        suffix: VisibilitySuffix(
                          onTap: cpc.toggleOldPass,
                          icon: cpc.oldPasswordIcon,
                        ),

                        hintW: 600,
                      );
                    }),

                    Obx(() {
                      return CusPassTypeTextFormField(
                        controller: cpc.newPassCtrl,
                        hintText: Strings.newPassword,
                        hintW: 600,
                        focusNode: cpc.newPassFocus,
                        obscureText: cpc.isNewPassHidden,
                        prefix: SvgIcon(
                          iconPath: IconsPath.lock,
                          height: 22,
                        ).mOnly(left: 15, right: 6),
                        prefixSize: 34,
                        suffix: VisibilitySuffix(
                          onTap: cpc.toggleNewPass,
                          icon: cpc.newPasswordIcon,
                        ),
                        validator: (value) => validatePassword(value),
                      );
                    }),

                    Obx(
                      () => CusPassTypeTextFormField(
                        controller: cpc.confirmPassCtrl,
                        focusNode: cpc.confirmPassFocus,
                        hintText: Strings.confirmPassword,
                        hintW: 600,
                        obscureText: cpc.isConPassHidden,
                        prefix: SvgIcon(
                          iconPath: IconsPath.lock,
                          height: 22,
                        ).mOnly(left: 15, right: 6),
                        prefixSize: 34,
                        suffix: VisibilitySuffix(
                          onTap: cpc.toggleConPass,
                          icon: cpc.conPassIcon,
                        ),
                        validator: (value) => validateConfirmPass(
                          confirmPass: value,
                          password: cpc.newPassCtrl.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Obx(
                () => CustomBtnWTxt(
                  isSmall: true,
                  rad: 12,
                  isLoading: cpc.isLoading,
                  onTap: () async {
                    // later you’ll call API here
                    await cpc.onTapUpdatePassword(formKey: cngPassFormKey);
                  },
                  btnTxt: Strings.updatePassword,
                ),
              ),
            ],
          ).getcm.mT(20),
        ),
      ),
    );
  }
}
