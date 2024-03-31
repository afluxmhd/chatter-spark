import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api/api_client.dart';
import '../services/api/api_routes.dart';
import '../services/text_correction/text_correction_service.dart';
import '../utils/utils.dart';

final chatControllerProvider = StateNotifierProvider<ChatController, bool>((ref) => ChatController(ref: ref));

class ChatController extends StateNotifier<bool> {
  ChatController({required this.ref}) : super(false);

  final Ref ref;

  Future<void> configureAPIKey(BuildContext context, String key) async {
    if (key.isEmpty) {
      Navigator.pop(context);
      return;
    }
    final pref = await SharedPreferences.getInstance();
    await pref.setString('api-key', key).then((value) {
      Navigator.pop(context);
      showSnackBar(context, 'API Key Configuration Complete');
    });
  }

  Future<bool> removeAPIKeyConfiguration() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.remove('api-key');
  }

  Future<String> analyzeAndFixSentence({required BuildContext context, required String text}) async {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text before analyzing.');
      return '';
    }
    state = true;
    var correctText = '';

    final pref = await SharedPreferences.getInstance();
    final apiKey = pref.getString('api-key');

    if (apiKey != null) {
      final textCorrectionServices = TextCorrectionServices(apiClient: APIClient(apiKey: apiKey), apiRoutes: APIRoutes());
      await textCorrectionServices.getCorrectSentence(text).then((value) {
        if (!value.isError) {
          correctText = value.body;
        } else {
          showSnackBar(context, value.errorMessage);
        }
      });
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'API Key is not configured. \nPlease configure it from the settings');
    }

    state = false;
    return correctText;
  }
}
