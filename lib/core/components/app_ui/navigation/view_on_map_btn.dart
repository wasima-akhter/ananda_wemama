import 'package:we_mama/app/helper_widgets_export.dart';

class ViewOnMapBtn extends StatelessWidget {
  const ViewOnMapBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBtnWTxt(
      isSmall: true,
      outlined: true,
      btnTxt: "view On Map",
      onTap: () {
        print("view on map");
        // Get.toNamed(RoutePaths.googleMap);
      },
      isLoading: false,
    );
  }
}
