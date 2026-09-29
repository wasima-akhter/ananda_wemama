import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_mama/core/components/ui/loaders/loading.dart';
import 'package:we_mama/features/shared/report_sheet/controller/report_controller.dart';
import 'package:we_mama/routes/pages.dart';
import 'package:we_mama/routes/route_paths.dart';

import '../core/components/app_ui/components/user_detaIl_component/controller/user_detail_controller.dart';
import '../core/config/app_info.dart';
import '../core/network/helpers/network_helpers.dart';
import '../core/services/push_notification/controller/notification_count_controller.dart';
import '../core/services/push_notification/push_notification_service.dart';
import '../core/services/socket/socket_service.dart';
import '../core/utils/extension/binding_extensions.dart';

class App extends StatefulWidget {
  final bool hasInternet;
  const App({super.key, required this.hasInternet});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();

    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        print('📱 [App] app resumed');

        // ✅ refresh notification counts from storage on every resume
        NotificationCountController.to.refreshFromStorage();

        if (Get.isRegistered<PushNotificationService>()) {
          final push = Get.find<PushNotificationService>();
          final loggedIn = storage.getLoggedIn;

          if (loggedIn) {
            print('🔄 [App] user logged in — retrying failed push steps...');
            push.retryFailedSteps();
          } else {
            print('ℹ️ [App] user not logged in — skipping FCM token retry');
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  //
  Future<String> getInitialRoute() async {
    return widget.hasInternet
        ? RoutePaths.splashScreen
        : RoutePaths.offlineScreen;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getInitialRoute(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: LoadingPrimary())),
          );
        }

        return DevicePreview(
          enabled: false ?? kDebugMode,
          builder: (context) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: snapshot.data!,
              title: appName,
              theme: ThemeData.light(useMaterial3: true),
              darkTheme: ThemeData.dark(useMaterial3: true),
              themeMode: ThemeMode.light,

              getPages: RoutePageList.appPages,

              // ✅ Safe unknownRoute: silently pops or falls back to signin
              // instead of showing a broken /notFound screen
              unknownRoute: GetPage(
                name: '/notFound',
                page: () => const _SafeUnknownRouteScreen(),
              ),

              defaultTransition: Transition.fade,
              transitionDuration: const Duration(milliseconds: 400),

              // ✅ Log every navigation for debugging
              routingCallback: (routing) {
                if (routing != null) {
                  print(
                    '🧭 [ROUTING] current=${routing.current} | prev=${routing.previous} | isBack=${routing.isBack}',
                  );
                }
              },

              /// ✅ GLOBAL DEPENDENCIES HERE
              initialBinding: BindingsBuilder(() {
                Get.put(UserDetailController(), permanent: true);
                Get.put(ReportController(), permanent: true);

                Get.putPermanent(SocketService());

                if ((getToken ?? '').isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // socketService.connectSocket();
                  });
                }
              }),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Safe fallback screen — never shows UI, immediately pops or redirects
// Handles the case where Android fires the deep link intent directly at Flutter
// navigator (wemama://session/xxx) which is not a registered GetX route
// ─────────────────────────────────────────────────────────────────────────────
class _SafeUnknownRouteScreen extends StatefulWidget {
  const _SafeUnknownRouteScreen();

  @override
  State<_SafeUnknownRouteScreen> createState() =>
      _SafeUnknownRouteScreenState();
}

class _SafeUnknownRouteScreenState extends State<_SafeUnknownRouteScreen> {
  @override
  void initState() {
    super.initState();
    print('⚠️ [UNKNOWN ROUTE] /notFound triggered — auto-recovering...');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final canPop = Get.key.currentState?.canPop() ?? false;
      print(
        '⚠️ [UNKNOWN ROUTE] canPop=$canPop | currentRoute=${Get.currentRoute}',
      );

      if (canPop) {
        // Something valid is under this — just pop back to it
        print('⚠️ [UNKNOWN ROUTE] Popping back to previous route.');
        Get.back();
      } else {
        // Nothing under it — send to signin as safe default
        print('⚠️ [UNKNOWN ROUTE] No previous route. Redirecting to signin.');
        Get.offAllNamed(RoutePaths.signin);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Renders nothing — user never sees this screen
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.shrink(),
    );
  }
}
