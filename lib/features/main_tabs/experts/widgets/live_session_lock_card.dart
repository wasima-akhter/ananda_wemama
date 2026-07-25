import '../../../../app/helper_widgets_export.dart';

class LiveSessionLockedCard extends StatelessWidget {
  final VoidCallback onTap;

  const LiveSessionLockedCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: S.h * 0.25,
      child: GestureDetector(
        onTap: onTap,
        child: ContainerBordered(
          contClr: newCardClr,
          rad: 20,
          hp: 16,
          vp: 16,
          boxShadow: boxShadowBottom(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, color: c.primary),
              Gap(itemGap),
              Text(
                'This live session is for premium members',
                textAlign: TextAlign.center,
                style: TxtStyle.outfit(fs: 14, w: 600, color: c.primary),
              ),
              Gap(itemGap),
              Text(
                'Upgrade to join',
                style: TxtStyle.outfit(fs: 13, w: 500, color: c.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
