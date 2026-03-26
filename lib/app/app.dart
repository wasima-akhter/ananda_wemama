import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mama_app/features/shared/report_sheet/controller/report_controller.dart';
import 'package:mama_app/routes/pages.dart';
import 'package:mama_app/routes/route_paths.dart';

import '../core/common_widgets/common_components/user_detaIl_component/controller/user_detail_controller.dart';
import '../core/config/app_info.dart';
import '../core/network/helpers/network_helpers.dart';
import '../core/services/socket/socket_service.dart';
import '../core/utils/extension/binding_extensions.dart';

class App extends StatelessWidget {
  final bool hasInternet;
  const App({super.key, required this.hasInternet});

  Future<String> getInitialRoute() async {
    return hasInternet ? RoutePaths.splashScreen : RoutePaths.offlineScreen;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getInitialRoute(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: snapshot.data!,
          title: appName,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: ThemeMode.light,

          getPages: RoutePageList.appPages,
          unknownRoute: RoutePageList.appPages.firstWhere(
            (page) => page.name == RoutePaths.notFound,
          ),
          defaultTransition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 400),

          /// ✅ GLOBAL DEPENDENCIES HERE
          initialBinding: BindingsBuilder(() {
            Get.put(UserDetailController(), permanent: true);
            Get.put(ReportController(), permanent: true);

            // ── Register SocketService first (MatchController depends on it) ──────────
            Get.putPermanent(SocketService());
            final socketService = Get.find<SocketService>();

            // ── Connect immediately if user is already logged in (token exists) ───────
            // On fresh login this is skipped — SigninService.connectSocket() handles it.
            if ((getToken ?? '').isNotEmpty) {
              socketService.connectSocket();
            }
          }),
        );
      },
    );
  }
}
