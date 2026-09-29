import 'dart:convert';

class ApiLogger {
  ApiLogger._();

  static void response({
    required String url,
    required String method,
    required int statusCode,
    dynamic body,
  }) {
    print("""
━━━━━━━━━━━━ API RESPONSE ━━━━━━━━━━━━

METHOD:
$method

URL:
$url

STATUS CODE:
$statusCode

BODY:
${_pretty(body)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
""");
  }

  static void request({
    required String url,
    required String method,
    dynamic body,
    dynamic headers,
  }) {
    print("""
━━━━━━━━━━━━ API REQUEST ━━━━━━━━━━━━

METHOD:
$method

URL:
$url

HEADERS:
${_pretty(headers)}

BODY:
${_pretty(body)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
""");
  }

  static String _pretty(dynamic data) {
    if (data == null) return "null";

    try {
      const encoder = JsonEncoder.withIndent("  ");

      if (data is String) {
        return encoder.convert(jsonDecode(data));
      }

      return encoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
