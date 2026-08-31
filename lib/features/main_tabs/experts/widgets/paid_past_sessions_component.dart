import 'package:we_mama/core/components/ui/helpers/shapes/custom_divider.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/experts_controller.dart';
import 'session_component.dart';

class PaidPastSessionsComponent extends StatelessWidget {
  const PaidPastSessionsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ExpertsController>();

    return ContainerBordered(
      contClr: newCardClr,
      rad: 20,
      hp: 8,
      vp: 12,
      boxShadow: boxShadowBottom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.libraryOfPastSessions.capEachWord(),
            style: TxtStyle.outfitSmTitle,
          ),
          Gap(4),
          CustomDivider(isFullWidth: true),
          Gap(itemGap * 2),

          /// horizontal session list
          /// horizontal session list
          Obx(() {
            if (ctrl.isPastSessionLoading.value) {
              return SizedBox(
                height: 180.h,
                child: Center(child: LoadingPrimary()),
              );
            }

            final sessions = ctrl.limitedPastSessions;

            if (sessions.isEmpty) {
              return SizedBox(
                height: 100.h,
                child: Center(
                  child: Text(
                    "No past sessions available",
                    style: TxtStyle.outfitSmTitle,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Row(
                children: [
                  ...List.generate(sessions.length, (index) {
                    final item = sessions[index];

                    return Padding(
                      padding: EdgeInsets.only(right: itemGap),
                      child: SizedBox(
                        width: 150.w,
                        height: 230.0.h,
                        child: SessionComponent(
                          session: item,
                          isFromExpertScreen: true,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
          Gap(itemGap * 3),

          /// watch all button
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomBtnWTxt(
                  btnTxt: Strings.watchAll,
                  isSmall: true,
                  isLoading: false,
                  btnColor: c.primary,

                  rad: 30,
                  padding: EdgeInsets.symmetric(
                    horizontal: 50.w,
                    vertical: 8.h,
                  ),
                  onTap: () {
                    Get.toNamed(RoutePaths.pastSessions);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
