import '../../../app/helper_widgets_export.dart';
import '../../../core/components/app_ui/location/current_location_showbar.dart';
import '../controller/station_location_controller.dart';

class StationLocationScreen extends StatelessWidget {
  const StationLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final slc = Get.find<StationLocationController>();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CommonAppBarContent(title: Strings.editLocation),
        resizeToAvoidBottomInset: true,
        backgroundColor: bgClr,
        body: Column(
          spacing: itemGap * 2,
          children: [
            // Selected location display
            Obx(
              () => CusGestureDetector(
                onTap: () => _showCityBottomSheet(context, slc),
                child: ContainerBordered(
                  hasBrdr: true,
                  vp: 12,
                  hp: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slc.displayLocation,
                              style: TxtStyle.inter(
                                color: slc.displayLocation == Strings.select ? greyLoc : null,
                                w: slc.displayLocation == Strings.select ? 500 : 600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (slc.hasLocation) ...[
                              Gap(itemGap),
                              Text(
                                "Lat: ${slc.latitude.value.toStringAsFixed(6)}, "
                                "Lng: ${slc.longitude.value.toStringAsFixed(6)}",
                                style: TxtStyle.inter(fs: 11, color: greyLoc),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SvgIconColored(iconPath: IconsPath.arrowForwardSmall, iconColor: c.primary),
                    ],
                  ),
                ),
              ),
            ),

            // OR Divider
            // OrDivider(),

            // Use current location button
            Obx(
              () => CustomBtnWTxt(
                isLoading: slc.isLoadingLocation.value,
                // onTap: slc.getAndSaveInBackendCurrLoc,
                btnTxt: Strings.useYourCurrentLocation,
                outlined: true,
              ),
            ),

            // Show location info if available
            Obx(() {
              if (slc.hasLocation) {
                return CurrentLocationShowbar(
                  selectedAddress: slc.selectedAddress.value,
                  latitude: slc.latitude.value,
                  longitude: slc.longitude.value,
                  selectedCity: slc.selectedCity.value,
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ).getcm,
      ),
    );
  }

  void _showCityBottomSheet(BuildContext context, StationLocationController slc) {
    showModalBottomSheet(
      backgroundColor: bgClr,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return AnimatedPadding(
          padding: EdgeInsets.only(bottom: S.bottomInset),
          duration: const Duration(milliseconds: 250),
          child: Container(
            decoration: BoxDecoration(borderRadius: 0.borderOnly(topLeft: 30, topRight: 30)),
            height: bSheetH,
            width: 1.sw,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(Strings.selectCity, style: TxtStyle.inter(fs: 18, w: 600)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: slc.cities.length,
                    itemBuilder: (context, index) {
                      final city = slc.cities[index];
                      return ListTile(
                        tileColor: lightGrey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        title: Text(city, style: TxtStyle.inter(w: 600)),
                        onTap: () {
                          Get.back();
                          slc.selectCity(city);
                        },
                      ).mB(4);
                    },
                  ),
                ),
              ],
            ),
          ).getBtmSheetM,
        );
      },
    );
  }
}
