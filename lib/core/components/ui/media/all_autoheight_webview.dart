import 'package:mama_app/app/helper_widgets_export.dart';
import 'package:url_launcher/url_launcher.dart';
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
                log("Could not launch URL: $uri, error: $e");
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
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
<style>
  html, body {
      margin: 0 !important;
    padding: $_paddingCss !important;
    background: ${_toCssColor(backgroundColor)} !important;
    font-family: 'Outfit', sans-serif !important;
    font-size: ${(fontSize ?? 13).sp}px !important;
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

class SimpleWebViewWidget extends StatelessWidget {
  final String htmlContent;
  final double? height;
  final double? fontSize;
  final Color backgroundColor;
  final Color? textColor;
  final EdgeInsets padding;

  SimpleWebViewWidget({
    super.key,
    required this.htmlContent,
    this.height,
    this.fontSize,
    this.backgroundColor = Colors.transparent,
    this.textColor,
    this.padding = EdgeInsets.zero,
  });

  String _toCssColor(Color color) {
    if (color == Colors.transparent) return 'transparent';
    return 'rgba(${color.red},${color.green},${color.blue},${color.opacity})';
  }

  String get _paddingCss =>
      '${padding.top}px ${padding.right}px ${padding.bottom}px ${padding.left}px';

  String scrollbarColor =
      '#${c.primary.withValues(alpha: 0.5).toARGB32().toRadixString(16).substring(2)}';

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(backgroundColor)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            if (request.url == 'about:blank') {
              return NavigationDecision.navigate;
            }

            final uri = Uri.tryParse(request.url);

            if (uri != null) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadHtmlString("""
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
html, body {
  margin: 0;
  padding: $_paddingCss;
  background: ${_toCssColor(backgroundColor)};
  font-family: 'Outfit', sans-serif;
  font-size: ${(fontSize ?? 13).sp}px;
  color: ${_toCssColor(textColor ?? c.primary)};

  height: 100%;
  overflow: hidden;
}




#content {
  height: 100vh;
  overflow-y: auto;
  padding-right: 16px; /* gap between content and scrollbar */
}

* {
  max-width: 100%;
  box-sizing: border-box;
}

img, iframe, table, video {
  max-width: 100% !important;
  height: auto !important;
}

a {
  color: blue;
  text-decoration: underline;
}


/* Width */
::-webkit-scrollbar {
  width: 6px;
}

/* Track */
::-webkit-scrollbar-track {
  background: rgba(0,0,0,0.08);
  border-radius: 10px;
}

/* Thumb */
::-webkit-scrollbar-thumb {
  background: $scrollbarColor;
  border-radius: 10px;
}

/* Hover */
::-webkit-scrollbar-thumb:hover {
  background: #9B6DE3;
}
</style>
</head>
<body>
  <div id="content">
    $htmlContent
  </div>


</body>
</html>
""");

    if (height != null) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: WebViewWidget(controller: controller),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: WebViewWidget(controller: controller),
    );
  }
}

class HybridWebViewWidget extends StatefulWidget {
  final String htmlContent;
  final double? fontSize;
  final Color backgroundColor;
  final Color? textColor;
  final EdgeInsets padding;

  const HybridWebViewWidget({
    super.key,
    required this.htmlContent,
    this.fontSize,
    this.backgroundColor = Colors.transparent,
    this.textColor,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<HybridWebViewWidget> createState() => _HybridWebViewWidgetState();
}

class _HybridWebViewWidgetState extends State<HybridWebViewWidget> {
  String _toCssColor(Color color) {
    if (color == Colors.transparent) return 'transparent';

    return 'rgba('
        '${color.red},'
        '${color.green},'
        '${color.blue},'
        '${color.opacity}'
        ')';
  }

  String get _paddingCss =>
      '${widget.padding.top}px '
      '${widget.padding.right}px '
      '${widget.padding.bottom}px '
      '${widget.padding.left}px';

  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    final scrollbarColor =
        '#${c.primary.withValues(alpha: 0.5).toARGB32().toRadixString(16).substring(2)}';

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(widget.backgroundColor)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            if (request.url == 'about:blank') {
              return NavigationDecision.navigate;
            }

            final uri = Uri.tryParse(request.url);

            if (uri != null) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..addJavaScriptChannel(
        'HeightChannel',
        onMessageReceived: (message) {
          final contentHeight =
              double.tryParse(message.message) ?? double.infinity;
        },
      )
      ..loadHtmlString("""
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>

html, body {
  margin: 0;
  padding: $_paddingCss;
  background: ${_toCssColor(widget.backgroundColor)};
  font-family: 'Outfit', sans-serif;
  font-size: ${widget.fontSize ?? 14}px;
  color: ${_toCssColor(widget.textColor ?? c.foregroundSecondary)};
}

* {
  max-width: 100%;
  box-sizing: border-box;
}

img, iframe, table, video {
  max-width: 100% !important;
  height: auto !important;
}

a {
  color: blue;
  text-decoration: underline;
}

#content {
  overflow-y: auto;
}


/* Width */
::-webkit-scrollbar {
  width: 6px;
}

/* Track */
::-webkit-scrollbar-track {
  background: rgba(0,0,0,0.08);
  border-radius: 10px;
}

/* Thumb */
::-webkit-scrollbar-thumb {
  background: $scrollbarColor;
  border-radius: 10px;
}

/* Hover */
::-webkit-scrollbar-thumb:hover {
  background: #9B6DE3;
}

</style>
</head>

<body>

<div id="content">
${widget.htmlContent}
</div>

<script>

function sendHeight() {
  const height = document.documentElement.scrollHeight;
  HeightChannel.postMessage(height.toString());
}

window.onload = sendHeight;

setTimeout(sendHeight, 300);
setTimeout(sendHeight, 1000);

if (document.fonts) {
  document.fonts.ready.then(sendHeight);
}

</script>

</body>
</html>
""");
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: double.infinity,
      width: double.infinity,
      child: WebViewWidget(controller: controller),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
