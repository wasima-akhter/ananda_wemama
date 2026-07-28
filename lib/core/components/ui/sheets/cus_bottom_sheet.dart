import 'package:we_mama/app/helper_widgets_export.dart';

class CusBottomSheet extends StatelessWidget {
  final void Function()? onTap;
  const CusBottomSheet({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Gap(itemGap * 2),
          Text(
            Strings.location,
            style: TxtStyle.fs18,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          Gap(itemGap * 3),

          CusNameTypeTextFormField(
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            hintStyle: TxtStyle.inter(color: grey200),
            suffix: SvgIcon(iconPath: IconsPath.search).mR(5),
            suffixSize: 20,
            controller: TextEditingController(),
            onTap: onTap,
            hintText: Strings.searchCityOrRegion,
          ),
        ],
      ),
    );
  }
}
