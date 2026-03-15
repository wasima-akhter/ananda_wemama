import 'package:mama_app/core/common_widgets/common_components/bg_image_container.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/mums_stage_controller.dart';

class MumsStageFinishScreen extends StatelessWidget {
  const MumsStageFinishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final msc = Get.find<MumsStageController>();
    return SafeArea(
      top: false,

      child: Scaffold(
        backgroundColor: bgClr,
        resizeToAvoidBottomInset: true,
        appBar: CommonAppBarContent(title: '', isBgTransp: true),
        extendBodyBehindAppBar: true,

        body: LayoutBuilder(
          builder: (context, constraints) {
            return BounceSingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: BgImageContainer(
                  bgPath: ImagesPath.splashImage,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min, // ✅
                    children: [
                      Gap(itemGap * 6), // top breathing room instead of Expanded

                      weMamaLogoWithTxt,
                      Gap(itemGap * 3),
                      FittedBox(
                        child: Text(
                          Strings.accountCreatedSuccessfully.capEachWord(),
                          textAlign: TextAlign.center,
                          style: TxtStyle.urbanistSemiB(fs: 18, w: 700, color: c.primary),
                        ),
                      ),
                      Gap(itemGap),
                      Text(
                        Strings.personalizedSpaceReady,
                        textAlign: TextAlign.center,
                        style: 11.titleMclrCusFS,
                      ),
                      Gap(itemGap * 3),
                      CustomBtnWTxt(
                        w: S.w * 0.6,
                        btnTxt: Strings.finish,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        style: TxtStyle.urbanistSemiB(fs: 14, color: white, w: 700),
                        isUppCase: true,
                        onTap: msc.onTapFinish,
                        isLoading: false,
                      ),

                      Gap(itemGap * 4),

                      // ===== BOTTOM SECTION =====
                      Image.asset(ImagesPath.momsGroupPhoto),
                    ],
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
