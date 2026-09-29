import '../../../../app/helper_widgets_export.dart';
import '../../../../core/models/ui/common_data_models.dart';
import '../../../../core/services/auth/verification_gate.dart';
import '../../../../core/services/push_notification/notification_payload.dart';
import '../../../main_nav/controller/main_nav_controller.dart';
import '../model/notifications_model.dart';

class NotificationRouter {
  /// Universal entry point — works for BOTH:
  ///   - REST notification list tap  (NotificationItemModel)
  ///   - FCM push tap                (NotificationPayload)
  ///
  /// Convert either source to [_NotificationRouteData] first,
  /// then route once from a single switch.

  // ── Public: called from notification list screen (REST) ──────────────────

  static void routeFromModel(NotificationItemModel n) {
    _route(_NotificationRouteData.fromModel(n));
  }

  // ── Public: called from PushNotificationController (FCM) ─────────────────

  static void routeFromPayload(NotificationPayload p) {
    _route(_NotificationRouteData.fromPayload(p));
  }

  // ── Single switch — the ONLY place routing logic lives ───────────────────

  static Future<void> _route(_NotificationRouteData d) async {
    print(
      '🧭 [NotificationRouter] type=${d.type} | '
      'ref=${d.referenceId} | meta=${d.metadata}',
    );

    // Guard: if the navigator isn't mounted yet (cold start), wait for it.
    if (Get.key.currentState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _route(d));
      return;
    }

    if (!await VerificationGate.ensureVerified()) return; // ← add

    switch (d.type) {
      // ─── Like / Comment ───────────────────────────────────────────
      // referenceId = communityId  |  metadata["postId"] = postId
      case NotificationTypes.likePost:
      case NotificationTypes.commentPost:
        final communityId = d.referenceId;
        final postId = d.metadata['postId']?.toString();

        if (communityId == null || communityId.isEmpty) {
          print('⚠️ [NotificationRouter] LIKE/COMMENT — missing communityId');
          return;
        }
        if (postId == null || postId.isEmpty) {
          print('⚠️ [NotificationRouter] LIKE/COMMENT — missing postId');
          return;
        }

        Get.toNamed(
          RoutePaths.postDetails,
          arguments: PostDetailArgModel(
            communityId: communityId,
            postId: postId,
          ),
        );
      // ─── Approve Community ────────────────────────────────────────
      // referenceId = communityId
      case NotificationTypes.approveCommunity:
        final communityId = d.referenceId;

        if (communityId == null || communityId.isEmpty) {
          print(
            '⚠️ [NotificationRouter] APPROVE_COMMUNITY — missing communityId',
          );
          return;
        }

        Get.offAndToNamed(
          RoutePaths.communityDetail,
          arguments: {
            'btnState': MyCommunityBtnState.manage,
            'communityItemId': communityId,
          },
        );

      // ─── Sent Message ─────────────────────────────────────────────
      // referenceId = conversationId  |  metadata["isBlocked"] = bool
      case NotificationTypes.sentMessage:
        final conversationId = d.referenceId;

        if (conversationId == null || conversationId.isEmpty) {
          print(
            '⚠️ [NotificationRouter] SENT_MESSAGE — missing conversationId',
          );
          return;
        }

        final rawBlocked = d.metadata['isBlocked'];
        final isBlocked = rawBlocked is bool
            ? rawBlocked
            : rawBlocked?.toString() == 'true';

        Get.toNamed(
          RoutePaths.chatInbox,
          arguments: ChatInboxArgPassModel(
            chatId: conversationId,
            isBlocked: isBlocked,
          ),
        );

      // ─── Accept Wave ──────────────────────────────────────────────
      case NotificationTypes.acceptWave:
        Get.offAllNamed(RoutePaths.mainNav);
        MainNavController.to.goToTab(1);

      case NotificationTypes.sentWave:
        Get.toNamed(RoutePaths.waveRequest);

      case NotificationTypes.sessionReminder:
        Get.offAllNamed(RoutePaths.mainNav);
        MainNavController.to.goToTab(1);

      // ─── Unhandled ────────────────────────────────────────────────
      default:
        print('⚠️ [NotificationRouter] unhandled type: ${d.type}');
    }
  }
}

// ── Internal normalised data class ────────────────────────────────────────────
// Never expose this — it's just the bridge between the two input models.

class _NotificationRouteData {
  final String type;
  final String? referenceId;
  final Map<String, dynamic> metadata;

  const _NotificationRouteData({
    required this.type,
    this.referenceId,
    this.metadata = const {},
  });

  /// From REST API model (notification list tap)
  factory _NotificationRouteData.fromModel(NotificationItemModel n) {
    return _NotificationRouteData(
      type: n.type ?? '',
      referenceId: n.referenceId,
      metadata: {
        if (n.metadata?.postId != null) 'postId': n.metadata!.postId,
        if (n.metadata?.isBlocked != null) 'isBlocked': n.metadata!.isBlocked,
      },
    );
  }

  /// From FCM push payload
  factory _NotificationRouteData.fromPayload(NotificationPayload p) {
    return _NotificationRouteData(
      type: p.type,
      referenceId: p.referenceId,
      metadata: p.metadata, // already Map<String, dynamic>
    );
  }
}
