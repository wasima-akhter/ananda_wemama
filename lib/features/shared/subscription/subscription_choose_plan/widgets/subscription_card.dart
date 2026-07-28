import 'package:we_mama/app/helper_widgets_export.dart';

import 'subscription_row.dart';

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
            title.toUpperCase(),
            style: TxtStyle.outfit(fs: 20, w: 700, color: txtClr),
          ),
          Gap(18),
          ...children,
        ],
      ),
    );
  }
}

class PaidSubCard extends StatelessWidget {
  final bool isSelected;
  const PaidSubCard({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final rowTextClr = isSelected ? c.scaffoldBackground : c.primary;
    final titleTextClr = c.primary;
    final bgColor = isSelected ? c.secondary : c.cardPrimary;
    return SubscriptionCard(
      title: Strings.premium,
      bgColor: bgColor,
      textColor: rowTextClr,
      popularTxtColor: isSelected ? c.primary : c.scaffoldBackground,
      isPopular: true,
      pricingSection: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${Strings.currency}4,900 / ${Strings.month.cap}",
            style: TxtStyle.outfit(fs: 18, w: 700, color: rowTextClr),
          ),
          Gap(4),
          Text(
            Strings.cancelAnytime.capEachWord(),
            style: TxtStyle.outfit(fs: 14, color: rowTextClr),
          ),
          // Gap(4),
          // Text(
          //   Strings.lessThanPerDay,
          //   textAlign: TextAlign.center,
          //   style: TxtStyle.outfit(fs: 14, color: rowTextClr),
          // ).mHV(10, 0),
          Gap(itemGap),
        ],
      ),
      children: [
        SubscriptionSectionTitle(
          title: Strings.connection,
          textColor: titleTextClr,
        ),
        SubscriptionFeatureRow(
          title: Strings.unlockEverything,
          isIncluded: true,
          textColor: rowTextClr,
        ),
        SubscriptionFeatureRow(
          title: Strings.unlimitedWaves,
          isIncluded: true,
          textColor: rowTextClr,
        ),

        Gap(10),

        SubscriptionSectionTitle(
          title: Strings.moodSelfCare,
          textColor: titleTextClr,
        ),
        SubscriptionFeatureRow(
          title: Strings.fullMoodLibrary,
          isIncluded: true,
          textColor: rowTextClr,
        ),
        SubscriptionFeatureRow(
          title: Strings.saveMoodEntries,
          isIncluded: true,
          textColor: rowTextClr,
        ),

        Gap(10),

        SubscriptionSectionTitle(
          title: Strings.expertAccess,
          textColor: titleTextClr,
        ),
        SubscriptionFeatureRow(
          title: Strings.attendLiveExpertSessions,
          isIncluded: true,
          textColor: rowTextClr,
        ),
        SubscriptionFeatureRow(
          title: Strings.watchSessionsReplay,
          isIncluded: true,
          textColor: rowTextClr,
        ),
        SubscriptionFeatureRow(
          title: Strings.submitQuestions,
          isIncluded: true,
          textColor: rowTextClr,
        ),
      ],
    );
  }
}

class FreeSubCard extends StatelessWidget {
  final bool isSelected;
  const FreeSubCard({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final rowTextClr = isSelected ? c.scaffoldBackground : c.primary;
    final titleTextClr = c.primary;
    final bgColor = isSelected ? c.secondary : c.cardPrimary;
    return SubscriptionCard(
      title: Strings.free,
      bgColor: bgColor,
      textColor: isSelected ? c.scaffoldBackground : c.primary,
      children: [
        SubscriptionSectionTitle(
          title: Strings.connection,
          textColor: titleTextClr,
        ),
        SubscriptionFeatureRow(
          title: Strings.connectWithMums,
          isIncluded: true,
          textColor: rowTextClr,
        ),
        SubscriptionFeatureRow(
          title: Strings.createCommunityPosts,
          isIncluded: true,
          textColor: rowTextClr,
        ),
        SubscriptionFeatureRow(
          title: Strings.commentAndReply,
          isIncluded: true,
          textColor: rowTextClr,
        ),
        SubscriptionFeatureRow(
          title: Strings.limitedDailyWaves,
          isIncluded: true,
          textColor: rowTextClr,
        ),

        Gap(10),

        SubscriptionSectionTitle(
          title: Strings.moodAndSelfCare,
          textColor: titleTextClr,
        ),
        SubscriptionFeatureRow(
          title: Strings.fullMoodLibrary,
          isIncluded: false,
          textColor: rowTextClr,
          isCloseWhite: isSelected ? true : false,
        ),

        Gap(10),

        SubscriptionSectionTitle(title: Strings.expertAccess),
        SubscriptionFeatureRow(
          title: Strings.attendLiveSessions,
          isIncluded: false,
          textColor: rowTextClr,
          isCloseWhite: isSelected ? true : false,
        ),
      ],
    );
  }
}
