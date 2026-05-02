import 'package:get/get.dart';
import '../../../core/services/ai_base_service.dart';

class ChatbotController extends GetxController {
  final AIService _aiService = Get.find<AIService>();

  final messages = <Map<String, String>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Add initial greeting with Sphere branding
    messages.add({
      'role': 'bot',
      'text': 'Welcome to Sphere AI. I am your premium assistant, ready to help you navigate your social world. How can I assist you today?'
    });
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messages.add({'role': 'user', 'text': text});
    isLoading.value = true;

    try {
      final response = await _aiService.getResponse(text);
      messages.add({'role': 'bot', 'text': response});
    } catch (e) {
      messages.add({'role': 'bot', 'text': 'I apologize, but I encountered a technical issue. Please try again later.'});
    } finally {
      isLoading.value = false;
    }
  }

  void clearChat() {
    messages.clear();
    messages.add({
      'role': 'bot',
      'text': 'History cleared. How can Sphere AI help you now?'
    });
  }
}
