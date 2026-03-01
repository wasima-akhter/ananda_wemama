import '../../../../app/helper_widgets_export.dart';
import '../controller/mums_stage_controller.dart';

class MumsStageScreen extends StatelessWidget {
  const MumsStageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final msc = Get.find<MumsStageController>();

    final mumStageFormKey = GlobalKey<FormState>();

    return SafeArea(
      top: false,

      child: Scaffold(
        backgroundColor: bgClr,
        resizeToAvoidBottomInset: true,
        appBar: CommonAppBarContent(title: Strings.mumsStage),

        body: LayoutBuilder(
          builder: (context, constraints) {
            return BounceSingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: mumStageFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Gap(itemGap * 3),
                        Text(
                          Strings.chooseYourStage.capEachWord(),
                          textAlign: TextAlign.center,
                          style: 13.titleMclrCusFSOutfit,
                        ),

                        Gap(itemGap * 3),

                        // column of rows having left individual icon, middle text and on right, a tick icon
                        Column(
                          children: List.generate(msc.stageList.length, (index) {
                            final item = msc.stageList[index];

                            return Obx(() {
                              final isSelected = msc.selectedStage.value == item.title;

                              return GestureDetector(
                                onTap: () => msc.selectStage(item.title),
                                child: ContainerBordered(
                                  mv: 6,
                                  hp: 12,
                                  vp: 12,
                                  rad: 35,
                                  contClr: isSelected ? c.primary : c.cardPrimary,
                                  hasBrdr: true,
                                  brdrClr: isSelected ? c.primary : c.inputBorder,
                                  brdrW: 1,
                                  child: Row(
                                    children: [
                                      /// 🔹 Left Icon
                                      SvgIconColored(
                                        iconPath: item.leftIcon,
                                        iconColor: isSelected ? c.scaffoldBackground : c.primary,
                                        height: 20,
                                      ),

                                      Gap(12),

                                      /// 🔹 Middle Text
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: item.title,
                                                style: TxtStyle.outfit(
                                                  w: isSelected ? 500 : 600,
                                                  color: isSelected
                                                      ? c.scaffoldBackground
                                                      : c.primary,
                                                ),
                                              ),

                                              if (item.info.isNotEmpty)
                                                TextSpan(
                                                  text: " ${item.info}",
                                                  style: TxtStyle.outfit(
                                                    w: 500,
                                                    color: isSelected
                                                        ? c.scaffoldBackground
                                                        : c.primary,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      /// 🔹 Right Tick
                                      SvgIconColored(
                                        iconPath: IconsPath.smallTick,
                                        iconColor: isSelected ? c.scaffoldBackground : c.primary,
                                        height: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          }),
                        ),
                        Gap(itemGap * 2.5),

                        // 👇 THIS PUSHES BOTTOM SECTION DOWN
                        const Spacer(),

                        // ===== BOTTOM SECTION =====
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => filledBtnWTxt(
                                btnTxt: Strings.continueTxt,
                                isLoading: msc.isLoading,
                                onTap: () => msc.onTapContinue(mumStageFormKey),

                                //  await msc.onTapSignup(mumStageFormKey),
                              ),
                            ),
                          ],
                        ),

                        Gap(itemGap * 3),
                      ],
                    ).getcm,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
