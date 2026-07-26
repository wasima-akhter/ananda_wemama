import 'package:flutter/foundation.dart';
import 'package:mama_app/core/components/ui/layout/home_app_bar_content.dart';
import 'package:mama_app/features/main_tabs/experts/controller/experts_controller.dart';
import 'package:mama_app/features/shared/community_spotlight/community_spotlight.dart';
import 'package:mama_app/features/shared/mood/ongoing_sessions/upcoming_expert_session_card.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../core/network/helpers/location/location_status_overlay.dart';
import '../../../main_nav/controller/main_nav_controller.dart';
import '../../../shared/mood/mood_check_in/mood_chip_card.dart';
import '../../../shared/mood/mood_check_in/mood_greeting.dart';
import '../../../shared/mood/mood_library/widgets/mood_library_chip_card.dart';
import '../../../shared/mood/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../../../shared/subscription/subscription_access/premium_access_service.dart';
import '../../../shared/subscription/subscription_access/premium_gate.dart';
import '../../experts/widgets/live_session_lock_card.dart';
import '../controller/home_controller.dart';
import '../modules/gentle_reminder_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static void showLocationStatusOverlay({required bool isActive}) {
    log("🪟 showLocationStatusOverlay called — isActive: $isActive");
    log("🪟 Get.context: ${Get.context}");
    log("🪟 isDialogOpen: ${Get.isDialogOpen}");

    if (Get.isDialogOpen ?? false) Get.back();

    Get.dialog(
      LocationStatusOverlay(isActive: isActive),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
    );
  }

  static void triggerPermissionFlow() {
    log("🔑 triggerPermissionFlow called");
    Get.find<HomeController>().runLocationPermissionFlow();
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    log("🏠 HomeScreen initState");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("🏠 HomeScreen postFrameCallback — notifying MainNavController");
      MainNavController.to.notifyHomeFirstBuild();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hc = Get.find<HomeController>();

    return AppScreenTemplate(
      onRefresh: () async {
        hc.getCommunitySpotLight();
        hc.getGentleRemindData();
      },
      appBar: HomeAppBarContent(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: itemGap * 1.2,
        children: [
          if (kDebugMode || !kDebugMode) ...[
            TextButton(
              onPressed: () => Get.toNamed(RoutePaths.foundingMumCodeScreen),
              child: Text("Sub founding mum page"),
            ),
            TextButton(
              onPressed: () => Get.toNamed(RoutePaths.promoCodeScreen),
              child: Text("Sub promo page"),
            ),
            TextButton(
              onPressed: () => Get.toNamed(RoutePaths.subChoosePlan),
              child: Text("Sub Choose page"),
            ),
            TextButton(
              onPressed: () => Get.toNamed(RoutePaths.promoCodeScreen),
              child: Text("Sub upgrade page"),
            ),
            TextButton(
              onPressed: () => Get.toNamed(RoutePaths.subscriptionSuccess),
              child: Text("Sub subscriptionSuccess page"),
            ),
          ],

          if (kDebugMode)
            GestureDetector(
              onTap: () => PremiumAccessService.to.debugSetFakePremium(
                !PremiumAccessService.to.isFakePremiumActive,
              ),
              child: Obx(
                () => Text('-->${PremiumAccessService.to.isFakePremiumActive}'),
              ), // hidden dev trigger on app version label
            ),

          PremiumGate(
            child: MoodCheckInCard(mcc: hc.mcc),
            lockedBuilder: (_) => Column(
              children: [
                MoodGreeting(),
                Gap(6.h),
                MoodLibraryChipCard(
                  moodDataList: ExpertsController.to.moodDataList,
                  onTapSubscribe: () => Get.toNamed(RoutePaths.promoCodeScreen),
                ),
              ],
            ),
          ),

          GentleReminderCard(),
          CommunitySpotlight(),
          // if none, show: no live session available right now
          /*
          Obx(() {
            final liveSessionData = hc.spotLightData.value?.liveSession;

            final isLoading = hc.isSpotLightLoading_.value;
            final state = getUIStateDetail(isLoading: isLoading);

            if (liveSessionData == null || liveSessionData.isEmpty) {
              return NoLiveSessionCard();
            }

            final firstSession = liveSessionData.first;
            final status = firstSession.status;
            final isLive = (status ?? '').toLowerCase() == "ongoing";

            return SizedBox(
              child: UIStateHandler(
                loading: () => SizedBox(
                  height: S.h * 0.25,
                  child: const LiveOngoingSessionCardShimmer(),
                ),
                state: state,
                data: () {
                  if (isLive) {
                    return SizedBox(
                      height: S.h * 0.25,
                      child: LiveOngoingSessionCard(data: firstSession),
                    );
                  }

                  final actionCtrl = hc.actionCtrl;

                  return UpcomingExpertSessionCard(
                    isRemindMeLoading: () =>
                        actionCtrl.isReminderLoading(firstSession.id),
                    isReminderActive: () =>
                        actionCtrl.isReminderSet(firstSession.id),
                    onTapRemindMe: () {
                      actionCtrl.toggleReminder(sessionId: firstSession.id);
                    },
                    hasTypetitle: true,
                    data: firstSession,
                    writeQuesCtrl: hc.writeQuesCtrl,
                    writeQuesFocusNode: hc.writeQuesFocusNode,
                    isSendQuesLoading: actionCtrl.isSendQuesLoading,

                    onTapQues:
                        ({
                          required String expertId,
                          required String sessionId,
                        }) async {
                          final res = await actionCtrl.uploadSessionQues(
                            expertId: expertId,
                            sessionId: sessionId,
                            question: hc.writeQuesCtrl.text.trim(),
                          );

                          if (res == true) {
                            hc.unfocusAll();
                          }
                        },
                  );
                },
              ),
            );
          }),
       */
          Obx(() {
            final liveSessionData = hc.spotLightData.value?.liveSession ?? [];

            final isLoading = hc.isSpotLightLoading_.value;
            final state = getUIStateDetail(isLoading: isLoading);

            if (liveSessionData.isEmpty) {
              return NoLiveSessionCard();
            }

            final firstSession = liveSessionData.first;
            final status = firstSession.status;
            final isLive = (status ?? '').toLowerCase() == "ongoing";

            return SizedBox(
              child: UIStateHandler(
                loading: () => SizedBox(
                  height: S.h * 0.25,
                  child: const LiveOngoingSessionCardShimmer(),
                ),
                state: state,
                data: () {
                  if (isLive) {
                    // Gate only applies here: live session + non-premium.
                    return SizedBox(
                      //
                      child: PremiumGate(
                        child: SizedBox(
                          height: S.h * 0.25,
                          child: LiveOngoingSessionCard(data: firstSession),
                        ),
                        lockedBuilder: (_) => LiveSessionLockedCard(
                          onTap: () => Get.toNamed(RoutePaths.promoCodeScreen),
                        ),
                      ),
                    );
                  }

                  // Upcoming sessions always show, premium or not.
                  final actionCtrl = hc.actionCtrl;

                  return UpcomingExpertSessionCard(
                    isRemindMeLoading: () =>
                        actionCtrl.isReminderLoading(firstSession.id),
                    isReminderActive: () =>
                        actionCtrl.isReminderSet(firstSession.id),
                    onTapRemindMe: () {
                      actionCtrl.toggleReminder(sessionId: firstSession.id);
                    },
                    hasTypetitle: true,
                    data: firstSession,
                    writeQuesCtrl: hc.writeQuesCtrl,
                    writeQuesFocusNode: hc.writeQuesFocusNode,
                    isSendQuesLoading: actionCtrl.isSendQuesLoading,

                    onTapQues:
                        ({
                          required String expertId,
                          required String sessionId,
                        }) async {
                          final res = await actionCtrl.uploadSessionQues(
                            expertId: expertId,
                            sessionId: sessionId,
                            question: hc.writeQuesCtrl.text.trim(),
                          );

                          if (res == true) {
                            hc.unfocusAll();
                          }
                        },
                  );
                },
              ),
            );
          }),
        ],
      ).getcm,
    );
  }
}
