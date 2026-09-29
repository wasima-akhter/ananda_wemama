import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:we_mama/core/helpers/date_helper.dart';

import '../../../features/main_tabs/experts/model/expert_session_list_model.dart';

class ShareUtil {
  Future<void> shareCommunity(String title, String url) async {
    await SharePlus.instance.share(ShareParams(text: "$title\n$url"));
  }
}

class ShareService {
  static Future<void> shareSession(Session session) async {
    print('=== ShareService.shareSession() started ===');

    try {
      final link = session.deepLinkUrl ?? '';
      print('Deep link: "$link"');

      if (link.isEmpty) {
        print('❌ Share aborted: deepLinkUrl is empty');
        return;
      }

      final title = session.title.isNotEmpty ? session.title : 'Live Session';
      final hostName = session.expert?.name ?? 'Expert';
      final profession = session.expert?.profession?.title ?? '';
      final description = session.description.isNotEmpty
          ? session.description
          : 'Join us for an engaging live session with expert insights and discussion.';

      final dateFormatted = session.dateTime != null
          ? DateHelper().formatUTCtimestamp(session.dateTime.toString()).date
          : '--';

      final timeFormatted = session.dateTime != null
          ? DateHelper().formatUTCtimestamp(session.dateTime.toString()).time
          : '--';

      print('Title: $title');
      print('Host: $hostName');
      print('Profession: $profession');
      print('Date: $dateFormatted');
      print('Time: $timeFormatted');

      // ─── Plain text (WhatsApp, SMS, Telegram, etc.) ───────────────────
      final plainText =
          '''
📢 LIVE SESSION INVITATION

═══════════════════════════════
🎓 $title
═══════════════════════════════

👤 Host:  $hostName
${profession.isNotEmpty ? '💼 Profession:  $profession\n' : ''}
📅 Date:  $dateFormatted
⏰ Time:  $timeFormatted

📝 About This Session
──────────────────────
$description

🔗 Join Session
──────────────────────
$link

═══════════════════════════════
We look forward to seeing you there.
Best regards, $hostName
''';

      // ─── HTML (Gmail, Outlook, Apple Mail) ────────────────────────────
      final htmlBody =
          '''
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>$title</title>
  </head>
  <body style="margin:0;padding:0;background-color:#f4f4f4;font-family:Arial,sans-serif;">

    <table width="100%" cellpadding="0" cellspacing="0" style="background:#f4f4f4;padding:30px 0;">
      <tr>
        <td align="center">
          <table width="600" cellpadding="0" cellspacing="0"
            style="background:#ffffff;border-radius:12px;overflow:hidden;
                   box-shadow:0 2px 8px rgba(0,0,0,0.08);max-width:600px;width:100%;">

            <!-- Header -->
            <tr>
              <td style="background:linear-gradient(135deg,#7B5EA7,#5B3F8C);
                         padding:32px 40px;text-align:center;">
                <p style="margin:0 0 8px;font-size:12px;color:#d4bfff;
                           letter-spacing:2px;text-transform:uppercase;">
                  You're Invited
                </p>
                <h1 style="margin:0;font-size:24px;color:#ffffff;
                            font-weight:700;line-height:1.3;">
                  $title
                </h1>
                <span style="display:inline-block;margin-top:14px;
                             background:#FF4757;color:#fff;
                             font-size:12px;font-weight:700;
                             padding:4px 14px;border-radius:20px;
                             letter-spacing:1px;">
                  🔴 LIVE SESSION
                </span>
              </td>
            </tr>

            <!-- Host Info -->
            <tr>
              <td style="padding:28px 40px 0;">
                <table width="100%" cellpadding="0" cellspacing="0"
                  style="background:#f9f5ff;border-radius:10px;padding:16px 20px;">
                  <tr>
                    <td>
                      <p style="margin:0 0 4px;font-size:11px;color:#9B8BB0;
                                 text-transform:uppercase;letter-spacing:1px;">
                        Hosted By
                      </p>
                      <p style="margin:0;font-size:18px;color:#2d1b4e;
                                 font-weight:700;">
                        $hostName
                      </p>
                      ${profession.isNotEmpty ? '''
                      <p style="margin:4px 0 0;font-size:13px;color:#7B5EA7;">
                        $profession
                      </p>''' : ''}
                    </td>
                  </tr>
                </table>
              </td>
            </tr>

            <!-- Date & Time -->
            <tr>
              <td style="padding:20px 40px 0;">
                <table width="100%" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="50%" style="padding-right:8px;">
                      <table width="100%" style="background:#f0f0f0;
                             border-radius:8px;padding:12px 16px;">
                        <tr>
                          <td>
                            <p style="margin:0 0 2px;font-size:11px;
                                       color:#888;text-transform:uppercase;
                                       letter-spacing:1px;">
                              📅 Date
                            </p>
                            <p style="margin:0;font-size:14px;
                                       color:#2d1b4e;font-weight:600;">
                              $dateFormatted
                            </p>
                          </td>
                        </tr>
                      </table>
                    </td>
                    <td width="50%" style="padding-left:8px;">
                      <table width="100%" style="background:#f0f0f0;
                             border-radius:8px;padding:12px 16px;">
                        <tr>
                          <td>
                            <p style="margin:0 0 2px;font-size:11px;
                                       color:#888;text-transform:uppercase;
                                       letter-spacing:1px;">
                              ⏰ Time
                            </p>
                            <p style="margin:0;font-size:14px;
                                       color:#2d1b4e;font-weight:600;">
                              $timeFormatted
                            </p>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>

            <!-- Description -->
            <tr>
              <td style="padding:20px 40px 0;">
                <p style="margin:0 0 8px;font-size:11px;color:#9B8BB0;
                           text-transform:uppercase;letter-spacing:1px;">
                  About This Session
                </p>
                <p style="margin:0;font-size:14px;color:#444;line-height:1.7;">
                  $description
                </p>
              </td>
            </tr>

            <!-- CTA Button -->
            <tr>
              <td style="padding:28px 40px;" align="center">
                <a href="$link"
                   style="display:inline-block;background:linear-gradient(135deg,#7B5EA7,#5B3F8C);
                          color:#ffffff;text-decoration:none;
                          font-size:16px;font-weight:700;
                          padding:14px 40px;border-radius:30px;
                          letter-spacing:0.5px;">
                  🔗 Join Live Session
                </a>
              </td>
            </tr>

            <!-- Footer -->
            <tr>
              <td style="background:#f9f5ff;padding:20px 40px;
                         text-align:center;border-top:1px solid #ede8f5;">
                <p style="margin:0;font-size:12px;color:#aaa;line-height:1.6;">
                  You received this because someone shared a live session with you.<br/>
                  Best regards, <strong style="color:#7B5EA7;">$hostName</strong>
                </p>
              </td>
            </tr>

          </table>
        </td>
      </tr>
    </table>

  </body>
</html>
''';

      print('🚀 Invoking SharePlus.instance.share()...');

      final result = await SharePlus.instance.share(
        ShareParams(
          text: plainText, // used by WhatsApp, Telegram, SMS, etc.
          subject:
              '🎓 $title — Live Session Invitation', // used by email clients
          // html is not directly supported by share_plus,
          // but subject + text covers most cases.
          // For true HTML email, use url_launcher to open mailto:
        ),
      );

      print('✅ Share dialog completed');
      print('Share result status: ${result.status}');
      print('Raw share result: $result');

      if (result.status == ShareResultStatus.success) {
        print('✅ User completed sharing');
      } else if (result.status == ShareResultStatus.dismissed) {
        print('⚠️ User dismissed the share sheet');
      } else {
        print('ℹ️ Share result: ${result.status}');
      }
    } catch (e, stackTrace) {
      print('❌ Error while sharing session');
      print('Error: $e');
      print('StackTrace: $stackTrace');
    }

    print('=== ShareService.shareSession() finished ===');
  }

  // ─── HTML email via mailto: (true rich email) ──────────────────────────────
  static Future<void> shareViaEmail(Session session) async {
    print('=== ShareService.shareViaEmail() started ===');

    final title = session.title.isNotEmpty ? session.title : 'Live Session';
    final hostName = session.expert?.name ?? 'Expert';
    final link = session.deepLinkUrl ?? '';

    final subject = Uri.encodeComponent('🎓 $title — Live Session Invitation');
    final body = Uri.encodeComponent('''
You're invited to a live session: $title
Hosted by: $hostName

Join here: $link
''');

    final mailtoUri = Uri.parse('mailto:?subject=$subject&body=$body');

    print('mailto URI: $mailtoUri');

    if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(mailtoUri);
      print('✅ Email client opened');
    } else {
      print('❌ No email client available');
    }

    print('=== ShareService.shareViaEmail() finished ===');
  }
}
