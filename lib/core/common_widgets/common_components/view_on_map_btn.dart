import 'package:mama_app/app/helper_widgets_export.dart';

class ViewOnMapBtn extends StatelessWidget {
  const ViewOnMapBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBtnWTxt(
      isSmall: true,
      outlined: true,
      btnTxt: Strings.viewOnMap,
      onTap: () {
        print("view on map");
        // GNav.pushNamed(RoutePaths.googleMap);
      },
      isLoading: false,
    );
  }
}
