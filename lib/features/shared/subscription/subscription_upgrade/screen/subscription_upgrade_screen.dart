import 'package:we_mama/app/helper_widgets_export.dart';
import 'package:we_mama/gen/assets.gen.dart';

import '../../../../../core/components/ui/media/safe_asset_image/safe_image_asset.dart';

/*
class SubscriptionUpgradeScreen extends StatelessWidget {
  const SubscriptionUpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scpc = Get.find<SubscriptionUpgradeController>();

    final chooseSubPlanFormKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(
        title: Strings.subscriptionUpgrade,
        onTapBack: () async {
          Get.back(result: true);
          if (Get.isRegistered<MatchController>()) {
            MatchController.to.resetState();
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => ContainerBordered(
              rad: 30,

              vp: 20,
              hp: 20,
              contClr: c.buttonText,
              child: AuthButton(
                btnText: Strings.continueTxt,
                isLoading: scpc.isLoading.value,
                onTap: scpc.isLoading.value
                    ? null
                    : () => scpc.onTapContinue(chooseSubPlanFormKey),
              ),
            ),
          ),
        ],
      ),
      child: Form(
        key: chooseSubPlanFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Strings.supportConnectionGuidance.capEachWord(),
              textAlign: TextAlign.center,
              style: TxtStyle.outfit(fs: 14, w: 600, color: c.primary),
            ),

            // here will two sections of subscription model.
            // one is free  another one is paid.
            // will be  reactive and changes bgColor, textColor if selected
            // Obx(() {
            //   final isSelected = scpc.isPlanSelected(0);

            //   return GestureDetector(
            //     onTap: () => scpc.selectPlan(0),

            //     child: FreeSubCard(isSelected: isSelected),
            //   );
            // }),
            Gap(itemGap * 2.5),
            Obx(() {
              final isSelected = scpc.isPlanSelected(1);

              return GestureDetector(
                onTap: () => scpc.selectPlan(1),

                child: PaidSubCard(isSelected: isSelected),
              );
            }),

            Gap(itemGap * 2.5),
          ],
        ).getcm,
      ),
    );
  }
}
*/

class SubscriptionUpgradeScreen extends StatelessWidget {
  const SubscriptionUpgradeScreen({super.key});

  static String premiumWomanImage = Assets.images.upgradeLadyImage.path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBarContent(title: ''),
      backgroundColor: bgClrNew,
      body: LayoutBuilder(
        builder: (context, constraints) {
          /*
           * We design the screen around a 390 x 844 canvas.
           *
           * FittedBox scales the entire design down when the phone
           * is smaller/shorter, guaranteeing that all content remains
           * visible without scrolling.
           */
          final designWidth = S.w;
          final designHeight = S.h;

          return SizedBox(
            // width: designWidth,
            // height: designHeight,
            child: _PremiumContent(),
          );
        },
      ).getcm,
    );
  }
}

class _PremiumContent extends StatelessWidget {
  const _PremiumContent();

  static const _background = Color(0xFFFFF5F2);
  static const _coral = Color(0xFFFF6658);
  static const _darkBrown = Color(0xFF6F1F0B);
  static const _textDark = Color(0xFF211A18);
  static const _mutedText = Color(0xFF3F3633);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        // ---------------------------------------------------------------
        // Responsive values based on the ACTUAL available screen.
        // ---------------------------------------------------------------
        final isSmall = width < 360;
        final isShort = height < 700;

        final heroHeight = isShort ? height * .245 : height * .275;

        final planFlexHeight = isShort ? height * .505 : height * .49;

        final buttonHeight = isSmall ? 42.0 : 44.0;

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: _background,
          // padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              // ===========================================================
              // HERO
              // ===========================================================
              SizedBox(
                height: heroHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // ---------------------------------------------------------------
                    // WOMAN IMAGE
                    // ---------------------------------------------------------------
                    Align(
                      alignment: Alignment.centerRight,
                      child: FractionallySizedBox(
                        // Slightly narrower so it sits more toward the right.
                        widthFactor: isSmall ? .68 : .72,
                        heightFactor: 1.0,
                        child: Transform.translate(
                          offset: Offset(
                            width * (ScreenSize.isSmallWidth ? 0 : .05),
                            0,
                          ),
                          child: SafeAssetImage(
                            assetPath:
                                SubscriptionUpgradeScreen.premiumWomanImage,
                            shape: AssetImageShape.free,
                            fit: BoxFit.contain,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),

                    // ---------------------------------------------------------------
                    // LEFT TEXT
                    // ---------------------------------------------------------------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        // Give the text a little more room so it doesn't feel
                        // separated from the image.
                        widthFactor: isSmall ? .48 : .47,
                        child: Padding(
                          padding: EdgeInsets.only(top: heroHeight * .08),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upgrade to',
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                                style: TxtStyle.poppinsSemiB(
                                  fs: isSmall ? 15 : 17,
                                  w: 600,
                                  color: _textDark,
                                  h: 1.05,
                                ),
                              ),

                              Gap(isSmall ? 5.h : 6.h),

                              Text(
                                'WeMama',
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                                style: TxtStyle.dmSerifDisplayRegular(
                                  fs: isSmall ? 27 : 30,
                                  color: _darkBrown,
                                  height: .9,
                                ),
                              ),

                              Text(
                                'Premium',
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                                style: TxtStyle.dmSerifDisplayRegular(
                                  fs: isSmall ? 27 : 30,
                                  color: _darkBrown,
                                  height: .9,
                                ),
                              ),

                              Gap(isSmall ? 7.h : 9.h),

                              Text(
                                'More connection. More support. '
                                'Everything you need, all in one place.',
                                maxLines: 3,
                                overflow: TextOverflow.clip,
                                style: TxtStyle.poppins(
                                  fs: isSmall ? 9.5 : 10.5,
                                  w: 500,
                                  color: _textDark.withValues(alpha: .9),
                                  h: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(20.h),
              // ===========================================================
              // PLAN SECTION
              // ===========================================================
              SizedBox(
                height: planFlexHeight,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    isSmall ? 10 : 14,
                    0,
                    isSmall ? 10 : 14,
                    isShort ? 7 : 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDE8).withValues(alpha: .72),
                    borderRadius: BorderRadius.circular(isSmall ? 20 : 24),
                  ),
                  child: Column(
                    children: [
                      // ---------------------------------------------------
                      // MOST POPULAR
                      // ---------------------------------------------------
                      Transform.translate(
                        offset: Offset(0, isSmall ? -10 : -12),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmall ? 12 : 14,
                            vertical: isSmall ? 4 : 5,
                          ),
                          decoration: BoxDecoration(
                            color: _coral,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            'MOST POPULAR',
                            style: TxtStyle.poppins(
                              fs: isSmall ? 8.5 : 10,
                              w: 500,
                              color: Colors.white,
                              ls: .1,
                            ),
                          ),
                        ),
                      ),

                      // ---------------------------------------------------
                      // PRICE
                      // ---------------------------------------------------
                      Transform.translate(
                        offset: const Offset(0, -3),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '₦6,900',
                                style:
                                    TxtStyle.poppinsSemiB(
                                      fs: isSmall ? 13 : 15,
                                      w: 500,
                                      color: const Color(0xFF9C6C5A),
                                    ).copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 1.3,
                                    ),
                              ),

                              const SizedBox(width: 7),

                              Text(
                                '₦4,900',
                                style: TxtStyle.poppinsSemiB(
                                  fs: isSmall ? 22 : 25,
                                  w: 700,
                                  color: _coral,
                                ),
                              ),

                              const SizedBox(width: 6),

                              Text(
                                '/ month',
                                style: TxtStyle.poppinsSemiB(
                                  fs: isSmall ? 10.5 : 12,
                                  w: 500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 1),

                      // ---------------------------------------------------
                      // CANCEL ANYTIME
                      // ---------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cancel anytime',
                            style: TxtStyle.poppins(
                              fs: isSmall ? 9.5 : 11,
                              w: 500,
                              color: _mutedText,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.favorite_rounded,
                            size: isSmall ? 12 : 14,
                            color: _coral,
                          ),
                        ],
                      ),

                      SizedBox(height: isShort ? 6 : 9),

                      // ---------------------------------------------------
                      // FEATURES
                      // ---------------------------------------------------
                      Expanded(
                        child: _PremiumFeatureCard(
                          icon: Assets.images.upgradeConnection.path,
                          iconColor: const Color(0xFF9A543A),
                          title: 'Connection',
                          description:
                              'Unlimited Waves and more ways\nto connect with mums.',
                        ),
                      ),

                      SizedBox(height: isSmall ? 5 : 7),

                      Expanded(
                        child: _PremiumFeatureCard(
                          icon: Assets.images.upgradeCare.path,
                          iconColor: const Color(0xFF9A543A),
                          title: 'Mood & Self-Care',
                          description:
                              'Full Mood Library and save\nyour entries.',
                        ),
                      ),

                      SizedBox(height: isSmall ? 5 : 7),

                      Expanded(
                        child: _PremiumFeatureCard(
                          icon: Assets.images.upgradeAccess.path,
                          iconColor: const Color(0xFF9A543A),
                          title: 'Expert Access',
                          description:
                              'Live expert sessions, replays\nand submit questions.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Gap(10.h),

              // ===========================================================
              // DECORATION
              // ===========================================================
              SizedBox(
                height: isSmall ? 22 : 26,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmall ? 6 : 8),
                  child: SafeAssetImage(
                    assetPath: Assets.images.upgradeHeartString.path,
                    shape: AssetImageShape.free,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Gap(10.h),
              // ===========================================================
              // UPGRADE BUTTON
              // ===========================================================
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Start premium purchase
                    Get.toNamed(RoutePaths.promoCodeScreen);
                  },
                  icon: SafeAssetImage(
                    assetPath: Assets.images.upgradeCrown.path,
                    height: isSmall ? 18 : 20,
                  ),
                  label: Text(
                    'Upgrade to Premium',
                    style: TxtStyle.poppinsSemiB(
                      fs: isSmall ? 13.5 : 15,
                      w: 600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _darkBrown,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isSmall ? 15 : 17),
                    ),
                  ),
                ),
              ),

              // ===========================================================
              // FOOTER
              // ===========================================================
              Gap(isSmall ? 6.h : 9.h),

              SizedBox(
                height: 16,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_rounded,
                        size: 12,
                        color: Colors.black,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        'Secure payment',
                        style: TxtStyle.poppins(
                          fs: 9.5,
                          w: 500,
                          color: _textDark,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'Cancel anytime',
                        style: TxtStyle.poppins(
                          fs: 9.5,
                          w: 500,
                          color: _textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Small bottom breathing room.
              SizedBox(height: isShort ? 4.h : 10.h),
            ],
          ),
        );
      },
    );
  }
}

class _PremiumFeatureCard extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String title;
  final String description;

  const _PremiumFeatureCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        children: [
          // ---------------------------------------------------------------
          // ICON
          // ---------------------------------------------------------------
          SizedBox(
            width: 58,
            height: 58,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFF1ED),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SafeAssetImage(assetPath: icon, height: 28.sp),
              ),
            ),
          ),

          const SizedBox(width: 13),

          // ---------------------------------------------------------------
          // TEXT
          // ---------------------------------------------------------------
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TxtStyle.poppinsSemiB(
                    fs: 14,
                    w: 600,
                    color: const Color(0xFF241B18),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TxtStyle.poppins(
                    fs: 10,
                    w: 400,
                    color: const Color(0xFF3F3633),
                    h: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 7),

          // ---------------------------------------------------------------
          // ARROW
          // ---------------------------------------------------------------
          Container(
            width: 37,
            height: 37,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF0EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFFF4F43),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
