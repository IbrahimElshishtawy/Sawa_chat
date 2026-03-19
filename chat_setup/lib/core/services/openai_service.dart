import 'ai_base_service.dart';

class OpenAiService implements AIService {
  final String? apiKey;

  OpenAiService({this.apiKey});

  @override
  Future<String> getResponse(String prompt) async {
    // Mocking OpenAI response for now
    await Future.delayed(const Duration(seconds: 1));
    return "This is a response from the Sphere AI (OpenAI Mock) for: $prompt";
  }
}
