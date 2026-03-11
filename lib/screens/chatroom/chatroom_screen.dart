import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/sidebar.dart';
import '../../providers/app_provider.dart';

class ChatroomScreen extends StatefulWidget {
  const ChatroomScreen({super.key});

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'type': 'system',
      'text': "User [Ahmad's Node] joined the local network",
      'time': '14:22',
    },
    {
      'type': 'received',
      'user': 'Ahmad',
      'text': 'Hey everyone, my node is running at full speed today! 🚀',
      'time': '14:23',
    },
    {
      'type': 'sent',
      'user': 'You',
      'text': 'Great! Connection feels much faster now.',
      'time': '14:24',
    },
    {
      'type': 'received',
      'user': 'Sara',
      'text': 'Is anyone else experiencing latency issues? Mine seems fine.',
      'time': '14:25',
    },
    {
      'type': 'system',
      'text': 'User [Campus Node 3] joined the local network',
      'time': '14:26',
    },
    {
      'type': 'sent',
      'user': 'You',
      'text': 'All good on my end! 45 Mbps download speed.',
      'time': '14:27',
    },
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'type': 'sent',
        'user': 'You',
        'text': text,
        'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      });
    });
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showSOS() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 22),
            SizedBox(width: 8),
            Text(
              'Emergency SOS',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: const Text(
          'Emergency SOS sent to all nearby devices on the local network.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final role = provider.selectedRole.isEmpty ? 'guest' : provider.selectedRole;

    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 800;
      return Scaffold(
        backgroundColor: AppColors.background,
        drawer: isWide ? null : Sidebar(role: role, currentRoute: '/chatroom'),
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          leading: isWide
              ? null
              : Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
          title: const Row(
            children: [
              Text('Emergency Chatroom'),
              SizedBox(width: 6),
              Text('🔴', style: TextStyle(fontSize: 14)),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withAlpha(80)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi, color: AppColors.primary, size: 12),
                  SizedBox(width: 4),
                  Text(
                    'LAN Only',
                    style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            if (isWide) Sidebar(role: role, currentRoute: '/chatroom'),
            Expanded(
              child: Column(
                children: [
                  // Warning banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: const Color(0xFF1A1500),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFFFFB300), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This chat works on local network only - no internet required',
                            style: const TextStyle(
                              color: Color(0xFFFFB300),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Messages
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        if (msg['type'] == 'system') {
                          return _buildSystemMessage(msg['text'] as String, msg['time'] as String);
                        }
                        final isSent = msg['type'] == 'sent';
                        return _buildMessageBubble(
                          msg['text'] as String,
                          msg['user'] as String,
                          msg['time'] as String,
                          isSent,
                        );
                      },
                    ),
                  ),
                  // Input bar
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(top: BorderSide(color: AppColors.divider)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.location_on_outlined, color: AppColors.textSecondary),
                          onPressed: () {
                            setState(() {
                              _messages.add({
                                'type': 'sent',
                                'user': 'You',
                                'text': '📍 Shared location: 37.7749° N, 122.4194° W',
                                'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                              });
                            });
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: const TextStyle(color: AppColors.textSecondary),
                              filled: true,
                              fillColor: AppColors.card,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _sendMessage,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.send, color: Colors.black, size: 18),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _showSOS,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.sos, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSystemMessage(String text, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$text · $time',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, String user, String time, bool isSent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSent) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withAlpha(25),
              child: Text(
                user[0].toUpperCase(),
                style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isSent)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 2),
                  child: Text(user, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSent ? AppColors.primary : AppColors.card,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isSent ? 16 : 4),
                    bottomRight: Radius.circular(isSent ? 4 : 16),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isSent ? Colors.black : AppColors.textPrimary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
                child: Text(time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
