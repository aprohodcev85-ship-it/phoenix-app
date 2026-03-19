import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/models/chat_message_model.dart';
import '../data/repository/chat_repository.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  bool _isLoading = true;
  Map<String, String> _userChats = {};
  final String _userPhone = '+7 (900) 000-00-00'; // Демо телефон пользователя

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    setState(() => _isLoading = true);
    final repo = ChatRepository();
    final chats = await repo.getUserChats(_userPhone);
    
    if (mounted) {
      setState(() {
        _userChats = chats;
        _isLoading = false;
      });
    }
  }

  String _formatChatTitle(String chatId) {
    // Если это груз, возвращаем "Груз №X"
    if (chatId.startsWith('cargo_')) {
      return 'Груз №${chatId.replaceFirst('cargo_', '')}';
    }
    // Если это транспорт, возвращаем "Машина №X"
    if (chatId.startsWith('transport_')) {
      return 'Машина №${chatId.replaceFirst('transport_', '')}';
    }
    return 'Чат $chatId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        title: const Text('Сообщения', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _userChats.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _userChats.length,
                  itemBuilder: (context, index) {
                    final chatId = _userChats.keys.elementAt(index);
                    return _buildChatItem(chatId);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded, size: 64, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('Пока нет сообщений', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('Начните диалог, чтобы вести переписку', style: TextStyle(color: Colors.white54, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildChatItem(String chatId) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B35).withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, color: Color(0xFFFF6B35), size: 24),
      ),
      title: Text(
        _formatChatTitle(chatId),
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: [
          const Icon(Icons.schedule, size: 12, color: Colors.white54),
          const SizedBox(width: 4),
          Text(
            '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
      onTap: () => context.push('/chat/$chatId'),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}