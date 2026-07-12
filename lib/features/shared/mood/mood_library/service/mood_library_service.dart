import '../../../../../app/service_export.dart';
import '../model/get_all_mood_model.dart';

class MoodLibraryService extends GetxService {
  Future<List<GetAllMoodItemModel>> fetchMoodImageData() async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getAllMood.getUrl, // reqName: Strings.getAllMood
      );
    }

    final response = await ApiExecutor().execute<List<GetAllMoodItemModel>>(
      apiCall: apiCall,
      parser: (data) =>
          (data as List).map((e) => GetAllMoodItemModel.fromJson(e)).toList(),
    );

    if (!response.isSuccess) return [];

    return response.data ?? []; // 👈 return actual data
  }

  Future<List<GetAllMoodItemModel>> fetchAllMoodContents({
    required String moodId,
  }) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getAllMoodContents(moodId: moodId).getUrl,
        // reqName: Strings.getAllMoodContents,
      );
    }

    final response = await ApiExecutor().execute<List<GetAllMoodItemModel>>(
      apiCall: apiCall,
      parser: (data) =>
          (data as List).map((e) => GetAllMoodItemModel.fromJson(e)).toList(),
    );

    if (!response.isSuccess) return [];

    return response.data ?? []; // 👈 return actual data
  }
}
