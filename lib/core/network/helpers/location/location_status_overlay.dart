// lib/features/main_tabs/home/modules/location_status_overlay.dart

import 'package:we_mama/core/components/app_ui/tags/tag_type_widgets.dart';

import '../../../../app/helper_widgets_export.dart';
import 'location_manager_global/app_location_manager.dart';

class LocationStatusOverlay extends StatelessWidget {
  const LocationStatusOverlay({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: S.w * 0.07,
        vertical: 24.h,
      ),
      child: _OverlayCard(isActive: isActive),
    );
  }
}

class _OverlayCard extends StatefulWidget {
  const _OverlayCard({required this.isActive});
  final bool isActive;

  @override
  State<_OverlayCard> createState() => _OverlayCardState();
}

class _OverlayCardState extends State<_OverlayCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isActive;
    final accent = isActive ? Colors.green : c.secondary;

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContainerBordered(
              vp: 20,
              hp: 18,
              contClr: c.scaffoldBackground,
              rad: 20,
              boxShadow: boxShadowAllSides,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Header ────────────────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: accent.withOpacity(0.12),
                        radius: 20.r,
                        child: Icon(
                          isActive
                              ? Icons.location_on_rounded
                              : Icons.location_off_rounded,
                          color: accent,
                          size: 20.h,
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isActive
                                  ? Strings.locationEnabled.capEachWord()
                                  : Strings.youAreInactiveNow,
                              style: TxtStyle.interSemiB(
                                fs: 14,
                                w: 700,
                                color: c.foregroundPrimary,
                              ),
                            ),
                            Gap(3.w),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [ActiveTag(isActive: isActive)],
                            ),
                          ],
                        ),
                      ),
                      CusGestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.close_rounded,
                          color: c.textSecondary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  Gap(14.w),
                  Divider(color: c.secondary.withOpacity(0.15), height: 1),
                  Gap(14.w),

                  // ── Body ──────────────────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: c.bottomSheetBackground.withOpacity(
                          0.5,
                        ),
                        radius: 9,
                        child: SvgIconColored(
                          iconPath: IconsPath.curvedInfo,
                          iconColor: c.primary.withOpacity(0.5),
                          height: 11,
                        ),
                      ),
                      Gap(8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isActive
                                  ? Strings.locationActiveVisible
                                  : Strings.inactiveNotVisible,
                              style: TxtStyle.interSemiB(
                                fs: 12,
                                w: 400,
                                color: c.primary.withOpacity(0.7),
                              ),
                            ),
                            Gap(6.w),
                            Text(
                              isActive
                                  ? Strings.youCanNowFindMatches
                                  : Strings.enableLocationForMatching,
                              style: TxtStyle.interSemiB(
                                fs: 12,
                                w: 500,
                                color: isActive ? Colors.green : c.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Gap(14.w),

                  // ── CTA ───────────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: isActive
                        ? OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: c.secondary),
                              shape: RoundedRectangleBorder(
                                borderRadius: 12.brdrRad,
                              ),
                              padding: 12.pv,
                            ),
                            onPressed: () => Get.back(),
                            child: Text(
                              Strings.gotIt.capEachWord(),
                              style: TextStyle(color: c.secondary),
                            ),
                          )
                        : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: c.strokePrimary.withValues(
                                alpha: 0.9,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: 12.brdrRad,
                              ),
                              padding: 12.pv,
                            ),
                            icon: Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 16.w,
                            ),
                            label: Text(
                              Strings.enableLocation.capEachWord(),
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              Get.back();
                              final result = await AppLocationManager.to
                                  .enableLocationGateway();

                              closeAllSnackbar();
                              // Get.back();

                              if (result == LocationFlowResult.success) {
                                Snack.showSuccess("Location enabled");
                              } else {
                                Snack.showError("Please enable location fully");
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
