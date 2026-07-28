import '../../../../app/service_export.dart';
import '../model/community_spotlight_model.dart';

class HomeService extends GetxService {
  /// Fetch inventory details from API

  Future<CommunitySpotlightModel?> fetchCommunitySpotLight() async {
    apiCall() {
      return ApiClient().get(
        Endpoints.communitySpotlight.getUrl,
        // reqName: Strings.communitySpotlight,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute<CommunitySpotlightModel?>(
      apiCall: apiCall,
      parser: (data) {
        log("parserdata: $data");

        log(
          ' CommunitySpotlightData.fromJson(data) : ${CommunitySpotlightModel.fromJson(data).communitySpotlight?.createdAt}',
        );

        return CommunitySpotlightModel.fromJson(data); // ✅
      },
    );

    log("response data: ${response.data}");
    return response.data;
  }

  //
  Future<GentleRemindData?> fetchGentleRemindData() async {
    apiCall() {
      return ApiClient().get(
        Endpoints.gentleReminder.getUrl,
        // reqName: Strings.gentleReminder.capEachWord(),
        // headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute<GentleRemindData?>(
      apiCall: apiCall,
      parser: (data) {
        log("parserdata: $data");

        log(
          ' CommunitySpotlightData.fromJson(data) : ${GentleRemindData.fromJson(data).message}',
        );

        return GentleRemindData.fromJson(data); // ✅
      },
    );

    log("response data: ${response.data}");
    return response.data;
  }

  Future<CheckInResponse?> postTheCheckTrigger() async {
    apiCall() {
      return ApiClient().post(
        Endpoints.addTodayMood.getUrl,
        // reqName: "add mood today".capEachWord(),
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute<CheckInResponse?>(
      apiCall: apiCall,
      showSuccessMessage: true,
      parser: (data) {
        log("parserdata: $data");

        log(
          ' CheckInResponse.fromJson(data) : ${CheckInResponse.fromJson(data).message}',
        );

        return CheckInResponse.fromJson(data); // ✅
      },
    );

    log("response toString: ${response.toString()}");

    log("response data: ${response.data}");
    return response.data;
  }
}

class CheckInResponse {
  CheckInResponse({this.streak, this.milestoneReached, this.message});

  final int? streak;
  final dynamic milestoneReached; // 👈 FIXED
  final String? message;

  factory CheckInResponse.fromJson(Map<String, dynamic> json) {
    return CheckInResponse(
      streak: _toInt(json["streak"]),
      milestoneReached: json["milestoneReached"], // keep flexible
      message: json["message"]?.toString(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class GentleRemindData {
  GentleRemindData({this.message});

  final String? message;

  factory GentleRemindData.fromJson(Map<String, dynamic> json) {
    return GentleRemindData(message: json["message"]);
  }
}
