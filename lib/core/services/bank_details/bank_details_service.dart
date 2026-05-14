import '../../../../app/service_export.dart';

class BankDetailsService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  // Future<BankDetailsDataModel?> addBankDetails({
  //   required String bankName,
  //   required String accountName,
  //   required String accountNumber,
  //   required String bankCode,
  // }) async {
  //   apiCall() {
  //     return ApiClient().post(
  //       Endpoints.addBankDetails.getUrl,
  //       headers: HeaderHelpers.getAuthHeader(),
  //       data: {
  //         "bankName": bankName,
  //         "accountName": accountName,
  //         "accountNumber": accountNumber,
  //         "bankCode": bankCode,
  //       },
  //     );
  //   }

  //   final response = await _apiHelper.request(
  //     apiCall: apiCall,
  //     parser: (data) => BankDetailsDataModel.fromJson(data),
  //   );
  //   if (response == null || !response.success) return null;
  //   return response.data;
  // }

  // Future<List<BankCodeDataModel>> fetchBankCodes() async {
  //   apiCall() {
  //     return ApiClient().get(Endpoints.getBankCodes.getUrl, headers: HeaderHelpers.jsonHeader());
  //   }

  //   final response = await _apiHelper.request<List<BankCodeDataModel>>(
  //     apiCall: apiCall,
  //     parser: (data) {
  //       return (data as List).map((e) => BankCodeDataModel.fromJson(e)).toList();
  //     },
  //   );

  //   return response?.data ?? [];
  // }
}
