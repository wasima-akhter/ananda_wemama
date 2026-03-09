import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/common_widgets/cus_des_type_text_form_field.dart';
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
        backgroundColor: bgClr,
        appBar: CommonAppBarContent(title: Strings.contactSupport.capEachWord()),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CusNameTypeTextFormField(
                  controller: csc.nameCtrl,
                  focusNode: csc.nameFocus,
                  hintText: Strings.enterYourName,
                  validator: (v) => validateName(v),
                ),
                Gap(itemGap * 2),

                CusNameTypeTextFormField(
                  controller: csc.emailCtrl,
                  focusNode: csc.emailFocus,
                  hintText: Strings.enterEmailAddress,
                  validator: (v) => validateEmail(v),
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
                    rad: 30,
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
