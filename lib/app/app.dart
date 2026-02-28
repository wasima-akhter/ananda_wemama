import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mama_app/routes/pages.dart';
import 'package:mama_app/routes/route_paths.dart';

import '../core/config/app_info.dart';

class App extends StatelessWidget {
  final bool hasInternet;
  const App({Key? key, required this.hasInternet}) : super(key: key);

  Future<String> getInitialRoute() async {
    return hasInternet ? RoutePaths.setupProfile : RoutePaths.offlineScreen;
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
            (page) => page.name == RoutePaths.notfound,
          ),
          defaultTransition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 400),

          /// ✅ GLOBAL DEPENDENCIES HERE
          initialBinding: BindingsBuilder(() {
            // Get.lazyPut(() => SplashController());
          }),
        );
      },
    );
  }
}
