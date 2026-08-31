import 'package:we_mama/core/helpers/date_helper.dart';

import '../../../../app/helper_widgets_export.dart';
import '../model/expert_session_list_model.dart';
import 'session_video_dialog.dart';

class SessionComponent extends StatelessWidget {
  final Session session;
  final bool isFromExpertScreen;

  const SessionComponent({
    super.key,
    required this.session,
    this.isFromExpertScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      // w: S.w * .4,
      contClr: const Color(0xFFE6D6CD),
      rad: 14,
      hp: 8,
      vp: 12,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  NetworkImageWidget(
                    imageUrl: session.expert?.image ?? "",
                    isCircle: true,
                    radius: 20,
                  ),
                  const Gap(10),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ////
                      Text(
                        (session.expert?.name ?? "").capEachWord(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TxtStyle.outfit(
                          fs: 14,
                          w: 600,
                          color: c.textPrimary,
                        ),
                      ),

                      Text(
                        session.expert?.profession?.designation.join(", ") ??
                            "",
                        style: TxtStyle.outfit(fs: 12, color: c.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const Gap(10),

                      Text(
                        session.title.capEachWord(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TxtStyle.outfitSemiB(
                          fs: 14,
                          w: 500,
                          color: c.textPrimary,
                        ),
                      ),

                      const Gap(6),

                      Text(
                        "${DateHelper().formatUTCtimestamp(session.dateTime.toString()).date}\n${DateHelper().formatUTCtimestamp(session.dateTime.toString()).time}",
                        style: TxtStyle.outfit(fs: 11, color: c.secondary),
                      ),
                    ],
                  ),
                ],
              ),

              // Small affordance so it's obvious the card opens a video
              // Dead-center over the whole card
              if (!isFromExpertScreen)
                Positioned.fill(
                  child: Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => SessionVideoDialog.show(session),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ).mR(8);
  }
}
