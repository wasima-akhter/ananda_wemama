// class BaseResponse<T> {
//   final bool success;
//   final String? message;
//   final T? data;
//   final PaginationMeta? meta;
//   // add
//   final dynamic raw;

//   BaseResponse({
//     required this.success,
//     this.message,
//     this.data,
//     this.meta,
//     this.raw,
//   });

//   // Generic factory to parse JSON
//   factory BaseResponse.fromJson(
//     Map<String, dynamic> json,
//     T Function(dynamic)? fromJsonT,
//   ) {
//     T? parsedData;

//     if (json['data'] != null && fromJsonT != null) {
//       parsedData = fromJsonT(json['data']);
//     }

//     return BaseResponse<T>(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: parsedData,
//       meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
//       raw: json,
//     );
//   }
// }

// class PaginationMeta {
//   final int page;
//   final int limit;
//   final int total;
//   final int totalPage;
//   final bool hasNextPage;

//   PaginationMeta({
//     required this.page,
//     required this.limit,
//     required this.total,
//     required this.totalPage,
//     required this.hasNextPage,
//   });

//   factory PaginationMeta.fromJson(Map<String, dynamic> json) {
//     return PaginationMeta(
//       page: int.tryParse(json['page'].toString()) ?? 1,
//       limit: int.tryParse(json['limit'].toString()) ?? 10,
//       total: int.tryParse(json['total'].toString()) ?? 0,
//       totalPage: int.tryParse(json['totalPage'].toString()) ?? 1,
//       hasNextPage: json['hasNextPage'] ?? false,
//     );
//   }
// }
