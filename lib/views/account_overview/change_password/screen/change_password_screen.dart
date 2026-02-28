import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_pass_type_text_form_field.dart';
import '../../../../core/common_widgets/title_tile.dart';
import '../../../../core/common_widgets/visibility_suffix.dart';
import '../../../../core/utils/validator/validators.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;

    final cpc = Get.find<ChangePasswordController>();

    final cngPassFormKey = GlobalKey<FormState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: bgClr,
        appBar: CommonAppBarContent(title: Strings.changePassword),
        body: Center(
          child: Column(
            spacing: itemGap * 5,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: cngPassFormKey,
                child: Column(
                  spacing: itemGap * 2,
                  children: [
                    TitleTile(
                      child: CusPassTypeTextFormField(
                        controller: cpc.oldPassCtrl,
                        focusNode: cpc.oldPassFocus,
                        hintText: Strings.oldPassword,
                        hintW: 600,
                        isNoBrder: true,
                      ),
                    ),

                    Obx(() {
                      return TitleTile(
                        child: CusPassTypeTextFormField(
                          controller: cpc.newPassCtrl,
                          hintText: Strings.newPassword,
                          hintW: 600,
                          isNoBrder: true,
                          focusNode: cpc.newPassFocus,
                          obscureText: cpc.isNewPassHidden,
                          suffix: VisibilitySuffix(
                            onTap: cpc.toggleNewPass,
                            icon: cpc.newPasswordIcon,
                          ),
                          validator: (value) => validatePassword(value),
                        ),
                      );
                    }),

                    Obx(
                      () => TitleTile(
                        child: CusPassTypeTextFormField(
                          controller: cpc.confirmPassCtrl,
                          focusNode: cpc.confirmPassFocus,
                          hintText: Strings.confirmPassword,
                          hintW: 600,
                          isNoBrder: true,
                          obscureText: cpc.isConPassHidden,
                          suffix: VisibilitySuffix(onTap: cpc.toggleConPass, icon: cpc.conPassIcon),
                          validator: (value) => validateConfirmPass(
                            confirmPass: value,
                            password: cpc.newPassCtrl.text,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Obx(
                () => CustomBtnWTxt(
                  outlined: true,
                  isLoading: cpc.isLoading,
                  onTap: () async {
                    // later you’ll call API here
                    await cpc.onTapUpdatePassword(formKey: cngPassFormKey);
                  },
                  btnTxt: Strings.updatePassword,
                ),
              ),
            ],
          ).getcm,
        ),
      ),
    );
  }
}
