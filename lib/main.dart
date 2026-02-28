import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/app.dart';
import 'core/local/app_storage.dart';
import 'core/network/network_manager.dart';
import 'core/themes/theme_service.dart';
import 'routes/route_paths.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // optional if you want upside-down support
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.light),
  );

  // Initialize LocalStorageService singleton
  await Get.putAsync<AppStorage>(() async => await AppStorage.init());

  // ✅ Initialize services AFTER AppStorage
  // await initServices();

  // ✅ Register controller BEFORE using it
  Get.put(ThemeController(), permanent: true);

  var hasNet_ = await NetworkManager().checkConnection();
  NetworkManager().networkStream().listen((isConnected) {
    if (isConnected != hasNet_) {
      hasNet_ = isConnected; // ✅ UPDATE STATE

      if (isConnected == false) {
        Get.toNamed(RoutePaths.offlineScreen);
      } else {
        if (Get.currentRoute == RoutePaths.offlineScreen) {
          // If there is NO previous route in stack
          if (!(Get.key.currentState?.canPop() ?? false)) {
            // Offline was the first screen → start app from splash
            Get.offAllNamed(RoutePaths.homeScreen);
          } else {
            // There are routes under it → just go back
            Get.close(1);
          }
        }
      }
    }
  });
  runApp(
    ScreenUtilInit(
      designSize: Size(360, 800),
      minTextAdapt: true, // optional: auto-scale text
      splitScreenMode: true, // optional: responsive for tablets
      builder: (context, child) {
        /// Wrap App with ValueListenableBuilder to react on userToken changes
        return App(hasInternet: hasNet_);
      },
    ),
  );
}
