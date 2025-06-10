import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ChatbotController with ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  final GenerativeModel _model;

  ChatbotController(String apiKey)
      : _model = GenerativeModel(
        model: 'gemini-2.0-flash', 
        apiKey: apiKey,
      );

  List<Map<String, String>> get messages => _messages;

  Future<void> sendMessage(String userMessage) async {
    _messages.add({'role': 'user', 'text': userMessage});
    notifyListeners();

    final content = [Content.text(userMessage)];
    final response = await _model.generateContent(content);

    final botReply = response.text ?? 'No response';
    _messages.add({'role': 'bot', 'text': botReply});
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }

  Future<void> exportChatAsPdf() async {
    final doc = pw.Document();

    for (var msg in _messages) {
      final prefix = msg['role'] == 'user' ? '👤 You: ' : '🤖 Bot: ';
      doc.addPage(pw.Page(
        build: (context) => pw.Text(prefix + (msg['text'] ?? '')),
      ));
    }

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }
}