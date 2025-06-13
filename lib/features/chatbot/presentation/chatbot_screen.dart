import 'package:flutter/material.dart';
import 'package:hey_champ_app/common/widgets/my_textfield.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
import 'package:hey_champ_app/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:hey_champ_app/features/chatbot/application/chatbot_controller.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatbotController>(context);
    final double h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryText,
            ),
            onPressed: () => router.pop(),
          ),
          title: Text(
            "AI Buddy 🤖",
            style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.picture_as_pdf, color: AppColors.primaryText),
              onPressed: chatController.exportChatAsPdf,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: AppColors.primaryText),
              onPressed: chatController.clearChat,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    final msg = chatController.messages[index];
                    final isUser = msg['role'] == 'user';
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width *
                              0.75, // Limit to 75% of screen
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser
                                ? AppColors.secondaryText
                                : AppColors.buttonText,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg['text'] ?? '',
                            style: const TextStyle(
                              color: AppColors.background,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(height: 20),
              Text(
                "Note: Chats are not saved permanently. "
                "Export to PDF to save your conversations.",
                style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        hintText: "Ask me anything...",
                        controller: _controller,
                        onSubmitted: (text) => _sendMessage(chatController),
                        height: h * 0.06,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: AppColors.buttonText),
                      onPressed: () => _sendMessage(chatController),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage(ChatbotController controller) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      controller.sendMessage(text);
      _controller.clear();
    }
  }
}
