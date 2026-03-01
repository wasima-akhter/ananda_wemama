import '../../../../app/helper_widgets_export.dart';
import '../controller/welcome_funding_mum_controller.dart';

class WelFundMumPage1 extends StatelessWidget {
  final WelcomeFundingMumController wfmc;
  const WelFundMumPage1({super.key, required this.wfmc});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: itemGap,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          Strings.welcomeFoundingMum.capEachWord(),
          textAlign: TextAlign.center,
          style: 21.titleMclrCusFS,
        ),
        ...wfmc.page1TxtList.map(
          (txt) => Text(
            txt.cap,
            textAlign: TextAlign.center,
            style: TxtStyle.urbanistSemiB(fs: 14, w: 500, color: c.primary),
          ),
        ),
      ],
    );
  }
}

class WelFundMumPage2 extends StatelessWidget {
  final WelcomeFundingMumController wfmc;
  const WelFundMumPage2({super.key, required this.wfmc});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: itemGap,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          Strings.whatThisMeans.capEachWord(),
          textAlign: TextAlign.center,
          style: 21.titleMclrCusFS,
        ),
        Gap(itemGap),
        ...wfmc.page2ItemList.map(
          (item) => ContainerBordered(
            contClr: c.inputBackground,
            hasBrdr: true,
            brdrClr: c.inputBorder,
            vp: 20,
            hp: 18,
            child: Row(
              children: [
                SvgIcon(iconPath: item.iconPath, height: 30),
                Gap(itemGap * 2),
                Expanded(
                  child: Text(
                    item.title,
                    style: TxtStyle.urbanistSemiB(fs: 14, w: 500, color: c.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WelFundMumPage3 extends StatelessWidget {
  final WelcomeFundingMumController wfmc;
  const WelFundMumPage3({super.key, required this.wfmc});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: itemGap,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(Strings.howMumsUse, textAlign: TextAlign.center, style: 21.titleMclrCusFS),
        Gap(itemGap),
        ...wfmc.page3ItemList.map(
          (item) => ContainerBordered(
            contClr: c.inputBackground,
            hasBrdr: true,
            brdrClr: c.inputBorder,
            vp: 20,
            hp: 18,
            child: Row(
              children: [
                SvgIcon(iconPath: item.iconPath, height: 30),
                Gap(itemGap * 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TxtStyle.urbanistSemiB(fs: 18, w: 600, color: c.primary),
                      ),

                      Text(
                        item.subtitle ?? '',
                        style: TxtStyle.urbanistSemiB(fs: 14, w: 500, color: c.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WelFundMumPage4 extends StatelessWidget {
  final WelcomeFundingMumController wfmc;
  const WelFundMumPage4({super.key, required this.wfmc});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: itemGap * 2,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          Strings.ourPromise.capEachWord(),
          textAlign: TextAlign.center,
          style: 21.titleMclrCusFS,
        ),
        Gap(4),
        ...wfmc.page4TxtList.map(
          (txt) => Text(
            txt.cap,
            textAlign: TextAlign.center,
            style: TxtStyle.urbanistSemiB(fs: 18, w: 500, color: c.primary),
          ),
        ),
      ],
    );
  }
}

class WelFundMumPage5 extends StatelessWidget {
  final WelcomeFundingMumController wfmc;

  const WelFundMumPage5({super.key, required this.wfmc});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: S.w * 0.8,
        child: Image.asset(ImagesPath.foundingMom, fit: BoxFit.contain),
      ),
    );
  }
}
