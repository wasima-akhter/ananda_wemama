import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../config/app_info.dart';

class SimpleWebViewWidget extends StatefulWidget {
  final String htmlContent;
  final double? height;
  final double? fontSize;
  final Color backgroundColor;
  final Color? textColor;
  final EdgeInsets padding;
  final String? title;
  final String? headerHtml;

  const SimpleWebViewWidget({
    super.key,
    required this.htmlContent,
    this.height,
    this.fontSize,
    this.backgroundColor = Colors.transparent,
    this.textColor,
    this.padding = EdgeInsets.zero,
    this.title,
    this.headerHtml,
  });

  @override
  State<SimpleWebViewWidget> createState() => _SimpleWebViewWidgetState();
}

class _SimpleWebViewWidgetState extends State<SimpleWebViewWidget> {
  late final WebViewController _controller;

  bool _isLoading = true;

  // Toggled once after first paint to force the platform view to redo its
  // layout against the real, settled size. Without this, Android's hybrid
  // composition WebView can capture a stale/zero size at creation time and
  // never resync — which is also why it "fixes itself" on hot reload
  // (a hot reload just rebuilds everything from scratch).
  final bool _relaidOut = false;

  @override
  void initState() {
    super.initState();
    _controller = _buildController();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await Future.delayed(const Duration(milliseconds: 500));
    //   if (mounted) setState(() => _relaidOut = true);
    // });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) async {
    //     if (mounted) await _controller.reload();
    //   });
    // });
  }

  String _toCssColor(Color color) {
    if (color == Colors.transparent) return 'transparent';
    return 'rgba(${color.red},${color.green},${color.blue},${color.opacity})';
  }

  String get _paddingCss =>
      '${widget.padding.top}px ${widget.padding.right}px ${widget.padding.bottom}px ${widget.padding.left}px';

  String get _scrollbarColor =>
      '#${c.foregroundPrimary.withValues(alpha: 0.3).toARGB32().toRadixString(16).substring(2)}';

  //

  WebViewController _buildController() {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(widget.backgroundColor)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },

          onPageFinished: (_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },

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
      ..loadHtmlString(_buildHtml());
  }

  String _buildHtml() {
    return """
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
  font-size: ${(widget.fontSize ?? 14).sp}px;
  color: ${_toCssColor(widget.textColor ?? c.primary)};
  height: 100%;
  overflow: hidden;
}

#content {
  height: 100%;
  overflow-y: auto;
  padding-right: 0px;
}
#textcontent {
  margin: 10px 0 10px 0;

  padding: 18px 16px;

  background: ${_toCssColor(c.cardOngoing)};

  border-radius: 20px;

  display: block;
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

::-webkit-scrollbar {
  width: 0px;
}

::-webkit-scrollbar-track {
  background: rgba(0,0,0,0.08);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb {
  background: $_scrollbarColor;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #9B6DE3;
}

.title {
  font-family: 'Outfit', sans-serif;
  font-size: ${ScreenSizeX.isTablet ? 20.sp : 16.sp} ;
  font-weight: 600;
  margin: 0 0 16px 0;
  color: ${_toCssColor(widget.textColor ?? c.primary)};
}
</style>
</head>
<body>
  <div id="content">
   ${widget.headerHtml != null && widget.headerHtml!.isNotEmpty ? widget.headerHtml ?? '' : ''}

   <div id="textcontent">
    ${widget.title != null && widget.title!.isNotEmpty ? '<h2 class="title">${widget.title}</h2>' : ''}
    ${widget.htmlContent}
  </div>
  </div>
</body>
</html>
""";
  }

  @override
  Widget build(BuildContext context) {
    // Key changes once after first paint, forcing the platform view element
    // to be recreated against the now-settled constraints. Cheap: it's a
    // local HTML string reload, not a network round trip.
    final webView = WebViewWidget(
      key: ValueKey(_relaidOut),
      controller: _controller,
    );
    Widget buildWebView() {
      return Stack(
        children: [
          Positioned.fill(child: webView),

          if (_isLoading)
            Positioned.fill(
              child: ColoredBox(
                color: widget.backgroundColor,

                child: const Center(child: LoadingPrimary()),
              ),
            ),
        ],
      );
    }

    if (widget.height != null) {
      return SizedBox(
        height: widget.height,
        width: double.infinity,
        child: buildWebView(),
      );
    }

    return SizedBox.expand(child: buildWebView());
  }
}

String moodIllustrationHtml(String imageUrl) {
  final url = !kDebugMode
      ? "https://media.istockphoto.com/id/520700958/photo/beautiful-flowers-background.jpg?s=612x612&w=0&k=20&c=A7WF8MScj3YNBTA-qFQEKm-Xphzmi_mfaOqjq27--j4="
      : imageUrl.startsWith('http')
      ? imageUrl
      : '$baseUrl/$imageUrl';

  print('image url --> $url');

  return """
  <div id="mood-image-container"
    style="
      width:100%;
      height:150px;
      margin-bottom:16px;
      overflow:hidden;
      border-radius:20px;
      background:#F5F6FA;
      display:flex;
      align-items:center;
      justify-content:center;
      position:relative;
    "
  >
    <img
      src="$url"
      onerror="
        this.style.display='none';
        document.getElementById('mood-image-placeholder').style.display='flex';
      "
      style="
        width:100%;
        height:100%;
        object-fit:cover;
      "
    />

    <div
      id="mood-image-placeholder"
      style="
        display:none;
        width:100%;
        height:100%;
        align-items:center;
        justify-content:center;
        flex-direction:column;
        background:#F9EFE6;
        color:#A6827F;
        font-family:Arial,sans-serif;
      "
    >
      <div
        style="
          width:52px;
          height:52px;
          border-radius:16px;
          background:#F6E6DC;
          display:flex;
          align-items:center;
          justify-content:center;
        "
      >
        <span
          style="
            font-size:28px;
            color:#A6827F;
          "
        >
          🖼
        </span>
      </div>

      <div
        style="
          font-size:13px;
          font-weight:500;
          margin-top:10px;
          color:#A6827F;
        "
      >
        Image unavailable
      </div>
    </div>
  </div>
  """;
}
