class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final PaginationMeta? meta; // ✅ added

  BaseResponse({
    required this.success,
    required this.message,
    this.data,
    this.meta,
  });

  // Generic factory to parse JSON
  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    T? parsedData;

    try {
      if (json['data'] != null && fromJsonT != null) {
        final rawData = json['data'];
        parsedData = fromJsonT(rawData);
      }
    } catch (e, st) {
      parsedData = null;
    }

    return BaseResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: parsedData,
      meta: json['meta'] != null
          ? PaginationMeta.fromJson(
              json['meta'] as Map<String, dynamic>,
            ) // ✅ added
          : null,
    );
  }
}

class PaginationMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;
  final bool hasNextPage;

  PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
    required this.hasNextPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}
