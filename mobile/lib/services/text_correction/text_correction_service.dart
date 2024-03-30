import '../../models/response_model.dart';
import '../api/api_client.dart';
import '../api/api_routes.dart';

class TextCorrectionServices {
  TextCorrectionServices({required this.apiClient, required this.apiRoutes});

  final APIClient apiClient;
  final APIRoutes apiRoutes;

  Future<ResponseModel> getCorrectSentence(String text) async {
    try {
      final response =
          await apiClient.post(APIRoutes.baseUrl + APIRoutes.textCorrectionPath, {'fix': text}) as Map<String, dynamic>;
      final responseModel = ResponseModel(body: response.entries.first.value, isError: false);
      return responseModel;
    } catch (e) {
      return ResponseModel(body: '', isError: true, errorMessage: e.toString());
    }
  }
}
