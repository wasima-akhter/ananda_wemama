import 'package:mama_app/core/common_widgets/custom_divider.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/experts_controller.dart';
import 'session_component.dart';

class PaidPastSessionsComponent extends StatelessWidget {
  const PaidPastSessionsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ExpertsController>();

    return ContainerBordered(
      contClr: c.cardReminder,
      rad: 20,
      hp: 8,
      vp: 12,
      boxShadow: boxShadowBottom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.libraryOfPastSessions.capEachWord(), style: TxtStyle.outfitSmTitle),
          Gap(4),
          CustomDivider(isFullWidth: true),
          Gap(itemGap * 2),

          /// horizontal session list
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Row(
              children: [
                ...List.generate(ctrl.pastSessionList.length, (index) {
                  final item = ctrl.pastSessionList[index];

                  return SessionComponent();
                }),
              ],
            ),
          ),

          Gap(itemGap * 3),

          /// watch all button
          Center(
            child: IntrinsicWidth(
              child: CustomBtnWTxt(
                btnTxt: Strings.watchAll,
                isSmall: true,
                isLoading: false,

                rad: 30,
                padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 8.h),
                onTap: () {
                  Get.toNamed(RoutePaths.pastSessions);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
