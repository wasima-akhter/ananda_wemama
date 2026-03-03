import '../../../../app/helper_widgets_export.dart';

class NewWavesUserDetailsPopup extends StatelessWidget {
  final bool isLoading;
  final Future<void> Function() onTapDeclineOrAccept;
  final void Function() onTapSeeMoreTxt;
  final RxBool isSeeMore;

  const NewWavesUserDetailsPopup({
    super.key,
    required this.isLoading,
    required this.onTapDeclineOrAccept,
    required this.isSeeMore,
    required this.onTapSeeMoreTxt,
  });

  @override
  Widget build(BuildContext context) {
    final lsitOfInfo = [
      _InfoRow(iconPath: IconsPath.locationOutlined, text: 'Ikeja, Lagos'),
      _InfoRow(iconPath: IconsPath.chartFilled, text: 'TTC:  Trying to conceive'),
      _InfoRow(
        iconPath: IconsPath.heartHalfFilled,
        text: 'Interested in: Food delivery, Grocery delivery viudf vugdfv iodfv hdfiu v',
      ),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 10.w),
      decoration: BoxDeco.decRadiusAll(20, clr: c.textOnPrimary),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(itemGap * 2),

          // user details here
          Container(
            decoration: 0.circleBrdr(brdrW: 4, brdrClr: c.secondary.withOpacity(0.5)),
            child: NetworkImageWidget(
              imageUrl: Strings.fakeImageUrl,
              isCircle: true,
              radius: S.w * 0.15,
            ),
          ),
          Gap(itemGap),

          IntrinsicWidth(
            child: ContainerBordered(
              contClr: ctransp,
              child: Row(
                children: [
                  Text(
                    'John Doe, 24',
                    style: TxtStyle.outfitSemiB(fs: 20, w: 600, color: c.primary),
                  ),
                  Gap(3),
                  SvgIcon(iconPath: IconsPath.verifiedTick).mB(10),
                ],
              ),
            ),
          ),
          Gap(itemGap),
          // location text, ttc, interest text section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(
                lsitOfInfo.length,
                (index) => Row(
                  children: [
                    SvgIconColored(iconPath: lsitOfInfo[index].iconPath, height: 18),
                    Gap(itemGap),
                    Expanded(
                      child: Text(
                        lsitOfInfo[index].text.capEachWord(),
                        style: TxtStyle.outfitSmNor,
                      ),
                    ),
                  ],
                ).mB(itemGap),
              ),

              Gap(itemGap),
            ],
          ),

          // a row of 4 pictures here (rad : 12) using NetWorkImageWidget with fake image urls
          Row(
            children: List.generate(4, (_) {
              return Expanded(
                child: AspectRatio(
                  aspectRatio: 1, // 1:1 square
                  child: Padding(
                    padding: 4.pa,
                    child: NetworkImageWidget(radius: 8, imageUrl: Strings.fakeImageUrl),
                  ),
                ),
              );
            }),
          ),
          Gap(itemGap * 2),

          // children section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Strings.children.cap, style: TxtStyle.outfitSemiB(fs: 15, w: 500)),
              Gap(itemGap),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 8.w), // optional padding
                child: Row(
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w), // spacing between items
                      child: IntrinsicWidth(
                        child: ContainerBordered(
                          rad: 30,
                          hp: 12,
                          vp: 6,
                          contClr: c.secondary.withOpacity(0.2),
                          child: Text("👶11 Months".capEachWord(), style: TxtStyle.outfitSmSecNor),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          Gap(itemGap * 3),

          // baout me section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Strings.aboutMe.cap, style: TxtStyle.outfitSemiB(fs: 15, w: 500)),
              Gap(itemGap),
              Obx(() {
                // Show limited lines if collapsed, full text if expanded
                final isExpanded = isSeeMore.value;
                return Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies lacinia, nunc nisl aliquam nisl, eget aliquam nunc nisl eget nunc.",
                  style: TxtStyle.outfitSmSecNor,
                  maxLines: isExpanded ? null : 3,
                  overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                );
              }),

              // See More / See Less button
              CusCircleIconButton(
                onTap: () => onTapSeeMoreTxt(),
                child: Obx(() {
                  final isExpanded = isSeeMore.value;
                  return Text(
                    isExpanded ? Strings.seeLess.cap : Strings.seeMore.cap,
                    style: TxtStyle.outfitSmNor500,
                  );
                }),
              ),
            ],
          ),
          Gap(itemGap * 3),
          // decline and accept buttons
          Row(
            spacing: itemGap * 2,
            children: [
              Expanded(
                child: CustomBtnWTxt(
                  isSmall: true,
                  btnColor: ctransp,
                  borderClr: c.primary,
                  txtClr: c.textSecondary,
                  rad: 12,
                  btnTxt: Strings.decline,
                  isLoading: isLoading,

                  onTap: onTapDeclineOrAccept,
                ),
              ),
              Expanded(
                child: CustomBtnWTxt(
                  isSmall: true,
                  btnColor: c.primary,
                  borderClr: c.primary,
                  txtClr: white,
                  btnTxt: Strings.accept,
                  rad: 12,
                  isLoading: isLoading,

                  onTap: onTapDeclineOrAccept,
                ),
              ),
            ],
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
