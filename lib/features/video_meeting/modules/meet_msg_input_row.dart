import '../../../app/helper_widgets_export.dart';
import '../../../core/components/ui/inputs/cus_des_type_text_form_field.dart';
import '../controller/live_chat_controller.dart';
import '../controller/meeting_controller.dart';

class MsgInputRow extends StatelessWidget {
  const MsgInputRow({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = MeetingController.to;
    final cc = LiveChatController.to;

    final inputMsgCtrl = mc.inputMsgCtrl;
    final inputMsgFocus = mc.inputMsgFocus;

    return CusDesTypeTextFormField(
      controller: inputMsgCtrl,
      focusNode: inputMsgFocus,
      hintText: Strings.typeSomething,
      minLines: 1,
      minHeight: 20,
      maxHeight: 60,
      bgClr: c.textOnPrimary,
      isPaddingLess: true,
      suffix: CusCircleIconButton(
        radius: 15,
        backgroundColor: c.primary,
        onTap: () => cc.sendMessage(mc.inputMsgCtrl.text),
        child: SvgIcon(iconPath: IconsPath.sendLargeWhite, height: 20),
      ).mAll(4),
    ).mHV(10, 0);
  }
}
