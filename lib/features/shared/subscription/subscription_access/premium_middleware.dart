import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../routes/route_paths.dart';
import 'premium_access_service.dart';

class PremiumRouteGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!PremiumAccessService.to.isPremiumUserNow) {
      return RouteSettings(name: RoutePaths.subChoosePlan);
    }
    return null;
  }
}

/* Use:
GetPage(
  name: RoutePaths.someGatedScreen,
  page: () => const SomeGatedScreen(),
  middlewares: [PremiumRouteGuard()],
),

*/
