import '../../../../app/helper_widgets_export.dart';
import '../../../../gen/assets.gen.dart';
import '../controller/success_controller.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;

    final sc = Get.find<SuccessController>();

    final argument = Get.arguments;
    SuccessViewDataModel? dataModel;
    if (argument != null && argument is SuccessViewDataModel) {
      dataModel = argument;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => didPop
          ? null
          : willPopFunction(currentBackPressTime: sc.currentBackPressTime),
      child: SafeArea(
        top: false,

        child: Scaffold(
          backgroundColor: bgClr,
          // appBar: CommonAppBarContent(title: "", hasBackNavArrow: false),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgIconColored(
                  iconPath: Assets.icons.tickL,
                  iconColor: dataModel?.iconClr ?? c.primary,
                  height: 1.sw * 0.15,
                ),

                Gap(itemGap * 5),
                if (dataModel != null)
                  Center(
                    child: Text(
                      dataModel.title ?? '',
                      softWrap: true,
                      textAlign: TextAlign.center,

                      style: TxtStyle.inter(fs: 15, w: 600),
                    ),
                  ),
                Gap(itemGap * 2),
                if (dataModel != null)
                  Center(
                    child: Text(
                      dataModel.subtitle ?? '',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TxtStyle.inter(fs: 11, w: 600),
                    ),
                  ),
                Gap(itemGap * 4),
                if (dataModel != null)
                  CustomBtnWTxt(
                    outlined: dataModel.iconClr != null ? false : true,
                    btnColor: dataModel.iconClr,

                    style: TxtStyle.interSemiB(
                      fs: 16,
                      w: 600,
                      color: dataModel.iconClr != null
                          ? c.textOnPrimary
                          : c.primary,
                    ),
                    onTap:
                        dataModel.btnOnTap ??
                        () {
                          // Get.toNamed(RoutePaths.mainNav);

                          // Get.find<MainNavController>().goToTab(3);
                        },

                    btnTxt: dataModel.btnTxt ?? '',
                    isLoading: false,
                  ),

                Gap(itemGap * 5),
              ],
            ).getcm,
          ),
        ),
      ),
    );
  }
}

class SuccessViewDataModel {
  final String? title;
  final String? subtitle;
  final String? btnTxt;
  final Color? iconClr;
  final void Function()? btnOnTap;

  SuccessViewDataModel({
    this.title,
    this.subtitle,
    this.btnTxt,
    this.btnOnTap,
    this.iconClr,
  });
}
