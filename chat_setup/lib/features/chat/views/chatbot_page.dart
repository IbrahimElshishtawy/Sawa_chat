import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chatbot_controller.dart';
import '../../../core/constants/app_colors.dart';

class ChatbotPage extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  final ChatbotController _controller = Get.put(ChatbotController());

  ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Sphere AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
            onPressed: () => _controller.clearChat(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: _controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = _controller.messages[index];
                  final isBot = msg['role'] == 'bot';
                  return _buildMessageBubble(msg['text'] ?? '', isBot, isDark);
                },
              ),
            ),
          ),
          Obx(() => _controller.isLoading.value
            ? const LinearProgressIndicator(minHeight: 2, backgroundColor: Colors.transparent)
            : const SizedBox(height: 2)),
          _buildInputBar(isDark),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isBot, bool isDark) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        decoration: BoxDecoration(
          color: isBot
            ? (isDark ? AppColors.darkCard : Colors.white)
            : AppColors.secondary,
          borderRadius: BorderRadius.circular(22).copyWith(
            bottomLeft: isBot ? const Radius.circular(4) : const Radius.circular(22),
            bottomRight: isBot ? const Radius.circular(22) : const Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isBot ? (isDark ? Colors.white : AppColors.lightText) : Colors.white,
            fontSize: 15,
            height: 1.4,
            fontWeight: isBot ? FontWeight.w400 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : Colors.white,
        border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _textController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'Message Sphere AI...',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (val) {
                  if (val.isNotEmpty) {
                    _controller.sendMessage(val);
                    _textController.clear();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              if (_textController.text.isNotEmpty) {
                _controller.sendMessage(_textController.text);
                _textController.clear();
              }
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
