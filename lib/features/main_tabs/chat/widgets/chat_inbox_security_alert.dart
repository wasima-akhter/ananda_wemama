import '../../../../app/helper_widgets_export.dart';

class ChatInboxSecurityAlert extends StatelessWidget {
  final String name;
  const ChatInboxSecurityAlert({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.backgroundSecondary,
      vp: 12,
      hp: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            spacing: itemGap,

            children: [
              SvgIcon(iconPath: IconsPath.security, height: 22),

              Text(
                Strings.securityAlert,
                style: TxtStyle.inter(w: 600, fs: 13),
              ),
            ],
          ),
          Gap(itemGap),
          Text(
            ("${Strings.securityAlertMsgPart1} $name ${Strings.securityAlertMsgPart2}")
                .capEachWord(),
            style: TxtStyle.inter(w: 400, color: c.secondary, fs: 11),
          ),
        ],
      ),
    );
  }
}
