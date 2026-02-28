import '../../../../app/helper_widgets_export.dart';
import '../controller/lifestyle_and_interests_controller.dart';

class LifestyleAndInterestsScreen extends StatelessWidget {
  const LifestyleAndInterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lic = Get.find<LifestyleAndInterestsController>();

    final photoAndBioFormKey = GlobalKey<FormState>();

    return SafeArea(
      top: false,

      child: Scaffold(
        backgroundColor: bgClr,
        resizeToAvoidBottomInset: true,
        appBar: CommonAppBarContent(title: Strings.lifestyleInterests.capEachWord()),

        body: LayoutBuilder(
          builder: (context, constraints) {
            return BounceSingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: photoAndBioFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Strings.selectYourLikes.capEachWord(),
                              textAlign: TextAlign.center,
                              style: 13.titleMclrCusFSOutfit,
                            ),
                            Gap(itemGap),
                            Obx(
                              () => Text(
                                "${lic.selectedInterests.length}/10",
                                textAlign: TextAlign.center,
                                style: 13.titleMclrCusFSOutfit,
                              ),
                            ),
                          ],
                        ),

                        Gap(itemGap * 5),

                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 12.w,
                          runSpacing: 14.w,
                          children: [
                            ...List.generate(lic.interestsList.length, (index) {
                              final item = lic.interestsList[index];

                              return Obx(() {
                                final isSelected = lic.selectedInterests.contains(item);

                                return IntrinsicWidth(
                                  child: GestureDetector(
                                    onTap: () => lic.toggleInterest(item),
                                    child: ContainerBordered(
                                      hp: 10,
                                      vp: 6,
                                      rad: 30,
                                      contClr: isSelected ? c.primary : c.cardPrimary,
                                      child: Text(
                                        item,
                                        style: TxtStyle.outfit(
                                          fs: 12,
                                          w: 500,
                                          color: isSelected ? Colors.white : c.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                            }),
                          ],
                        ),
                        Gap(itemGap),
                        Obx(
                          () => lic.warningText.value.isEmpty
                              ? const SizedBox.shrink()
                              : Text(
                                  lic.warningText.value,
                                  style: TxtStyle.outfit(fs: 12, color: c.error),
                                ),
                        ),
                        // 👇 THIS PUSHES BOTTOM SECTION DOWN
                        const Spacer(),

                        // ===== BOTTOM SECTION =====
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => filledBtnWTxt(
                                btnTxt: Strings.continueTxt,
                                isLoading: lic.isLoading,
                                onTap: () async {
                                  Get.toNamed(RoutePaths.lifeStyleAndInterests);
                                },

                                //  await lic.onTapSignup(photoAndBioFormKey),
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
