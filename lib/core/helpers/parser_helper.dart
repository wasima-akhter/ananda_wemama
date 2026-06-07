class JsonParser {
  static String string(dynamic value) => value?.toString() ?? '';

  static bool boolValue(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value == 1;

    return value.toString().toLowerCase() == 'true';
  }

  static double doubleValue(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static DateTime? date(dynamic value) =>
      DateTime.tryParse(value?.toString() ?? '');
}

class SafeParser {
  const SafeParser._();

  static String str(dynamic v, [String fallback = '']) {
    return v is String ? v : v?.toString() ?? fallback;
  }

  static double dbl(dynamic v, [double fallback = 0.0]) {
    if (v is num) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? fallback;
  }

  static int intVal(dynamic v, [int fallback = 0]) {
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? fallback;
  }

  static bool boolVal(dynamic v, [bool fallback = false]) {
    if (v is bool) return v;

    if (v is num) {
      return v == 1;
    }

    final value = v?.toString().toLowerCase().trim();

    switch (value) {
      case 'true':
      case '1':
      case 'yes':
      case 'y':
        return true;

      case 'false':
      case '0':
      case 'no':
      case 'n':
        return false;

      default:
        return fallback;
    }
  }

  static DateTime? date(dynamic value) {
    if (value == null) return null;

    final str = value.toString().trim();

    if (str.isEmpty || str.toLowerCase() == 'null') {
      return null;
    }

    return DateTime.tryParse(str);
  }

  static DateTime? nullableDate(dynamic value) {
    if (value == null) return null;

    final stringValue = value.toString().trim();

    if (stringValue.isEmpty) return null;

    return DateTime.tryParse(stringValue);
  }

  static Map<String, dynamic>? map(dynamic v) {
    if (v is Map<String, dynamic>) return v;

    if (v is Map) {
      try {
        return Map<String, dynamic>.from(v);
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  static List<T> list<T>(dynamic v, T Function(Map<String, dynamic>) fromJson) {
    if (v is! List) return const [];

    return v
        .whereType<Map>()
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static List<String> stringList(dynamic v) {
    if (v is! List) return const [];

    return v.where((e) => e != null).map((e) => e.toString()).toList();
  }

  /// Useful for ids returned as int/string/ObjectId/etc.
  static String id(dynamic v) {
    return str(v);
  }

  /// For APIs returning empty string instead of null.
  static String? nullableString(dynamic v) {
    final value = str(v);
    return value.isEmpty ? null : value;
  }

  /// Safe enum parsing.
  static T enumValue<T>(dynamic value, List<T> values, {required T fallback}) {
    final strValue = value?.toString().toLowerCase();

    for (final item in values) {
      if (item.toString().split('.').last.toLowerCase() == strValue) {
        return item;
      }
    }

    return fallback;
  }

  /// Generic object parser.
  static T? object<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final mapValue = map(value);

    if (mapValue == null) {
      return null;
    }

    return fromJson(mapValue);
  }

  static List<Map<String, dynamic>> mapList(dynamic v) {
    if (v is! List) return const [];

    return v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
