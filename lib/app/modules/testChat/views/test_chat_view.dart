import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/test_chat_controller.dart';

class TestChatView extends GetView<TestChatController> {

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  TestChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: 10,//chatController.messages.length,
              itemBuilder: (context, index) {
                var message = "Message$index";//chatController.messages[index];
                return ListTile(
                  title: Text(message),
                  subtitle: Text(message),
                );
              },
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                   /* chatController.sendMessage(
                      chatId,
                      _messageController.text,
                      'rider', // Replace with actual sender's ID
                      'customer', // Replace with actual receiver's ID
                    );*/
                    _messageController.clear();
                    _scrollController.animateTo(
                      _scrollController.position.minScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}








/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/chat_controller.dart';

class TestChat extends StatelessWidget {
  final String chatId;
  final ChatController chatController = Get.put(ChatController());

  TestChat({required this.chatId});

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    chatController.fetchMessages(chatId);


  }
}*/
