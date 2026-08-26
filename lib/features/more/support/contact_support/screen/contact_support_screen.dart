import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/inputs/cus_des_type_text_form_field.dart';
import '../../../../../core/utils/validator/validators.dart';
import '../controller/contact_support_controller.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final csc = Get.find<ContactSupportController>();

    // Form key
    final formKey = GlobalKey<FormState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: bgClrNew,
        appBar: CommonAppBarContent(
          title: Strings.contactSupport.capEachWord(),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(20.h),
                CusNameTypeTextFormField(
                  controller: csc.nameCtrl,
                  focusNode: csc.nameFocus,
                  hintText: Strings.enterYourName,
                  validator: (v) => validateName(v),
                  rad: 12,
                  brdrW: 0.6,
                ),
                Gap(itemGap * 2),

                CusNameTypeTextFormField(
                  rad: 12,
                  controller: csc.emailCtrl,
                  focusNode: csc.emailFocus,
                  hintText: Strings.enterEmailAddress,
                  validator: (v) => validateEmail(v),
                  brdrW: 0.6,
                ),

                Gap(itemGap * 2),

                CusDesTypeTextFormField(
                  controller: csc.messageCtrl,
                  focusNode: csc.messageFocus,
                  hintText: Strings.writeHere,
                  rad: 12,
                  validator: (v) => validateDescription(v), // or create custom
                ),

                Gap(itemGap * 5),

                Obx(() {
                  return CustomBtnWTxt(
                    onTap: () => csc.onTapSubmit(formKey: formKey),
                    btnTxt: Strings.submit,
                    rad: 12,
                    isLoading: csc.isLoading,
                  );
                }),
              ],
            ).getcm,
          ),
        ),
      ),
    );
  }
}
