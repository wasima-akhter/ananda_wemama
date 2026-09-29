// main.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:we_mama/app/helper_widgets_export.dart';

import 'app/app.dart';
import 'core/local/app_storage.dart';
import 'core/network/network_manager.dart';
import 'core/services/deep_link/app_link_service.dart';
import 'core/services/firebase/firebase_service.dart';
import 'core/services/location/location_service.dart';
import 'core/services/push_notification/controller/notification_count_controller.dart';
import 'core/services/push_notification/controller/push_notification_controller.dart';
import 'core/services/push_notification/firebase_token_service.dart';
import 'core/services/push_notification/push_notification_service.dart';
import 'core/themes/theme_service.dart';
import 'features/shared/subscription/subscription_access/premium_access_service.dart';
import 'features/shared/subscription/subscription_upgrade/service/purchase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('🚀 [main] Flutter binding initialized');

  // ── Orientation + status bar ─────────────────────────────────────────────────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  print('✅ [main] orientation + status bar configured');

  // ── Timezone database ─────────────────────────────────────────────────────
  tzdata.initializeTimeZones();
  print('🌍 [main] timezone database initialized');

  print('🚀 [main] Flutter binding initialized');

  // ── 1. Firebase ──────────────────────────────────────────────────────────────
  print('🔧 [main] initializing Firebase...');
  try {
    await FirebaseInitializer.init();
    print('✅ [main] Firebase initialized');
  } catch (e, st) {
    print('❌ [main] Firebase initialization FAILED: $e');
    print('$st');
    // Firebase is critical — rethrow so the error is visible in crash tools
    rethrow;
  }

  // ── 2. FCM background handler ────────────────────────────────────────────────
  // Must be registered right after Firebase.initializeApp() and before runApp()
  FirebaseMessaging.onBackgroundMessage(onFcmBackgroundMessage);
  print('✅ [main] FCM background handler registered');

  // ── 3. Storage ───────────────────────────────────────────────────────────────
  print('🔧 [main] initializing AppStorage...');
  await Get.putAsync<AppStorage>(() async => AppStorage.init());
  print('✅ [main] AppStorage ready');

  //
  // ── 3.5 PurchaseService ───────────────────────────────────────────────
  print('🔧 [main] initializing PurchaseService...');
  try {
    await Get.putAsync<PurchaseService>(
      () async => await PurchaseService().init(),
      permanent: true,
    );
    print('✅ [main] PurchaseService ready');
  } catch (e, st) {
    print('❌ [main] PurchaseService init FAILED: $e');
    print('$st');
  }

  // ── 3.6 PremiumAccessService ───────────────────────────────────────────
  print('🔧 [main] initializing PremiumAccessService...');
  Get.put(PremiumAccessService(), permanent: true);
  print('✅ [main] PremiumAccessService registered');

  // ── 3.7 ✅ REFRESH PREMIUM STATUS (iOS critical!) ─────────────────────
  print('🔧 [main] refreshing premium status...');
  try {
    final premiumService = PremiumAccessService.to;
    await premiumService.refreshPremiumStatus();
    print(
      '✅ [main] Premium status refreshed: ${premiumService.isPremiumUserNow}',
    );
  } catch (e, st) {
    print('❌ [main] Premium refresh FAILED: $e');
    print('$st');
  }

  // ── 4. Deep link ─────────────────────────────────────────────────────────────
  print('🔧 [main] capturing initial deep link...');
  final deepLinkService = DeepLinkService();
  await deepLinkService.captureInitialLink();
  Get.put(deepLinkService, permanent: true);
  print('✅ [main] DeepLinkService ready');

  // ── 5. UI + location services ────────────────────────────────────────────────
  Get.put(ThemeController(), permanent: true);
  print('✅ [main] ThemeController registered');
  Get.put(LocationService(), permanent: true);
  print('✅ [main] LocationService registered');

  // ── 5.1 Device timezone ─────────────────────────────────────────────────────
  print('🌍 [main] detecting device timezone...');

  try {
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();

    print('🌍 [main] device timezone: $timezoneInfo');
  } catch (e, st) {
    print('❌ [main] timezone detection FAILED: $e');
    print('$st');
  }

  // ── 6. FirebaseTokenService — MUST be before PushNotificationService ─────────
  print('🔧 [main] registering FirebaseTokenService...');
  Get.put(FirebaseTokenService(), permanent: true);
  print('✅ [main] FirebaseTokenService registered');

  // ── 7. PushNotificationService ───────────────────────────────────────────────
  print('🔧 [main] initializing PushNotificationService...');
  try {
    await Get.putAsync<PushNotificationService>(
      () async => PushNotificationService().init(),
      permanent: true,
    );
    print('✅ [main] PushNotificationService ready');
  } catch (e, st) {
    // Non-fatal: app can still run without push notifications
    print('❌ [main] PushNotificationService init FAILED: $e');
    print('$st');
  }
  // ── 7.2  NotificationCount Controller ───────────────────────────────────────────────
  print('🔧 [main] initializing NotificationCount Controller...');
  try {
    Get.put(NotificationCountController(), permanent: true);
    print('✅ [main] NotificationCount Controller ready');
  } catch (e, st) {
    // Non-fatal: app can still run without push notifications
    print('❌ [main] NotificationCount Controller init FAILED: $e');
    print('$st');
  }

  // ── 8. Network monitor + auto-retry ─────────────────────────────────────────
  print('🔧 [main] checking initial network state...');
  var hasNet_ = await NetworkManager().checkConnection();
  print('✅ [main] initial network state: $hasNet_');

  NetworkManager().networkStream().listen((isConnected) {
    if (isConnected == hasNet_) return;
    hasNet_ = isConnected;
    print('🌐 [main] network changed → connected: $isConnected');

    if (!isConnected) {
      if (Get.currentRoute != RoutePaths.offlineScreen) {
        Get.toNamed(RoutePaths.offlineScreen);
      }
    } else {
      if (Get.currentRoute == RoutePaths.offlineScreen) {
        if (!(Get.key.currentState?.canPop() ?? false)) {
          Get.offAllNamed(RoutePaths.splashScreen);
        } else {
          Get.close(1);
        }
      }

      // ✅ Network restored — silently retry any failed push setup steps
      print('🔄 [main] network restored → retrying failed push steps...');
      final pushService = Get.find<PushNotificationService>();
      pushService.retryFailedSteps();
    }
  });

  // main.dart — step 8 (after PushNotificationService)

  print('🔧 [main] registering NotificationController...');
  Get.put(PushNotificationController(), permanent: true);
  print('✅ [main] NotificationController registered');

  // ── 9. Run app ───────────────────────────────────────────────────────────────
  print('🚀 [main] calling runApp...');
  print('🔥🔥🔥 APP STARTED 🔥🔥🔥');
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => App(hasInternet: hasNet_),
    ),
  );
  print('✅ [main] runApp called');
}
