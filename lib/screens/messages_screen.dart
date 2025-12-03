import 'dart:math';

import 'package:flutter/material.dart';
import 'package:support_messaging_app/models/message.dart';
import 'package:support_messaging_app/services/message_storage.dart';
import 'package:support_messaging_app/widgets/chat_bubble.dart';

class MessagesScreen extends StatefulWidget {
  final VoidCallback? onIncomingMessage;
  final VoidCallback? onMessagesViewed;

  const MessagesScreen({
    super.key,
    this.onIncomingMessage,
    this.onMessagesViewed,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final MessageStorage _storage = MessageStorage();
  bool _isSending = false;

  final List<String> _autoReplies = const [
    'Thanks for reaching out! How can I help you today?',
    'Got it, I\'m checking that for you now.',
    'Can you please share more details?',
    'This looks resolved on my side now. 👍',
    'No problem, I\'m happy to assist!',
  ];

  @override
  void initState() {
    super.initState();
    _loadMessagesAndSeed();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onMessagesViewed?.call();
    });
  }

  void _loadMessagesAndSeed() async {
    final loaded = await _storage.loadMessages();
    setState(() {
      _messages.addAll(loaded);
      if (_messages.isEmpty) {
        _messages.add(
          Message(
            id: 'welcome',
            text: 'Hi! This is Support. How can we help you today?',
            isFromUser: false,
            timestamp: DateTime.now(),
          ),
        );
      }
    });
    _scrollToBottom();
  }



  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final rawText = _textController.text.trim();
    if (rawText.isEmpty || _isSending) return;

    final now = DateTime.now();
    final userMessage = Message(
      id: now.millisecondsSinceEpoch.toString(),
      text: rawText,
      isFromUser: true,
      timestamp: now,
    );

    setState(() {
      _messages.add(userMessage);
      _isSending = true;
    });

    _textController.clear();
    _scrollToBottom();
    _storage.saveMessages(_messages);

    _scheduleAutoReply();
  }

  void _scheduleAutoReply() {
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;

      final now = DateTime.now();
      final random = Random();
      final replyText = _autoReplies[random.nextInt(_autoReplies.length)];

      final reply = Message(
        id: 'reply_${now.millisecondsSinceEpoch}',
        text: replyText,
        isFromUser: false,
        timestamp: now,
      );

      setState(() {
        _messages.add(reply);
        _isSending = false;
      });

      _scrollToBottom();
      _storage.saveMessages(_messages);
      widget.onIncomingMessage?.call();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Chat'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: const Color(0xFFF3F4F6),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return ChatBubble(message: msg);
                  },
                ),
              ),
            ),
            const Divider(height: 1),
            _buildInputBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // reserved for emoji picker or attachments later
            },
            icon: const Icon(Icons.emoji_emotions_outlined),
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
