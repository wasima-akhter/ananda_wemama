import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_mama/app/helper_widgets_export.dart';
import 'package:url_launcher/url_launcher.dart';

class SafeAutoHeightWebView extends StatelessWidget {
  final String description;
  final bool previewOnly; // ✅ new
  final int previewMaxLines; // ✅ new

  const SafeAutoHeightWebView({
    super.key,
    required this.description,
    this.previewOnly = false,
    this.previewMaxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    /// Strip ALL inline styles, classes, and MS Word junk — keep only structure
    String sanitize(String html) {
      return html
          .replaceAll(RegExp(r'style="[^"]*"'), '') // remove inline styles
          .replaceAll(RegExp(r"style='[^']*'"), '') // single-quote styles
          .replaceAll(RegExp(r'class="[^"]*"'), '') // remove classes
          .replaceAll(
            RegExp(
              r'class=\'
              '['
              '^\']'
              '*\'',
            ),
            '',
          )
          .replaceAll(RegExp(r'<span[^>]*>'), '<span>') // flatten spans
          .replaceAll(RegExp(r'<div[^>]*>'), '') // strip div wrappers
          .replaceAll(RegExp(r'</div>'), '')
          .replaceAll(RegExp(r'&nbsp;'), ' ')
          .replaceAll(RegExp(r'\s{2,}'), ' '); // collapse whitespace
    }

    String toPlainText(String html) {
      return sanitize(html)
          .replaceAll(RegExp(r'<[^>]*>'), ' ')
          .replaceAll(RegExp(r'&amp;'), '&')
          .replaceAll(RegExp(r'&lt;'), '<')
          .replaceAll(RegExp(r'&gt;'), '>')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
    }

    if (previewOnly) {
      return Text(
        toPlainText(description),
        maxLines: previewMaxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          color: c.secondary,
          fontFamily: GoogleFonts.outfit().fontFamily,
        ),
      );
    }

    final outfitFamily = GoogleFonts.outfit().fontFamily;

    final sanitized = sanitize(
      description.trim().isNotEmpty
          ? description
          : "<p>No description available.</p>",
    );
    return // Display HTML using flutter_html
    Html(
      // data: description.trim().isNotEmpty ? description : "<p>No description available.</p>",
      data: sanitized,
      onLinkTap: (url, _, _) async {
        if (url != null) {
          final uri = Uri.tryParse(url);
          if (uri != null)
            await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },

      style: {
        // ✅ Force app theme — no white bg, no Word fonts
        "*": Style(
          fontFamily: outfitFamily,
          color: c.foregroundPrimary,
          backgroundColor: Colors.transparent,
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        "body": Style(
          fontSize: FontSize(14.sp),
          lineHeight: LineHeight(1.6),

          backgroundColor: Colors.transparent,
          margin: Margins.zero,
          padding: HtmlPaddings.all(8),
        ),
        "p": Style(margin: Margins.only(bottom: 10), fontSize: FontSize(14.sp)),
        "h1": Style(
          fontSize: FontSize(20.sp),
          fontWeight: FontWeight.w700,
          margin: Margins.only(bottom: 8),
        ),
        "h2": Style(
          fontSize: FontSize(18.sp),
          fontWeight: FontWeight.w700,
          margin: Margins.only(bottom: 8),
        ),
        "h3": Style(
          fontSize: FontSize(16.sp),
          fontWeight: FontWeight.w600,
          margin: Margins.only(bottom: 6),
        ),
        "strong": Style(fontWeight: FontWeight.w700, color: c.secondary),
        "em": Style(fontStyle: FontStyle.italic),
        "ul": Style(margin: Margins.only(left: 12, bottom: 8)),
        "ol": Style(margin: Margins.only(left: 12, bottom: 8)),
        "li": Style(fontSize: FontSize(14.sp), margin: Margins.only(bottom: 6)),
        "a": Style(color: c.primary, textDecorationColor: c.primary),
        "img": Style(width: Width(100, Unit.percent), height: Height.auto()),
        "span": Style(backgroundColor: Colors.transparent),
        "div": Style(backgroundColor: Colors.transparent),
      },
    );
  }
}
