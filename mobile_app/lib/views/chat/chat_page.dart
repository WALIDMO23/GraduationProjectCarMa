import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:graduation_project/core/theme/app_theme.dart';
import 'package:graduation_project/logic/providers/auth_provider.dart';
import 'package:graduation_project/logic/providers/chat_provider.dart';
import 'package:graduation_project/logic/providers/locale_provider.dart';
import 'package:graduation_project/core/comeponents/app_background.dart';

class ChatPage extends StatefulWidget {
  final int serviceRequestId;
  final String technicianName;

  const ChatPage({
    super.key,
    required this.serviceRequestId,
    required this.technicianName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = context.read<ChatProvider>();
      chatProvider.loadMessages(widget.serviceRequestId);
      chatProvider.connectToChat(widget.serviceRequestId);
    });
  }

  @override
  void dispose() {
    final chatProvider = context.read<ChatProvider>();
    chatProvider.disconnectFromChat(widget.serviceRequestId);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSend() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final auth = context.read<AuthProvider>();
    final chatProvider = context.read<ChatProvider>();

    final senderId = auth.currentUser?.id ?? 0;
    final senderName = auth.currentUser?.name ?? 'عميل';

    _messageController.clear();

    final success = await chatProvider.sendMessage(
      widget.serviceRequestId,
      senderId,
      senderName,
      text,
    );

    if (success) {
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  String _formatTime(String? timestampStr) {
    if (timestampStr == null) return '';
    try {
      final dateTime = DateTime.parse(timestampStr).toLocal();
      return DateFormat('hh:mm a', 'en').format(dateTime);
    } catch (_) {
      return '';
    }
  }

  String _formatDateSeparator(String? timestampStr) {
    if (timestampStr == null) return '';
    try {
      final dateTime = DateTime.parse(timestampStr).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dateTime).inDays;

      if (diff == 0 && now.day == dateTime.day) {
        return 'Today';
      } else if (diff == 1 || (diff == 0 && now.day != dateTime.day)) {
        return 'Yesterday';
      } else {
        return DateFormat('MMMM dd, yyyy').format(dateTime);
      }
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleProvider>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();
    final currentUserId = auth.currentUser?.id ?? 0;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: isDark ? AppTheme.carmaDeepDark : AppTheme.primaryColor,
          foregroundColor: Colors.white,
          leadingWidth: 70,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                const SizedBox(width: 8),
                const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                const SizedBox(width: 4),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.technicianName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isArabic ? 'متصل' : 'Online',
                style: TextStyle(
                  color: AppTheme.successColor.withValues(alpha: 0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.white),
              onPressed: () {}, // Handled on Details page, keep placeholder for visual hierarchy
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            // Message Area
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chat, _) {
                  if (chat.isLoading && chat.messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator(color: AppTheme.carmaGold));
                  }

                  // Auto-scroll on new message
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                  if (chat.messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: isDark ? Colors.white30 : Colors.black26,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isArabic ? 'ابدأ المحادثة مع الفني الآن' : 'Start chatting with the technician',
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: chat.messages.length,
                    itemBuilder: (context, index) {
                      final msg = chat.messages[index];
                      final isMe = msg['senderId'] == currentUserId;

                      // Date separator check
                      bool showDateSeparator = false;
                      if (index == 0) {
                        showDateSeparator = true;
                      } else {
                        final prevMsg = chat.messages[index - 1];
                        final currentDateStr = _formatDateSeparator(msg['timestamp']);
                        final prevDateStr = _formatDateSeparator(prevMsg['timestamp']);
                        if (currentDateStr != prevDateStr) {
                          showDateSeparator = true;
                        }
                      }

                      return Column(
                        children: [
                          if (showDateSeparator)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.black45 : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _formatDateSeparator(msg['timestamp']),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? (isDark ? AppTheme.carmaGold : AppTheme.primaryColor)
                                    : (isDark ? const Color(0xFF2A2A2A) : Colors.white),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                                  bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    msg['messageText'] ?? '',
                                    style: TextStyle(
                                      color: isMe
                                          ? Colors.black
                                          : (isDark ? Colors.white : Colors.black87),
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _formatTime(msg['timestamp']),
                                        style: TextStyle(
                                          color: isMe ? Colors.black54 : Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                      if (isMe) ...[
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.done_all,
                                          size: 14,
                                          color: isDark ? Colors.black54 : Colors.blue.shade900,
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.carmaDeepDark : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    offset: const Offset(0, -2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                                decoration: InputDecoration(
                                  hintText: isArabic ? 'اكتب رسالة...' : 'Type a message...',
                                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.attach_file, color: Colors.grey),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _handleSend,
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: AppTheme.carmaGold,
                        child: const Icon(Icons.send, color: Colors.black, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
