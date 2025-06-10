import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text("AI Assistant"),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: chatController.exportChatAsPdf,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: chatController.clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatController.messages.length,
              itemBuilder: (context, index) {
                final msg = chatController.messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(chatController),
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(chatController),
                ),
              ],
            ),
          ),
        ],
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
