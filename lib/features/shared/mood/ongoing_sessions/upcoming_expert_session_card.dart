import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:we_mama/core/components/ui/dialogs/popups.dart';
import 'package:we_mama/core/components/ui/helpers/shapes/custom_divider.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/helpers/session_time_helper.dart';
import '../../../../core/utils/share_util/share_util.dart';
import '../../../main_tabs/experts/model/expert_session_list_model.dart';
import '../../subscription/subscription_access/premium_access_service.dart';

class UpcomingExpertSessionCard extends StatelessWidget {
  final void Function({required String expertId, required String sessionId})
  onTapQues;
  final RxBool isSendQuesLoading;

  final TextEditingController writeQuesCtrl;
  final FocusNode writeQuesFocusNode;
  final Session? data;
  final bool? isFromUpcomgScreen;
  final bool hasTypetitle;
  final void Function()? onTapRemindMe;
  final bool Function() isReminderActive; // 👈 was: bool
  final bool Function() isRemindMeLoading; // 👈 was: RxBool
  const UpcomingExpertSessionCard({
    super.key,
    required this.onTapQues,
    required this.writeQuesCtrl,
    required this.writeQuesFocusNode,
    this.data,
    this.isFromUpcomgScreen,
    required this.isSendQuesLoading,
    this.hasTypetitle = false,
    this.onTapRemindMe,
    required this.isReminderActive,
    required this.isRemindMeLoading,
  });

  @override
  Widget build(BuildContext context) {
    final doctorName = (data?.expert?.name ?? "Unknown").capEachWord();
    final specialty = (data?.expert?.profession?.title ?? "Specialist")
        .capEachWord();
    final sessionTitle = (data?.title ?? "Session").capEachWord();
    final description = (data?.description ?? "").cap;

    final hostTimeZone = data?.timezone ?? '';
    final imgUrl = data?.expert?.image ?? '';
    final channelName = data?.channelName ?? '';

    final expertId_ = data?.expert?.id ?? '';
    final sessionId_ = data?.id ?? '';

    final sessionDateTime = data?.dateTime?.toIso8601String();

    ///
    //     final time = DateHelper()
    //     .formatUTCtimestamp(data?.dateTime.toString())
    //     .time;
    // final date = DateHelper()
    //     .formatUTCtimestamp(data?.dateTime.toString())
    //     .date;

    final time = SessionTimeHelper.time(
      dateTime: data?.dateTime?.toIso8601String(),
      hostTimezone: hostTimeZone,
    );

    final date = SessionTimeHelper.date(
      dateTime: data?.dateTime?.toIso8601String(),
      hostTimezone: hostTimeZone,
    );

    print('hostTimeZone: $hostTimeZone');
    tzdata.initializeTimeZones();

    final deviceTimezone = tz.local.name;

    print('🌍 Device timezone: $deviceTimezone');
    print('🕐 Device local time: ${tz.TZDateTime.now(tz.local)}');
    print('🌐 Device UTC time: ${DateTime.now().toUtc()}');
    print('converted time: $time');
    print('converted date: $date');

    //
    final premium = PremiumAccessService.to;
    final isPremium = true ?? premium.isReady.value && premium.isPremiumUserNow;

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
          if (hasTypetitle == true) _makeSessionTypeTitle(),
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
                      style: TxtStyle.urbanistSemiB(
                        fs: 17,
                        w: 600,
                        color: c.foregroundSecondary,
                      ),
                    ),
                    Text(
                      specialty,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TxtStyle.outfitSemiB(
                        fs: 13,
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
                      fs: 11,
                      w: 600,
                      color: c.foregroundSecondary,
                    ),
                  ),
                  Text(
                    date,
                    style: TxtStyle.outfit(
                      fs: 11,
                      color: c.foregroundSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Gap(itemGap),

          // Text(sessionTitle.capEachWord(), style: TxtStyle.urbanistSmTitle),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: 4,
                height: 28,
                decoration: BoxDecoration(
                  color: c.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  // "ahsugdhasgdagsd asgd asdyh gasudg asudgas dguyas dgyagdaasdu yuasdg uyasg duyagsduyagsdgasd" ??
                  sessionTitle.capEachWord(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TxtStyle.outfitSemiB(
                    fs: 16,
                    w: 600,
                    color: c.foregroundPrimary,
                  ),
                ),
              ),
            ],
          ),

          Text(
            // "ahsugdhasgdagsd asgd asdyh gasudg asudgas dguyas dgyagdaasdu yuasdg uyasg duyagsduyagsdgasd" ??
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TxtStyle.outfit(fs: 14, color: c.strokePrimary),
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
              DeviceSize.isTablet
                  ? makeShareButton()
                  : Flexible(child: makeShareButton()),

              Gap(itemGap),

              DeviceSize.isTablet
                  ? makeReminderButton()
                  : Flexible(child: makeReminderButton()),

              Gap(itemGap),

              if (isPremium) // ← Only show if premium
                CusGestureDetector(
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
                    vp: 0,
                    h: actionBtnHeight,
                    w: actionBtnHeight,
                    child: SvgIcon(
                      iconPath: IconsPath.chatDotSquare,
                      height: 21,
                    ),
                  ),
                )
              else
                // ❌ Not premium → show upgrade prompt
                CusGestureDetector(
                  onTap: () => Get.toNamed(RoutePaths.subscriptionUpgrade),
                  child: ContainerBordered(
                    contClr: const Color(0xFFC7A99C), // disabled state
                    rad: 30,
                    vp: 0,
                    h: actionBtnHeight,
                    w: actionBtnHeight,
                    child: SvgIconColored(
                      iconColor: const Color(0xFFF7EFEC),
                      iconPath: IconsPath.chatDotSquare,
                      height: 21,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _makeSessionTypeTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.upcomingExpertSession.capEachWord(),
          style: TxtStyle.outfitSemiB(
            fs: 15,
            w: 600,
            color: c.foregroundSecondary,
          ),
        ),
        CustomDivider(isFullWidth: true, h: 0.6),
        Gap(itemGap),
      ],
    );
  }

  Widget makeReminderButton() {
    final ispre = true.obs;
    return Obx(() {
      final premium = PremiumAccessService.to;

      final isPremium =
          ispre.value ?? premium.isReady.value && premium.isPremiumUserNow;
      final active = isReminderActive(); // 👈 call it, don't just reference
      final loading = isRemindMeLoading();

      return CusGestureDetector(
        onTap: isPremium
            ? onTapRemindMe
            : () => Get.toNamed(RoutePaths.subscriptionUpgrade),
        child: ContainerBordered(
          // contClr: active ? c.strokePrimary : c.buttonPrimary,
          contClr: !isPremium ? const Color(0xFFC7A99C) : c.buttonPrimary,

          rad: 30,
          vp: 0,
          h: actionBtnHeight,
          alignment: Alignment.center,

          child: loading
              ? LoadingWhite()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgIcon(
                      iconPath: active
                          ? IconsPath.reminderBellStraignt
                          : IconsPath.reminderBellSkew,
                    ),

                    Gap(itemGap),

                    Flexible(
                      child: Text(
                        active ? "Remove" : Strings.remindMe.capEachWord(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TxtStyle.outfitSemiB(
                          fs: 13,
                          w: 600,
                          color: active ? bgClr : c.textOnPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  Widget makeShareButton() {
    return CusGestureDetector(
      // <-- wrap existing ContainerBordered
      onTap: () => ShareService.shareSession(data!),
      child: ContainerBordered(
        hasBrdr: true,
        brdrClr: c.strokePrimary,
        brdrW: 1,
        rad: 30,
        contClr: ctransp,
        hp: 12,
        vp: 0,
        h: actionBtnHeight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgIcon(iconPath: IconsPath.share),
            Gap(itemGap),
            Flexible(
              child: Text(
                Strings.share.cap,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TxtStyle.outfitSemiB(
                  fs: 14,
                  color: c.strokePrimary,
                  w: 500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
