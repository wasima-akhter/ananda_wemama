import 'package:get/get.dart';

import 'route_paths.dart';

class RouteTransitions {
  static Transition byName(String route) {
    switch (route) {
      // Splash
      case RoutePaths.meetingScreen:
        return Transition.fade;

      // Bottom navigation / main
      // case RoutePaths.home:
      //   return Transition.noTransition;

      // // Details pages
      // // case RoutePaths.orderDetails:
      // // case RoutePaths.deliveryDetails:
      // case RoutePaths.success:
      //   return Transition.rightToLeftWithFade;

      // // Modal-like screens
      // case RoutePaths.contactSupport:
      // case RoutePaths.reviewAndRating:
      //   return Transition.cupertinoDialog;

      // Default fallback
      default:
        return Transition.cupertino;
    }
  }
}
