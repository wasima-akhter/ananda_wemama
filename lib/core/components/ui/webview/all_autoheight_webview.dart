import 'package:url_launcher/url_launcher.dart';
import 'package:we_mama/app/helper_widgets_export.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AllAutoheightWebview extends StatelessWidget {
  final String htmlContent;
  final double? fontSize;
  final double? maxHeight;
  final Color backgroundColor;
  final Color? textColor;
  final EdgeInsets padding;
  final bool previewOnly;
  final int previewMaxLines;
  final TextStyle? textStyle;

  AllAutoheightWebview({
    super.key,
    required this.htmlContent,
    this.fontSize,
    this.maxHeight,
    this.backgroundColor = Colors.transparent,
    this.padding = EdgeInsets.zero,
    this.previewOnly = false,
    this.previewMaxLines = 3,
    this.textColor,
    this.textStyle,
  });

  final ValueNotifier<double> _webViewHeight = ValueNotifier(1);

  // String get _textStyleCss {
  //   final style = textStyle;

  //   return '''
  //   font-family: "${style?.fontFamily ?? 'Outfit'}", sans-serif !important;
  //   font-size: ${style?.fontSize ?? 14}px !important;
  //   // font-weight: ${(style?.fontWeight ?? FontWeight.w400).value} !important;
  //   // color: ${_toCssColor(style?.color ?? c.foregroundSecondary)} !important;
  //   // line-height: ${style?.height ?? 1.5} !important;
  //   // letter-spacing: ${style?.letterSpacing ?? 0}px !important;
  // ''';
  // }

  String get _plainText {
    return htmlContent
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'&nbsp;'), ' ')
        .replaceAll(RegExp(r'&amp;'), '&')
        .replaceAll(RegExp(r'&lt;'), '<')
        .replaceAll(RegExp(r'&gt;'), '>')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _toCssColor(Color color) {
    if (color == Colors.transparent) return 'transparent';
    return 'rgba(${color.red},${color.green},${color.blue},${color.opacity})';
  }

  String get _bgCss {
    if (backgroundColor == Colors.transparent) return 'transparent';
    final hex = backgroundColor.value.toRadixString(16).padLeft(8, '0');
    return '#${hex.substring(2)}';
  }

  String get _paddingCss =>
      '${padding.top}px ${padding.right}px ${padding.bottom}px ${padding.left}px';

  @override
  Widget build(BuildContext context) {
    if (previewOnly) {
      return Padding(
        padding: padding,
        child: Text(
          _plainText,
          maxLines: previewMaxLines,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: (fontSize ?? 13).sp,
            height: 1.6,
            color: textColor ?? c.foregroundSecondary,
          ),
        ),
      );
    }

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(backgroundColor)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            // allow initial about:blank load
            if (request.url == 'about:blank')
              return NavigationDecision.navigate;
            final uri = Uri.tryParse(request.url);
            if (uri != null) {
              try {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } catch (e) {
                print("Could not launch URL: $uri, error: $e");
              }
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..addJavaScriptChannel(
        'HeightChannel',
        onMessageReceived: (message) {
          final parsed = double.tryParse(message.message) ?? S.h * 4;
          // clamp to maxHeight, minimum 100
          _webViewHeight.value = parsed.clamp(100, maxHeight ?? S.h * 0.5);
        },
      )
      ..loadHtmlString("""
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
  html, body {
      margin: 0 !important;
    padding: $_paddingCss !important;
    background: ${_toCssColor(backgroundColor)} !important;
    font-family: 'Outfit', sans-serif !important;
    font-size: ${(fontSize ?? 14).sp}px !important;
    color: ${_toCssColor(textColor ?? c.foregroundSecondary)} !important;
    word-wrap: break-word;
     overflow: hidden !important;
  touch-action: pan-y !important;  /* pass vertical scroll to Flutter */
  -webkit-overflow-scrolling: auto !important;
  }

  /* ✅ Nuke all inline backgrounds and font overrides from Word/web editors */
  * {
    background-color: transparent !important;
    background: transparent !important;
    max-width: 100% !important;
    box-sizing: border-box !important;
    font-family: 'Outfit', sans-serif !important;
    color: inherit !important;
  }

  img, table, iframe, video {
    max-width: 100% !important;
    height: auto !important;
  }

  a {
    color: blue !important;
    text-decoration: underline;
    word-break: break-word;
  }

  /* Collapse empty paragraphs from Word paste */
  p:empty, li:empty { display: none; }
</style>
</head>
<body>
$htmlContent
<script>
  // Prevent WebView from consuming touch scroll events
  document.addEventListener('touchmove', function(e) {
    e.stopPropagation();
  }, { passive: true });

  function sendHeight() {
    const h = Math.max(
      document.body.scrollHeight,
      document.documentElement.scrollHeight,
      document.body.offsetHeight,
      document.documentElement.offsetHeight
    );
    HeightChannel.postMessage(String(h));
  }

  // Fire multiple times to catch late-loading content
  window.addEventListener('load', () => {
    sendHeight();
    setTimeout(sendHeight, 300);
    setTimeout(sendHeight, 800);
    setTimeout(sendHeight, 1500);
  });

  window.addEventListener('resize', sendHeight);

  document.querySelectorAll('img').forEach(img => {
    img.addEventListener('load', sendHeight);
    img.addEventListener('error', sendHeight);
  });
</script>
</body>
</html>
""");

    return ValueListenableBuilder<double>(
      valueListenable: _webViewHeight,
      builder: (context, height, _) {
        final isLoading = height <= 10;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isLoading
              ? SizedBox(
                  key: const ValueKey("loader"),
                  height: 120,
                  child: const Center(child: LoadingPrimary()),
                )
              : SizedBox(
                  key: const ValueKey("webview"),
                  width: double.infinity,
                  height: height,
                  child: // ✅ Pass vertical scroll gestures up to Flutter's scroll view
                  GestureDetector(
                    onHorizontalDragUpdate: (_) {},
                    child: WebViewWidget(controller: controller),
                  ),
                ),
        );
      },
    );
  }
}
