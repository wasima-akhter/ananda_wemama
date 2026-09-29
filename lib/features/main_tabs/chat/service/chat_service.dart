import '../../../../app/service_export.dart';
import '../model/chat_list_item_model.dart';

class ChatService extends GetxService {
  Future<List<ChatListItemModel>> fetchSearchedChatList({
    required String searchTxt,
  }) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getSearchedChatList(searchTxt: searchTxt).getUrl,
        // reqName: Strings.search,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute<List<ChatListItemModel>>(
      apiCall: apiCall,
      parser: (data) {
        print("parserdata: $data");
        if (data is List) {
          return data.map((e) => ChatListItemModel.fromJson(e)).toList();
        }

        return [];
      },
    );

    print("response data: ${response?.data}");
    return response?.data ?? [];
  }
}
