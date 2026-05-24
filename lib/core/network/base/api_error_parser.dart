class ApiErrorParser {
  static String extractMessage(dynamic data) {
    if (data is Map) {
      if (data["message"] != null) {
        return data["message"].toString();
      }

      final errorDetails = data["errorDetails"];
      if (errorDetails is Map && errorDetails["issues"] is List) {
        final issues = errorDetails["issues"];
        if (issues.isNotEmpty && issues.first["message"] != null) {
          return issues.first["message"].toString();
        }
      }
    }
    return "Something went wrong";
  }

  static String? extractStack(dynamic data) {
    if (data is Map && data["stack"] != null) {
      return data["stack"].toString();
    }
    return null;
  }
}
