// main.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:mama_app/app/helper_widgets_export.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('🚀 [main] Flutter binding initialized');

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
  debugPrint('✅ [main] orientation + status bar configured');

  // ── 1. Firebase ──────────────────────────────────────────────────────────────
  debugPrint('🔧 [main] initializing Firebase...');
  try {
    await FirebaseInitializer.init();
    debugPrint('✅ [main] Firebase initialized');
  } catch (e, st) {
    debugPrint('❌ [main] Firebase initialization FAILED: $e');
    debugPrint('$st');
    // Firebase is critical — rethrow so the error is visible in crash tools
    rethrow;
  }

  // ── 2. FCM background handler ────────────────────────────────────────────────
  // Must be registered right after Firebase.initializeApp() and before runApp()
  FirebaseMessaging.onBackgroundMessage(onFcmBackgroundMessage);
  debugPrint('✅ [main] FCM background handler registered');

  // ── 3. Storage ───────────────────────────────────────────────────────────────
  debugPrint('🔧 [main] initializing AppStorage...');
  await Get.putAsync<AppStorage>(() async => AppStorage.init());
  debugPrint('✅ [main] AppStorage ready');

  // ── 4. Deep link ─────────────────────────────────────────────────────────────
  debugPrint('🔧 [main] capturing initial deep link...');
  final deepLinkService = DeepLinkService();
  await deepLinkService.captureInitialLink();
  Get.put(deepLinkService, permanent: true);
  debugPrint('✅ [main] DeepLinkService ready');

  // ── 5. UI + location services ────────────────────────────────────────────────
  Get.put(ThemeController(), permanent: true);
  debugPrint('✅ [main] ThemeController registered');
  Get.put(LocationService(), permanent: true);
  debugPrint('✅ [main] LocationService registered');

  // ── 6. FirebaseTokenService — MUST be before PushNotificationService ─────────
  debugPrint('🔧 [main] registering FirebaseTokenService...');
  Get.put(FirebaseTokenService(), permanent: true);
  debugPrint('✅ [main] FirebaseTokenService registered');

  // ── 7. PushNotificationService ───────────────────────────────────────────────
  debugPrint('🔧 [main] initializing PushNotificationService...');
  try {
    await Get.putAsync<PushNotificationService>(
      () async => PushNotificationService().init(),
      permanent: true,
    );
    debugPrint('✅ [main] PushNotificationService ready');
  } catch (e, st) {
    // Non-fatal: app can still run without push notifications
    debugPrint('❌ [main] PushNotificationService init FAILED: $e');
    debugPrint('$st');
  }
  // ── 7.2 PushNotificationService ───────────────────────────────────────────────
  debugPrint('🔧 [main] initializing NotificationCount Controller...');
  try {
    Get.put(NotificationCountController(), permanent: true);
    debugPrint('✅ [main] PushNotificationService ready');
  } catch (e, st) {
    // Non-fatal: app can still run without push notifications
    debugPrint('❌ [main] PushNotificationService init FAILED: $e');
    debugPrint('$st');
  }

  // ── 8. Network monitor + auto-retry ─────────────────────────────────────────
  debugPrint('🔧 [main] checking initial network state...');
  var hasNet_ = await NetworkManager().checkConnection();
  debugPrint('✅ [main] initial network state: $hasNet_');

  NetworkManager().networkStream().listen((isConnected) {
    if (isConnected == hasNet_) return;
    hasNet_ = isConnected;
    debugPrint('🌐 [main] network changed → connected: $isConnected');

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
      debugPrint('🔄 [main] network restored → retrying failed push steps...');
      final pushService = Get.find<PushNotificationService>();
      pushService.retryFailedSteps();
    }
  });

  // main.dart — step 8 (after PushNotificationService)

  debugPrint('🔧 [main] registering NotificationController...');
  Get.put(PushNotificationController(), permanent: true);
  debugPrint('✅ [main] NotificationController registered');

  // ── 9. Run app ───────────────────────────────────────────────────────────────
  debugPrint('🚀 [main] calling runApp...');
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => App(hasInternet: hasNet_),
    ),
  );
  debugPrint('✅ [main] runApp called');
}
