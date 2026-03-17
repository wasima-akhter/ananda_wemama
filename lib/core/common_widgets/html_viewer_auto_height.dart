import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/extension/context_extension.dart';

/*
class SafeAutoHeightWebView extends StatelessWidget {
  final String htmlContent;
  final double? fontSize;
  final double maxHeight;
  final double fixedHeightForHuge;

  SafeAutoHeightWebView({
    super.key,
    required this.htmlContent,
    this.fontSize,
    this.maxHeight = 2000,
    this.fixedHeightForHuge = 500,
  });

  final ValueNotifier<double> _webViewHeight = ValueNotifier(1);

  double get _scale {
    final length = htmlContent.length;
    final divCount = RegExp(r"<div>").allMatches(htmlContent).length;
    final blockquoteCount = RegExp(r"<blockquote>").allMatches(htmlContent).length;
    final score = length + divCount * 50 + blockquoteCount * 100;

    debugPrint("HTML score: $score");
    if (score > 15000) return 0.3; // very huge
    if (score > 5000) return 0.5; // large
    return 1.0; // normal
  }

  @override
  Widget build(BuildContext context) {
    final scale = _scale;

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true) // 🔥 REQUIRED
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final uri = Uri.tryParse(request.url);
            if (uri != null) {
              try {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } catch (e) {
                debugPrint("Could not launch URL: $uri, error: $e");
              }
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..addJavaScriptChannel(
        'HeightChannel',
        onMessageReceived: (message) {
          double parsedHeight = double.tryParse(message.message) ?? 100;
          if (parsedHeight > maxHeight) parsedHeight = fixedHeightForHuge;
          _webViewHeight.value = parsedHeight;
        },
      )
      ..loadHtmlString("""
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, minimum-scale=0.3, user-scalable=yes">
<style>
  body {
    margin:0;
    padding:0;
    font-family: sans-serif;
    ${fontSize != null ? "font-size: ${fontSize}px;" : ""}
    word-wrap: break-word;
    ${scale < 1.0 ? "transform-origin: top left; transform: scale($scale); width: ${100 / scale}%;" : ""}
  }
  img, table, iframe, video { max-width: 100%; height:auto; }
  a { color: blue; text-decoration: underline; word-break: break-word; }
</style>
</head>
<body>
$htmlContent
<script>
  function updateHeight() {
    let h = document.body.scrollHeight;
    if($scale < 1.0) h = h * $scale; // scale for heavy content
    HeightChannel.postMessage(h);
  }
  window.onload = () => { updateHeight(); setTimeout(updateHeight, 500); };
  window.onresize = updateHeight;
  document.querySelectorAll("img").forEach(img => { img.onload = updateHeight; img.onerror = updateHeight; });
</script>
</body>
</html>
""");

    return ValueListenableBuilder<double>(
      valueListenable: _webViewHeight,
      builder: (context, height, _) {
        final isLoading = height <= 10;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isLoading
              ? SizedBox(
                  key: const ValueKey("loader"),
                  height: 120,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : SizedBox(
                  key: const ValueKey("webview"),
                  width: MediaQuery.of(context).size.width,
                  height: height,
                  child: WebViewWidget(controller: controller),
                ),
        );
      },
    );
  }
}


*/
class SafeAutoHeightWebView extends StatelessWidget {
  final double? height;
  final String description;

  const SafeAutoHeightWebView({super.key, this.height, required this.description});

  @override
  Widget build(BuildContext context) {
    return // Display HTML using flutter_html
    Html(
      data: description.trim().isNotEmpty ? description : "<p>No description available.</p>",
      onLinkTap: (url, _, __) async {
        if (url != null) {
          final uri = Uri.tryParse(url);
          if (uri != null) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(14),
          lineHeight: LineHeight(1.6),
          color: c.secondary,
          fontFamily: GoogleFonts.outfit(color: c.secondary).fontFamily,
        ),
        "p": Style(margin: Margins.symmetric(vertical: 8)),
        "img": Style(width: Width(100, Unit.percent), height: Height.auto()),
      },
    );
  }
}
