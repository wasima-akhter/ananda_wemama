import 'package:image_picker/image_picker.dart';
import 'package:we_mama/app/helper_widgets_export.dart';

import '../../../../app/service_export.dart';

class ReportService extends GetxService {
  Future<ReportInfoModel?> reportUserOrContent({
    XFile? reportImage,
    required String id_,
    required String name,
    required bool isUserReport,
    required String note,
  }) async {
    final response = await ApiExecutor().execute<ReportInfoModel>(
      apiCall: () => ApiClient().postWithFile(
        Endpoints.reportUser.getUrl,
        // reqName: Strings.reportUser,
        file: reportImage != null
            ? MapEntry('report-image', reportImage)
            : null,
        fields: {
          'type': isUserReport ? "User".cap : "Content".cap,
          'note': note,
          'report': id_,
          'name': name,
        },
      ),
      parser: (data) => ReportInfoModel.fromJson(data),
    );

    return (!response.isSuccess) ? null : response.data;
  }

  //
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
