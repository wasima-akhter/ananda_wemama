import 'package:mama_app/core/common_widgets/small_popup_dialog.dart';

import '../../../app/helper_widgets_export.dart';

class AskQuesPopup extends StatelessWidget {
  final void Function()? onTap;
  final TextEditingController writeQuesCtrl;
  final FocusNode writeQuesFocusNode;
  const AskQuesPopup({
    super.key,
    this.onTap,
    required this.writeQuesCtrl,
    required this.writeQuesFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      hm: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.askYourQuestions.capEachWord(),
            style: TxtStyle.interSemiB(fs: 13, w: 600, color: c.primary),
          ),

          Gap(itemGap * 2),

          Row(
            children: [
              Expanded(
                child: CusNameTypeTextFormField(
                  contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 8),
                  hintStyle: TxtStyle.outfit(color: c.primary.withOpacity(0.8)),
                  brdrW: 0.6,
                  brdrClr: c.primary,
                  fillColor: ctransp,
                  controller: writeQuesCtrl,
                  focusNode: writeQuesFocusNode,

                  hintText: Strings.writeQuestion,
                ),
              ),

              Gap(4),
              CusGestureDetector(
                onTap: onTap,
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: c.primary,
                  child: SvgIcon(iconPath: IconsPath.sendSmallWhite, height: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
