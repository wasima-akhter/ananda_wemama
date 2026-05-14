import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:mama_app/app/helper_widgets_export.dart';

import '../../../../app/service_export.dart';

class ReportService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<ReportInfoModel?> reportUserOrContent({
    XFile? reportImage,
    required String id_,
    required String name,
    required bool isUserReport,
    required String note,
  }) async {
    final data = dio.FormData();

    // ───────────────── IMAGE (COMPRESS) ─────────────────

    if (reportImage != null) {
      final compressed = await MultipartHelper.compressedImage(
        File(reportImage.path),
      );

      if (compressed == null) {
        "Image compression failed".showToast();
        return null;
      }

      data.files.add(MapEntry('report-image', compressed));
    }

    // ───────────────── TEXT FIELDS ─────────────────

    final type = isUserReport ? "User".cap : "Content".cap;

    data.fields
      ..add(MapEntry('type', type))
      ..add(MapEntry('note', note))
      ..add(MapEntry('report', id_))
      ..add(MapEntry('name', name));

    // ───────────────── DEBUG ─────────────────

    log('fields: ${data.fields}');
    log('files count: ${data.files.length}');
    log('file keys: ${data.files.map((e) => e.key).toList()}');

    for (final f in data.fields) {
      log('${f.key}: ${f.value}');
    }

    for (final f in data.files) {
      log('${f.key}: ${f.value.filename}');
    }

    log("Token: ${storage.getAccessToken}");

    // ───────────────── API CALL ─────────────────

    final response = await _apiHelper.request<ReportInfoModel>(
      apiCall: () => ApiClient().postWithFile(
        Endpoints.reportUser.getUrl,
        reqName: Strings.reportUser,
        data: data,
      ),
      parser: (data) => ReportInfoModel.fromJson(data),
    );

    if (response == null || !response.success) return null;

    return response.data;
  }
}

class ReportInfoModel {
  ReportInfoModel({
    this.user,
    this.report,
    this.refModel,
    this.reportImage,
    this.note,
    this.name,
    this.type,
    this.status,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? user;
  final String? report;
  final String? refModel;
  final String? reportImage;
  final String? note;
  final String? name;
  final String? type;
  final String? status;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory ReportInfoModel.fromJson(Map<String, dynamic> json) {
    return ReportInfoModel(
      user: json["user"],
      report: json["report"],
      refModel: json["refModel"],
      reportImage: json["reportImage"],
      note: json["note"],
      name: json["name"],
      type: json["type"],
      status: json["status"],
      id: json["_id"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }
}
