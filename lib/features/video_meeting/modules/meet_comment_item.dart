import '../../../app/helper_widgets_export.dart';
// import '../../../core/components/ui/dropdowns/cus_flexible_dropdown.dart';
// import '../../../core/helpers/widgets_helper.dart';
import '../../../core/components/ui/dropdowns/cus_flexible_dropdown.dart';
import '../../../core/helpers/widgets_helper.dart';
import '../model/chat_message_live_model.dart';

// class MeetCommentItem extends StatelessWidget {
//   final ChatMessageLiveModel message;
//   const MeetCommentItem({super.key, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         NetworkImageWidget(imageUrl: Strings.fakeImageUrl, isCircle: true, radius: 18),

//         Gap(10),

//         Flexible(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text("Darrell Steward", style: TxtStyle.outfit(fs: 13, w: 600)),
//                   Gap(6),
//                   Text("11:16 pm", style: TxtStyle.outfit(fs: 11, color: c.textSecondary)),
//                 ],
//               ),

//               Gap(4),

//               Text(
//                 "However Rare Side Effects Observed Among Children Can Be Metabolic Acidosis, Coma, Respiratory Depression",
//                 style: TxtStyle.outfit(fs: 12),
//               ),
//             ],
//           ),
//         ),

//         CusFlexibleDropdown(
//           items: [
//             CusDropdownItem(
//               title: Strings.reportContent,
//               onTap: () async => await showReportBottomSheet(),
//             ),
//           ],
//           child: SvgIconColored(iconPath: IconsPath.moreVertical, height: 20),
//         ),
//       ],
//     );
//   }
// }

// class MeetCommentItem extends StatelessWidget {
//   final ChatMessageLiveModel message;
//   const MeetCommentItem({super.key, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     final time = TimeOfDay.fromDateTime(message.timestamp).format(context);

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         if (!message.isMe) ...[_avatar(message.senderAvatar), Gap(8)],
//         Flexible(
//           child: Column(
//             crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             children: [
//               if (!message.isMe)
//                 Text(
//                   message.senderName,
//                   style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
//                 ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//                 decoration: BoxDecoration(
//                   color: message.isMe ? c.primary : c.cardPrimary,
//                   borderRadius: BorderRadius.circular(16.r),
//                 ),
//                 child: Text(
//                   message.text,
//                   style: TextStyle(fontSize: 13.sp, color: message.isMe ? white : c.textPrimary),
//                 ),
//               ),
//               Gap(2),
//               Text(
//                 time, // ← formatted timestamp
//                 style: TextStyle(fontSize: 10.sp, color: c.textSecondary),
//               ),
//             ],
//           ),
//         ),
//         if (message.isMe) ...[Gap(8), _avatar(message.senderAvatar)],
//       ],
//     );
//   }

//   Widget _avatar(String avatarUrl) {
//     return avatarUrl.isNotEmpty
//         ? CircleAvatar(radius: 14.r, backgroundImage: NetworkImage(avatarUrl))
//         : CircleAvatar(
//             radius: 14.r,
//             backgroundColor: c.primary,
//             child: Icon(Icons.person, size: 14.r, color: white),
//           );
//   }
// }

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
                      message.senderName.isNotEmpty ? message.senderName : "Unknown User",
                      style: TxtStyle.outfit(
                        fs: 13,
                        w: 600,
                        color: message.isMe ? c.primary : c.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Gap(6),

                  Text(time, style: TxtStyle.outfit(fs: 11, color: c.textSecondary)),
                ],
              ),

              Gap(4),

              /// 📝 Message
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: message.isMe ? c.primary.withOpacity(.1) : c.cardPrimary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  message.text.isNotEmpty ? message.text : "No message",
                  style: TxtStyle.outfit(fs: 12, color: c.textPrimary),
                ),
              ),
            ],
          ),
        ),

        /// ⋮ Menu (only for others OR optional for all)
        CusFlexibleDropdown(
          items: [
            CusDropdownItem(
              title: Strings.reportContent,
              onTap: () async => await showReportBottomSheet(),
            ),
          ],
          child: Padding(
            padding: EdgeInsets.only(left: 6.w),
            child: SvgIconColored(iconPath: IconsPath.moreVertical, height: 20),
          ),
        ),
      ],
    );
  }

  /// Avatar widget
  Widget _avatar(String avatarUrl) {
    /// fallback avatar
    return NetworkImageWidget(imageUrl: avatarUrl, isCircle: true);
  }
}
