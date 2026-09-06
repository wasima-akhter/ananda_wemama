//
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../app/helper_widgets_export.dart';

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

/* Force everything to wrap, never overflow horizontally */
html, body {
  margin: 0;
  padding: $_paddingCss;
  background: ${_toCssColor(widget.backgroundColor)};
  font-family: 'Outfit', sans-serif;
  font-size: ${widget.fontSize ?? 14}px;
  color: ${_toCssColor(widget.textColor ?? c.foregroundSecondary)};

  overflow-x: hidden;

  word-wrap: break-word;
  overflow-wrap: break-word;
}

#content {
  width: 100%;
  overflow-wrap: break-word;
  word-wrap: break-word;
}

#content * {
  max-width: 100% !important;
  box-sizing: border-box;
}


body {
  line-break: auto;
  text-wrap: wrap;
  text-align: left;
}

* {
  max-width: 100%;
  box-sizing: border-box;

  /* ❌ remove word-break: break-word */
  word-break: normal;

  /* ✅ only break long unbreakable strings */
  overflow-wrap: break-word;
}

a {
  overflow-wrap: anywhere;
}

img, iframe, video {
  max-width: 100% !important;
  height: auto !important;
  display: block;
}

/* Tables: most common cause of horizontal overflow */
table {
  width: 100% !important;
  max-width: 100% !important;
  table-layout: fixed !important;   /* 👈 columns respect width, don't expand */
  border-collapse: collapse;
}

td, th {
  overflow-wrap: break-word;
  word-break: normal;
  white-space: normal !important;
}

/* Code blocks: wrap instead of scroll */
pre {
  white-space: pre-wrap !important;
  overflow-wrap: break-word;
  word-break: normal;
}

code {
  overflow-wrap: break-word;
  word-break: normal;
}

p, li, h1, h2, h3 {
  white-space: normal !important;
  overflow-wrap: break-word;
  word-wrap: break-word;
}

ul, ol {
  padding-left: 20px;
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
