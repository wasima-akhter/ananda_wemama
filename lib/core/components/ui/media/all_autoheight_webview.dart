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
  });

  final ValueNotifier<double> _webViewHeight = ValueNotifier(1);

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
          style: TextStyle(fontSize: fontSize ?? 14, height: 1.6, color: c.secondary),
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
            if (request.url == 'about:blank') return NavigationDecision.navigate;
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
    font-size: ${fontSize ?? 14}px !important;
    color: ${_toCssColor(textColor ?? c.primary)} !important;
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

// import 'package:mama_app/app/helper_widgets_export.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class AllAutoheightWebview extends StatefulWidget {
//   final String htmlContent;
//   final double? fontSize;
//   final Color backgroundColor;
//   final EdgeInsets padding;
//   final bool previewOnly;
//   final int previewMaxLines;
//   final Color textColor;

//   const AllAutoheightWebview({
//     super.key,
//     required this.htmlContent,
//     this.fontSize,
//     this.backgroundColor = Colors.transparent,
//     this.padding = EdgeInsets.zero,
//     this.previewOnly = false,
//     this.previewMaxLines = 3,
//     this.textColor = const Color(0xFF333333),
//   });

//   @override
//   State<AllAutoheightWebview> createState() => _AllAutoheightWebviewState();
// }

// class _AllAutoheightWebviewState extends State<AllAutoheightWebview> {
//   WebViewController? _controller;
//   late String _channelName;
//   double _height = 0;
//   bool _isReady = false;

//   // ── Helpers ───────────────────────────────────────────────────────────────

//   String get _plainText => widget.htmlContent
//       .replaceAll(RegExp(r'<[^>]*>'), ' ')
//       .replaceAll(RegExp(r'&nbsp;'), ' ')
//       .replaceAll(RegExp(r'&amp;'), '&')
//       .replaceAll(RegExp(r'&lt;'), '<')
//       .replaceAll(RegExp(r'&gt;'), '>')
//       .replaceAll(RegExp(r'\s+'), ' ')
//       .trim();

//   String _toCssColor(Color color) {
//     if (color == Colors.transparent) return 'transparent';
//     return 'rgba(${color.red},${color.green},${color.blue},${color.opacity})';
//   }

//   String get _paddingCss {
//     final p = widget.padding;
//     return '${p.top}px ${p.right}px ${p.bottom}px ${p.left}px';
//   }

//   // ── Lifecycle ─────────────────────────────────────────────────────────────

//   @override
//   void initState() {
//     super.initState();
//     if (!widget.previewOnly) {
//       _channelName = 'HC${hashCode.abs()}';
//       _initController();
//     }
//   }

//   @override
//   void didUpdateWidget(AllAutoheightWebview old) {
//     super.didUpdateWidget(old);
//     if (widget.previewOnly) return;

//     if (old.htmlContent != widget.htmlContent) {
//       setState(() {
//         _height = 0;
//         _isReady = false;
//       });
//       _controller?.loadHtmlString(_html);
//     }
//   }

//   @override
//   void dispose() {
//     _controller = null;
//     super.dispose();
//   }

//   // ── Controller ────────────────────────────────────────────────────────────

//   void _initController() {
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(widget.backgroundColor)
//       ..enableZoom(false)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onNavigationRequest: (req) async {
//             if (req.url == 'about:blank') return NavigationDecision.navigate;
//             final uri = Uri.tryParse(req.url);
//             if (uri != null) {
//               try {
//                 await launchUrl(uri, mode: LaunchMode.externalApplication);
//               } catch (e) {
//                 log('launch error: $e');
//               }
//             }
//             return NavigationDecision.prevent;
//           },
//         ),
//       )
//       ..addJavaScriptChannel(
//         _channelName,
//         onMessageReceived: (msg) {
//           final h = double.tryParse(msg.message) ?? 0;
//           if (h > 0 && mounted) {
//             setState(() {
//               _height = h;
//               _isReady = true;
//             });
//           }
//         },
//       )
//       ..loadHtmlString(_html);
//   }

//   // ── HTML ──────────────────────────────────────────────────────────────────

//   String get _html =>
//       '''
// <!DOCTYPE html>
// <html>
// <head>
// <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
// <style>
//   html, body {
//     margin: 0 !important;
//     padding: $_paddingCss !important;
//     background: ${_toCssColor(widget.backgroundColor)} !important;
//     font-family: sans-serif !important;
//     font-size: ${widget.fontSize ?? 14}px !important;
//     color: ${_toCssColor(widget.textColor)} !important;
//     word-wrap: break-word;
//     overflow-x: hidden;
//   }
//   * {
//     background-color: transparent !important;
//     background-image: none !important;
//     max-width: 100% !important;
//     box-sizing: border-box !important;
//     font-family: sans-serif !important;
//   }
//   /* preserve bold/italic but strip color overrides */
//   span, p, li, td, div {
//     color: inherit !important;
//     line-height: 1.6 !important;
//   }
//   img, video, iframe, table {
//     max-width: 100% !important;
//     height: auto !important;
//     display: block;
//   }
//   a { color: #2196F3 !important; text-decoration: underline; word-break: break-word; }
//   p:empty, li:empty, br + br { display: none; }
// </style>
// </head>
// <body>
// ${widget.htmlContent}
// <script>
//   var _sent = false;
//   function sendHeight() {
//     var h = Math.max(
//       document.body.scrollHeight,
//       document.documentElement.scrollHeight,
//       document.body.offsetHeight,
//       document.documentElement.offsetHeight
//     );
//     if (h > 0) {
//       $_channelName.postMessage(String(h));
//     }
//   }
//   // staggered — catches fonts, images, deferred rendering
//   function scheduleAll() {
//     sendHeight();
//     [50, 200, 500, 1000, 2000].forEach(function(ms) {
//       setTimeout(sendHeight, ms);
//     });
//   }
//   if (document.readyState === 'loading') {
//     document.addEventListener('DOMContentLoaded', scheduleAll);
//   } else {
//     scheduleAll();
//   }
//   // images
//   document.querySelectorAll('img').forEach(function(img) {
//     if (!img.complete) {
//       img.addEventListener('load', sendHeight);
//       img.addEventListener('error', sendHeight);
//     }
//   });
//   // resize (orientation change)
//   window.addEventListener('resize', sendHeight);
// </script>
// </body>
// </html>
// ''';

//   // ── Build ─────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     // Preview mode — no WebView at all
//     if (widget.previewOnly) {
//       return Padding(
//         padding: widget.padding,
//         child: Text(
//           _plainText,
//           maxLines: widget.previewMaxLines,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(fontSize: widget.fontSize ?? 14, height: 1.6, color: widget.textColor),
//         ),
//       );
//     }

//     return AnimatedCrossFade(
//       duration: const Duration(milliseconds: 350),
//       crossFadeState: _isReady ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//       firstChild: const SizedBox(height: 100, child: Center(child: LoadingPrimary())),
//       secondChild: SizedBox(
//         width: double.infinity,
//         height: _height,
//         child: _controller != null
//             ? WebViewWidget(controller: _controller!)
//             : const SizedBox.shrink(),
//       ),
//     );
//   }
// }
