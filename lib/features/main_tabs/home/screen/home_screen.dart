import 'package:flutter/foundation.dart';
import 'package:we_mama/core/components/ui/layout/home_app_bar_content.dart';
import 'package:we_mama/features/main_tabs/experts/controller/experts_controller.dart';
import 'package:we_mama/features/shared/community_spotlight/community_spotlight.dart';
import 'package:we_mama/features/shared/mood/ongoing_sessions/upcoming_expert_session_card.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../core/helpers/string_helper.dart';
import '../../../../core/services/deep_link/session_navigator.dart';
import '../../../main_nav/controller/main_nav_controller.dart';
import '../../../shared/mood/mood_check_in/mood_chip_card.dart';
import '../../../shared/mood/mood_check_in/mood_greeting.dart';
import '../../../shared/mood/mood_library/widgets/mood_library_chip_card.dart';
import '../../../shared/mood/ongoing_sessions/live_ongoing_expert_session_card.dart';
import '../../../shared/subscription/subscription_access/premium_access_service.dart';
import '../../../shared/subscription/subscription_access/premium_gate.dart';
import '../controller/home_controller.dart';
import '../modules/gentle_reminder_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // static void showLocationStatusOverlay({required bool isActive}) {
  //   print("🪟 showLocationStatusOverlay called — isActive: $isActive");
  //   print("🪟 Get.context: ${Get.context}");
  //   print("🪟 isDialogOpen: ${Get.isDialogOpen}");

  //   if (Get.isDialogOpen ?? false) Get.back();

  //   Get.dialog(
  //     LocationStatusOverlay(isActive: isActive),
  //     barrierDismissible: true,
  //     barrierColor: Colors.black.withOpacity(0.35),
  //   );
  // }

  // static void triggerPermissionFlow() {
  //   print("🔑 triggerPermissionFlow called");
  //   Get.find<HomeController>().runLocationPermissionFlow();
  // }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    print("🏠 HomeScreen initState");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("🏠 HomeScreen postFrameCallback — notifying MainNavController");
      MainNavController.to.notifyHomeFirstBuild();

      final premiumService = PremiumAccessService.to;

      print('\n╔════════════════════════════════════════╗');
      print('║ [SessionNavigator.openMeeting] START    ║');
      print('╚════════════════════════════════════════╝');

      // ✅ Print current state
      premiumService.printFullState();

      // ✅ Wait for service to be ready
      if (!premiumService.isReady.value) {
        print('⏳ [SessionNavigator.openMeeting] Service NOT ready, waiting...');

        int attempts = 0;
        while (!premiumService.isReady.value && attempts < 50) {
          await Future.delayed(const Duration(milliseconds: 100));
          attempts++;
        }

        print('⏳ [SessionNavigator.openMeeting] Waited $attempts attempts');

        if (!premiumService.isReady.value) {
          print(
            '🔴 [SessionNavigator.openMeeting] Service initialization TIMEOUT',
          );
          premiumService.printFullState();
        }

        print('✅ [SessionNavigator.openMeeting] Service now READY');
        premiumService.printFullState();
      } else {
        print('✅ [SessionNavigator.openMeeting] Service already READY');
      }

      // ✅ Check if premium
      print('\n🔐 [SessionNavigator.openMeeting] Premium check:');
      print('   isPremiumUserNow: ${premiumService.isPremiumUserNow}');
      print('   isPremiumUser.value: ${premiumService.isPremiumUser.value}');

      if (!premiumService.isPremiumUserNow) {
        print('🔒 [SessionNavigator.openMeeting] ❌ User is NOT premium');
        premiumService.printFullState();
      }

      print(
        '✅ [SessionNavigator.openMeeting] ✅ User IS premium - opening meeting!',
      );
      premiumService.printFullState();
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
        spacing: itemGap * 1.5,
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
              child: Text("Sub Success page"),
            ),
            TextButton(
              onPressed: () => Get.toNamed(RoutePaths.onboardScreen),
              child: Text("Sub onboardScreen page"),
            ),
          ],

          if (kDebugMode) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: debugTestPremiumIOS,
                  icon: const Icon(Icons.workspace_premium),
                  label: const Text('TEST: Premium Status'),
                ),

                const SizedBox(height: 10),

                ElevatedButton.icon(
                  onPressed: debugTestWaveCount,
                  icon: const Icon(Icons.waves),
                  label: const Text('TEST: Wave Count'),
                ),

                const SizedBox(height: 10),

                ElevatedButton.icon(
                  onPressed: debugTestSessionJoin,
                  icon: const Icon(Icons.video_call),
                  label: const Text('TEST: Session Join'),
                ),
              ],
            ),
          ],

          if ((kDebugMode && GetPlatform.isAndroid) ||
              (!kDebugMode && GetPlatform.isAndroid))
            GestureDetector(
              onTap: () => PremiumAccessService.to.debugSetFakePremium(
                !PremiumAccessService.to.isFakePremiumActive,
              ),
              child: Obx(
                () => Text(
                  'isFakePremiumActive-->${PremiumAccessService.to.isFakePremiumActive}',
                ),
              ),
              // hidden dev trigger on app version label
            ),

          PremiumGate(
            child: MoodCheckInCard(mcc: hc.mcc),
            lockedBuilder: (_) => Column(
              children: [
                MoodGreeting(),
                Gap(6.h),
                MoodLibraryChipCard(
                  moodDataList: ExpertsController.to.moodDataList,
                  onTapSubscribe: () =>
                      Get.toNamed(RoutePaths.subscriptionUpgrade),
                ),
              ],
            ),
          ),

          GentleReminderCard(),
          CommunitySpotlight(),

          //
          if (kDebugMode) ...[
            Obx(() {
              final sessions = hc.spotLightData.value?.liveSession ?? [];
              final liveSession = sessions.firstWhereOrNull(
                (e) => (e.status ?? '').toLowerCase() == "ongoing",
              );

              if (liveSession != null) {
                return SizedBox(
                  height: Responsive.ongoingSessionCardHeight + (20.h),
                  child: LiveOngoingSessionCard(data: liveSession),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],

          //
          //
          // if none, show: no live session available right now
          Obx(() {
            final sessions = hc.spotLightData.value?.liveSession ?? [];

            final isLoading = hc.isSpotLightLoading_.value;
            final state = getUIStateDetail(isLoading: isLoading);

            return UIStateHandler(
              state: state,

              loading: () => SizedBox(
                height: S.h * 0.25,
                child: const LiveOngoingSessionCardShimmer(),
              ),

              data: () {
                // 1️⃣ Find upcoming first
                final upcomingSession = sessions.firstWhereOrNull(
                  (e) => (e.status ?? '').toLowerCase() == "upcoming",
                );

                if (upcomingSession != null) {
                  final actionCtrl = hc.actionCtrl;

                  return UpcomingExpertSessionCard(
                    isRemindMeLoading: () =>
                        actionCtrl.isReminderLoading(upcomingSession.id),

                    isReminderActive: () =>
                        actionCtrl.isReminderSet(upcomingSession.id),

                    onTapRemindMe: () {
                      actionCtrl.toggleReminder(sessionId: upcomingSession.id);
                    },

                    hasTypetitle: true,
                    data: upcomingSession,
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
                }

                // 2️⃣ Then check live
                final liveSession = sessions.firstWhereOrNull(
                  (e) => (e.status ?? '').toLowerCase() == "ongoing",
                );

                if (liveSession != null) {
                  final isOverflowing = willTextOverflow(
                    text: liveSession.description,
                    style: TxtStyle.outfit(fs: 14, color: c.strokePrimary),
                  );
                  return SizedBox(
                    height:
                        Responsive.ongoingSessionCardHeight +
                        (isOverflowing ? 40.h : 30.h),
                    child: LiveOngoingSessionCard(data: liveSession),
                  );

                  // PremiumGate(
                  //   child: SizedBox(
                  //     height:
                  //         Responsive.ongoingSessionCardHeight +
                  //         (isOverflowing ? 40.h : 30.h),
                  //     child: LiveOngoingSessionCard(data: liveSession),
                  //   ),

                  //   lockedBuilder: (_) => LiveSessionLockedCard(
                  //     onTap: () => Get.toNamed(RoutePaths.subscriptionUpgrade),
                  //   ),
                  // );
                }

                // 3️⃣ No live + no upcoming
                return NoSessionPlaceholder();
              },
            );
          }),
        ],
      ).getcm,
    );
  }
}

class NoSessionPlaceholder extends StatelessWidget {
  const NoSessionPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      hp: 10,
      vp: 10,
      contClr: cardBgDeep,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 32.r,
                width: 32.r,
                decoration: BoxDecoration(
                  color: c.primary.withOpacity(.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 17.r,
                  color: c.primary,
                ),
              ),

              Gap(10),

              Expanded(
                child: Text(
                  "New sessions are coming soon ✴︎",
                  style: TxtStyle.urbanistSemiB(
                    w: 600,
                    fs: 16,
                    color: c.foregroundPrimary,
                  ),
                ),
              ),
            ],
          ),

          Gap(8),

          Text(
            "We're preparing expert guidance to support "
            "your motherhood journey.",
            style: TxtStyle.urbanist(
              fs: 13,
              w: 500,
              color: c.foregroundSecondary,
            ),
          ),

          Gap(10),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: c.primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Stay tuned for what's next ♡",
              style: TxtStyle.urbanistSemiB(fs: 13, w: 600, color: c.primary),
            ),
          ),
        ],
      ),
    );
  }
}
