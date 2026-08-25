import '../../../../../app/helper_widgets_export.dart';
import '../../controller/match_controller.dart';

class MatchLocationUnavailableState extends StatelessWidget {
  const MatchLocationUnavailableState({super.key, required this.mc});

  final MatchController mc;

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: white,
      hp: 12,
      vp: 22,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Location Access Needed",
            textAlign: TextAlign.center,
            style: TxtStyle.outfitSmTitle.copyWith(color: c.primary),
          ),
          Gap(6.h),

          Text(
            "Please enable location service and allow location permission to find nearby WeMamas.",
            textAlign: TextAlign.center,
            style: TxtStyle.outfitSmSecNor,
          ),

          Gap(itemGap * 3),

          Obx(() {
            return CustomBtnWTxt(
              btnTxt: "Enable Location",
              onTap: () => mc.enableLocationGatewayFlow(),
              isLoading: mc.isLocationProcessing.value,
            );
          }),

          Gap(itemGap * 2),
        ],
      ),
    );
  }
}
