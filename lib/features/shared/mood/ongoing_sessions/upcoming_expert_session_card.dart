import 'package:mama_app/core/components/ui/dialogs/popups.dart';
import 'package:mama_app/core/components/ui/helpers/shapes/custom_divider.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/helpers/date_helper.dart';
import '../../../../core/utils/share_util/share_util.dart';
import '../../../main_tabs/experts/model/expert_session_list_model.dart';

class UpcomingExpertSessionCard extends StatelessWidget {
  final void Function({required String expertId, required String sessionId})
  onTapQues;
  final RxBool isSendQuesLoading;
  final TextEditingController writeQuesCtrl;
  final FocusNode writeQuesFocusNode;
  final Session? data;
  final bool? isFromUpcomgScreen;
  const UpcomingExpertSessionCard({
    super.key,
    required this.onTapQues,
    required this.writeQuesCtrl,
    required this.writeQuesFocusNode,
    this.data,
    this.isFromUpcomgScreen,
    required this.isSendQuesLoading,
  });

  @override
  Widget build(BuildContext context) {
    final doctorName = (data?.expert?.name ?? "Unknown").capEachWord();
    final specialty = (data?.expert?.profession?.title ?? "Specialist")
        .capEachWord();
    final sessionTitle = (data?.title ?? "Session").capEachWord();
    final description = (data?.description ?? "").cap;
    final time = DateHelper().formatUTCtimestamp(data?.time.toString()).time;
    final date = DateHelper().formatUTCtimestamp(data?.date.toString()).date;

    final imgUrl = data?.expert?.image ?? '';
    final channelName = data?.channelName ?? '';

    final expertId_ = data?.expert?.id ?? '';
    final sessionId_ = data?.id ?? '';

    return ContainerBordered(
      contClr: newCardClr,
      rad: 20,
      hp: 16,
      vp: 16,
      boxShadow: boxShadowBottom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isFromUpcomgScreen == true
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Strings.upcomingExpertSession.capEachWord(),
            style: TxtStyle.outfitSemiB(
              fs: 14,
              w: 600,
              color: c.foregroundSecondary,
            ),
          ),
          CustomDivider(isFullWidth: true, h: 0.6),
          Gap(itemGap),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              circledNetworkImageBgComponent(
                imagePath: imgUrl,
                radius: 22,
                isUser: true,
                name: doctorName,
              ),
              Gap(itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      doctorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TxtStyle.urbanistSmTitle,
                    ),
                    Text(
                      specialty,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TxtStyle.outfitSemiB(
                        fs: 12,
                        w: 500,
                        color: c.strokePrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(itemGap * 3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Gap(itemGap),
                  Text(
                    time,
                    style: TxtStyle.outfitSemiB(
                      fs: 10,
                      w: 600,
                      color: c.foregroundSecondary,
                    ),
                  ),
                  Text(
                    date,
                    style: TxtStyle.outfit(
                      fs: 10,
                      color: c.foregroundSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Gap(itemGap),

          Text(sessionTitle.capEachWord(), style: TxtStyle.urbanistSmTitle),

          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TxtStyle.outfit(fs: 13, color: c.strokePrimary),
          ),
          // isFromUpcomgScreen == true ? Gap(itemGap * 2) : Spacer(),
          isFromUpcomgScreen == true
              ? Gap(itemGap)
              :
                //
                // Spacer(),
                const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CusGestureDetector(
                // <-- wrap existing ContainerBordered
                onTap: () => ShareService.shareSession(data!),
                child: ContainerBordered(
                  hasBrdr: true,
                  brdrClr: c.strokePrimary,
                  brdrW: 1,
                  rad: 30,
                  contClr: ctransp,
                  hp: 12,
                  vp: 7,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgIcon(iconPath: IconsPath.share),
                      Gap(itemGap),
                      Text(
                        Strings.share.cap,
                        style: TxtStyle.outfitSemiB(
                          fs: 14,
                          color: c.strokePrimary,
                          w: 500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Gap(itemGap),

              Flexible(
                child: ContainerBordered(
                  contClr: c.buttonPrimary,
                  rad: 30,
                  vp: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgIcon(iconPath: IconsPath.reminderBellSkew),
                      Gap(itemGap),
                      Flexible(
                        child: Text(
                          Strings.remindMe.capEachWord(),
                          overflow: TextOverflow.ellipsis,
                          style: TxtStyle.outfitSemiB(
                            fs: 13,
                            w: 600,
                            color: c.textOnPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Gap(itemGap),

              // if (isFromUpcomgScreen != null)
              Container(
                child: CusGestureDetector(
                  onTap: () => showAskYourQuesDialog(
                    onTap: () =>
                        onTapQues(expertId: expertId_, sessionId: sessionId_),
                    isSendQuesLoading: isSendQuesLoading,
                    writeQuesCtrl: writeQuesCtrl,
                    writeQuesFocusNode: writeQuesFocusNode,
                  ),
                  child: ContainerBordered(
                    contClr: c.buttonPrimary,
                    rad: 30,
                    vp: 8,
                    child: SvgIcon(
                      iconPath: IconsPath.chatDotSquare,
                      height: 21,
                    ),
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
