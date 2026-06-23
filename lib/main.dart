import 'package:flutter/services.dart';
import 'package:mama_app/app/helper_widgets_export.dart';

import 'app/app.dart';
import 'core/local/app_storage.dart';
import 'core/network/network_manager.dart';
import 'core/services/deep_link/app_link_service.dart';
import 'core/services/firebase/firebase_service.dart';
import 'core/services/location/location_service.dart';
import 'core/themes/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // optional if you want upside-down support
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: ctransp,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // ----------------------------
  // Firebase initialization
  // ----------------------------
  // Firebase FIRST
  await FirebaseInitializer.init();

  // Initialize LocalStorageService singleton
  await Get.putAsync<AppStorage>(() async => await AppStorage.init());

  await Get.putAsync<DeepLinkService>(() async {
    final service = DeepLinkService();
    await service.init();
    return service;
  });

  // await Get.putAsync(() async => await SocketService().init());

  // ✅ Initialize services AFTER AppStorage
  // await initServices();

  // ✅ Register controller BEFORE using it
  Get.put(ThemeController(), permanent: true);
  Get.put(LocationService(), permanent: true);

  var hasNet_ = await NetworkManager().checkConnection();
  NetworkManager().networkStream().listen((isConnected) {
    if (isConnected != hasNet_) {
      hasNet_ = isConnected; // ✅ UPDATE STATE

      if (isConnected == false) {
        if (Get.currentRoute != RoutePaths.offlineScreen) {
          Get.toNamed(RoutePaths.offlineScreen);
        }
      } else {
        if (Get.currentRoute == RoutePaths.offlineScreen) {
          // If there is NO previous route in stack
          if (!(Get.key.currentState?.canPop() ?? false)) {
            // Offline was the first screen → start app from splash
            Get.offAllNamed(RoutePaths.splashScreen);
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
