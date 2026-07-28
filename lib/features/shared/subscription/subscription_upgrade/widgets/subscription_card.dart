import 'package:we_mama/app/helper_widgets_export.dart';

class SubscriptionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isPopular;
  final Widget? pricingSection;
  final Color? bgColor;
  final Color? textColor;
  final Color? popularTxtColor;

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.children,
    this.isPopular = false,
    this.pricingSection,
    this.bgColor,
    this.textColor,
    this.popularTxtColor,
  });

  @override
  Widget build(BuildContext context) {
    final txtClr = textColor ?? c.primary;

    return ContainerBordered(
      contClr: bgColor ?? c.cardPrimary,
      rad: 16,
      vp: 18,
      hp: 25,
      brdrClr: c.inputBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isPopular)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ContainerBordered(
                  contClr: textColor,
                  rad: 18,
                  vp: 6,
                  hp: 16,
                  child: Text(
                    Strings.mostPopular.toUpperCase(),
                    style: TxtStyle.outfit(
                      fs: 13,
                      w: 600,
                      color: popularTxtColor,
                    ),
                  ),
                ).mB(10),
              ],
            ),
          ?pricingSection,

          Text(
            title.capEachWord(),
            style: TxtStyle.outfit(fs: 20, w: 700, color: txtClr),
          ),
          Gap(18),
          ...children,
        ],
      ),
    );
  }
}
