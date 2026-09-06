import '../../../app/helper_widgets_export.dart';
import '../model/chat_message_live_model.dart';

class MeetCommentItem extends StatelessWidget {
  final ChatMessageLiveModel message;

  const MeetCommentItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(message.timestamp).format(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 👤 Avatar
        _avatar(message.senderAvatar),

        Gap(10),

        /// 💬 Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🧑 Name + Time
              Row(
                children: [
                  Expanded(
                    child: Text(
                      message.senderName.isNotEmpty
                          ? message.senderName
                          : "Unknown User",
                      style: TxtStyle.outfit(
                        fs: 14,
                        w: 600,
                        color: message.isMe ? c.primary : c.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Gap(6),

                  Text(
                    time,
                    style: TxtStyle.outfit(fs: 11, color: c.textSecondary),
                  ),
                ],
              ),

              Gap(4),

              /// 📝 Message
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: message.isMe
                      ? c.primary.withOpacity(.1)
                      : c.cardPrimary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  message.text.isNotEmpty ? message.text : "No message",
                  style: TxtStyle.outfit(fs: 14, color: c.textPrimary),
                ),
              ),
            ],
          ),
        ),

        /// ⋮ Menu (only for others OR optional for all)
        // CusFlexibleDropdown(
        //   items: [
        //     CusDropdownItem(
        //       title: Strings.reportContent,
        //       onTap: () async => await showReportBottomSheet(),
        //     ),
        //   ],
        //   child: Padding(
        //     padding: EdgeInsets.only(left: 6.w),
        //     child: SvgIconColored(iconPath: IconsPath.moreVertical, height: 20),
        //   ),
        // ),
      ],
    );
  }

  /// Avatar widget
  Widget _avatar(String avatarUrl) {
    /// fallback avatar
    return NetworkImageWidget(imageUrl: avatarUrl, isCircle: true);
  }
}
