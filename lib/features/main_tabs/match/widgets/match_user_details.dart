import 'package:we_mama/core/helpers/widgets_helper.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/app_ui/components/user_detaIl_component/controller/user_detail_controller.dart';
import '../../../../core/components/app_ui/components/user_detaIl_component/ui/user_about_section.dart';
import '../../../../core/components/app_ui/components/user_detaIl_component/ui/user_avatar.dart';
import '../model/match_model.dart';

class MatchUserDetails extends StatefulWidget {
  final MatchResponseModel? user;
  final RxBool isWaveLoading;
  final RxBool isPassLoading;
  final VoidCallback onTapSeeMore;
  final Future<void> Function(bool hasWaved) onTapAction;
  final RxBool isSeeMore;
  final Future<String> Function(MatchResponseModel user) resolveAddress;

  const MatchUserDetails({
    super.key,
    required this.user,
    required this.isPassLoading,
    required this.isSeeMore,
    required this.onTapSeeMore,
    required this.onTapAction,
    required this.resolveAddress,
    required this.isWaveLoading,
  });

  @override
  State<MatchUserDetails> createState() => _MatchUserDetailsState();
}

class _MatchUserDetailsState extends State<MatchUserDetails> {
  String? _resolvedAddress;
  bool _addressLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  @override
  void didUpdateWidget(MatchUserDetails old) {
    super.didUpdateWidget(old);
    // Reload if the user changed (e.g. next match shown)
    if (old.user?.id != widget.user?.id) {
      setState(() {
        _resolvedAddress = null;
        _addressLoading = true;
      });
      _loadAddress();
    }
  }

  Future<void> _loadAddress() async {
    if (widget.user == null) return;
    final address = await widget.resolveAddress(widget.user!);
    if (mounted) {
      setState(() {
        _resolvedAddress = address;
        _addressLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = widget.isSeeMore;
    final user = widget.user;

    if (user == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 10.w),
      decoration: BoxDeco.decRadAllBorderedAll(
        20,
        clr: c.textOnPrimary,
        brdrClr: c.secondary,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar + name ──────────────────────────────────────────────
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserAvatar(imageUrl: user.profileImage ?? ''),
                Gap(itemGap),
                _getUserName(user),
              ],
            ),
          ),

          Gap(itemGap),

          // ── Info rows ──────────────────────────────────────────────────
          _getUserInfo([
            UiInfoItem(
              iconPath: IconsPath.locationBold,
              // Show placeholder while reverse geocoding, real value once ready
              text: _addressLoading ? '...' : _resolvedAddress ?? '...',
            ),
            UiInfoItem(
              iconPath: IconsPath.chartFilled,
              text: user.mumStage ?? '',
            ),
            UiInfoItem(
              iconPath: IconsPath.heartHalfFilled,
              text: user.interesteds.join(', ') ?? '',
            ),
          ]),

          Gap(itemGap),
          _getRowOfImages(user),

          Gap(itemGap),

          // ── Children ───────────────────────────────────────────────────
          if ((user.children ?? []).isNotEmpty) ...[
            Text(
              Strings.children.cap,
              style: TxtStyle.outfitSemiB(fs: 15, w: 500),
            ),
            Gap(itemGap),
            _getChildrenRow(user),
            Gap(itemGap),
          ],

          // ── About me ───────────────────────────────────────────────────
          UserAboutSection(
            aboutText: user.bio ?? '',
            isExpanded: isExpanded,
            onToggle: widget.onTapSeeMore,
          ),
          Gap(itemGap),

          // ── Pass / Wave ────────────────────────────────────────────────
          _getDeclineAcceptBtnRow(),
        ],
      ),
    );
  }

  Widget _getUserName(MatchResponseModel user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            (user.name ?? '').capEachWord(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TxtStyle.outfitSemiB(fs: 20, w: 600, color: c.primary),
          ),
        ),
        const SizedBox(width: 3),
        SvgIcon(iconPath: IconsPath.verifiedTick).mB(12),
      ],
    );
  }

  Widget _getUserInfo(List<UiInfoItem> listOfInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(listOfInfo.length, (index) {
        final e = listOfInfo[index];
        return Row(
          children: [
            SvgIconColored(iconPath: e.iconPath, height: 18),
            Gap(itemGap),
            Expanded(
              child: Text(
                (index == 2 ? 'Interested in: ' : '') + e.text.capEachWord(),
                style: TxtStyle.outfitSmNor,
              ),
            ),
          ],
        ).mB(3);
      }),
    ).mHV(20, 0);
  }

  Widget _getRowOfImages(MatchResponseModel user) {
    if ((user.images ?? []).isEmpty) return const SizedBox.shrink();
    return Row(
      children: List.generate(4, (index) {
        final hasImage = index < (user.images.length ?? 0);
        return Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: 4.pa,
              child: hasImage
                  ? NetworkImageWidget(
                      radius: 8,
                      imageUrl: user.images[index].trim(),
                    )
                  : const SizedBox(),
            ),
          ),
        );
      }),
    );
  }

  Widget _getChildrenRow(MatchResponseModel user) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(user.children.length, (index) {
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: ContainerBordered(
              rad: 30,
              hp: 12,
              vp: 6,
              contClr: c.scaffoldBackground,
              child: Text(
                getChildAge(
                  (user.children[index].dob ?? '').toString(),
                  gender: user.children[index].gender,
                ).capEachWord(),
                style: TxtStyle.outfitSmSecNor,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _getDeclineAcceptBtnRow() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: CustomBtnWTxt(
              isSmall: true,
              btnColor: ctransp,
              borderClr: c.primary,
              txtClr: c.textSecondary,
              rad: 12,
              btnTxt: Strings.pass,
              isLoading: widget.isPassLoading.value,
              onTap: () => widget.onTapAction(false),
            ),
          ),
          SizedBox(width: itemGap * 2),
          Expanded(
            child: CustomBtnWTxt(
              isSmall: true,
              btnColor: c.primary,
              borderClr: c.primary,
              txtClr: white,
              btnTxt: Strings.wave,
              rad: 12,
              isLoading: widget.isWaveLoading.value,
              onTap: () => widget.onTapAction(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String iconPath;
  final String text;

  _InfoRow({required this.iconPath, required this.text});
}
