import '../../../app/service_export.dart';
import '../model/verification_model.dart';

class VerificationService {
  Future<Result<VerificationSession>> createSession() {
    return ApiExecutor().execute<VerificationSession>(
      apiCall: () => ApiClient().post(Endpoints.verificationSession.getUrl),
      parser: (data) => VerificationSession.fromJson(data),
      showErrorMessage: false, // controller maps 409 / 429 / 502 itself
    );
  }

  Future<Result<VerificationStatusData>> getStatus() {
    return ApiExecutor().execute<VerificationStatusData>(
      apiCall: () => ApiClient().get(Endpoints.verificationStatus.getUrl),
      parser: (data) => VerificationStatusData.fromJson(data),
      showErrorMessage: false, // polling shouldn't spam snackbars
    );
  }
}
