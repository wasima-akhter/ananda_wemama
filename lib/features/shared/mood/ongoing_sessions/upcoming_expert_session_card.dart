import 'package:mama_app/core/components/ui/dialogs/popups.dart';
import 'package:mama_app/core/components/ui/helpers/shapes/custom_divider.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/helpers/date_helper.dart';
import '../../../main_tabs/experts/model/expert_session_list_model.dart';

class UpcomingExpertSessionCard extends StatelessWidget {
  final void Function({required String expertId, required String sessionId}) onTapQues;
  final RxBool isSendQuesLoading;
  final TextEditingController writeQuesCtrl;
  final FocusNode writeQuesFocusNode;
  final Session data;
  final bool? isFromUpcomgScreen;
  const UpcomingExpertSessionCard({
    super.key,
    required this.onTapQues,
    required this.writeQuesCtrl,
    required this.writeQuesFocusNode,
    required this.data,
    this.isFromUpcomgScreen,
    required this.isSendQuesLoading,
  });

  @override
  Widget build(BuildContext context) {
    final doctorName = (data.expert?.name ?? "Unknown").capEachWord();
    final specialty = (data.expert?.profession?.title ?? "Specialist").capEachWord();
    final sessionTitle = (data.title ?? "Session").capEachWord();
    final description = (data.description ?? "").cap;
    final time = data.time ?? "--:--";
    final date = DateHelper().formatUTCtimestamp(data.date.toString()).date;

    final imgUrl = data.expert?.image ?? '';
    final channelName = data.channelName ?? '';

    final expertId_ = data.expert?.id ?? '';
    final sessionId_ = data.id ?? '';

    return ContainerBordered(
      contClr: c.cardOngoing,
      rad: 20,
      hp: 16,
      vp: 16,
      boxShadow: boxShadowBottom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.upcomingExpertSession.capEachWord(), style: TxtStyle.outfitSmTitle),

          Gap(itemGap),

          CustomDivider(isFullWidth: true, h: 0.6),
          Gap(itemGap),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              circledNetworkImageBgComponent(imagePath: imgUrl, radius: 22),
              Gap(itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(doctorName, style: TxtStyle.urbanistSmTitle),
                    Text(specialty, style: TxtStyle.urbanistSmTitleSec),
                  ],
                ),
              ),
              Gap(itemGap),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(time, style: TxtStyle.outfitSemiB(fs: 11, w: 500, color: c.primary)),
                  Text(date, style: TxtStyle.outfit(fs: 11)),
                ],
              ),
            ],
          ),

          Gap(itemGap),

          Text(sessionTitle.capEachWord(), style: TxtStyle.urbanistSmTitle600),

          Text(description, style: TxtStyle.outfit(fs: 13, color: c.secondary)),
          isFromUpcomgScreen == true ? Gap(itemGap) : Spacer(),

          Row(
            children: [
              ContainerBordered(
                hasBrdr: true,
                brdrClr: c.primary,
                rad: 30,
                contClr: ctransp,
                hp: 12,
                vp: 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgIcon(iconPath: IconsPath.share),
                    Gap(itemGap),
                    Text(
                      Strings.share.cap,
                      textAlign: TextAlign.center,
                      style: TxtStyle.outfitSmTitle,
                    ),
                  ],
                ),
              ),
              Gap(itemGap),
              CusGestureDetector(
                onTap: () => Get.toNamed(RoutePaths.meetingScreen, arguments: channelName),
                child: ContainerBordered(
                  contClr: c.buttonPrimary,
                  rad: 30,
                  vp: 8,
                  hp: 18,
                  child: Row(
                    children: [
                      SvgIcon(iconPath: IconsPath.reminderBellSkew),
                      Gap(itemGap),
                      Text(
                        Strings.remindMe.capEachWord(),
                        textAlign: TextAlign.center,
                        style: TxtStyle.outfitSemiB(fs: 13, w: 600, color: c.textOnPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(itemGap),
              Expanded(
                child: CusGestureDetector(
                  onTap: () => showAskYourQuesDialog(
                    onTap: () => onTapQues(expertId: expertId_, sessionId: sessionId_),
                    isSendQuesLoading: isSendQuesLoading,
                    writeQuesCtrl: writeQuesCtrl,
                    writeQuesFocusNode: writeQuesFocusNode,
                  ),
                  child: ContainerBordered(
                    contClr: c.buttonPrimary,
                    rad: 30,
                    vp: 8,
                    // hp: 4,
                    child: SvgIcon(iconPath: IconsPath.chatDotSquare, height: 21),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
