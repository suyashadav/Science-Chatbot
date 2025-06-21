import 'package:flutter/material.dart';
import 'chatbot_service.dart';
import 'home.dart';
import 'quizzes_page.dart';
import 'profile_page.dart';
import 'resources_page.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  bool _isInitializing = true;
  bool _soundEnabled = true;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeChatbot();
  }

  Future<void> _initializeChatbot() async {
    try {
      await ChatbotService.initialize();
      setState(() => _isInitializing = false);
      _addWelcomeMessage();
    } catch (e) {
      setState(() {
        _isInitializing = false;
        _messages.add({
          'text': 'Failed to initialize chatbot. Please restart the app.',
          'isUser': false,
          'image': null,
          'isError': true,
        });
      });
    }
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add({
        'text':
            'Hello! I\'m your Science ChatBot. You can ask multiple questions at once!',
        'isUser': false,
        'image': null,
        'isError': false,
      });
    });
    _scrollToBottom();
    if (_soundEnabled) {
      ChatbotService.speak(
          'Hello! I\'m your Science ChatBot. You can ask multiple questions at once!');
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty || _isLoading || _isInitializing) return;

    final userMessage = _controller.text;
    _controller.clear();

    setState(() {
      _messages.add({
        'text': userMessage,
        'isUser': true,
        'image': null,
        'isError': false,
      });
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final responses = await ChatbotService.processUserInput(userMessage);

      setState(() {
        for (final response in responses) {
          _messages.add({
            'text': response['answer']!,
            'isUser': false,
            'image': response['image'],
            'isError': false,
          });
        }
        _isLoading = false;
      });
      _scrollToBottom();

      if (_soundEnabled) {
        for (final response in responses) {
          await ChatbotService.speak(response['answer']!);
        }
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'text': 'Sorry, I encountered an error. Please try again.',
          'isUser': false,
          'image': null,
          'isError': true,
        });
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleSound() async {
    setState(() {
      _soundEnabled = !_soundEnabled;
    });
    if (!_soundEnabled) {
      await ChatbotService.tts.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Science ChatBot'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset(
              _soundEnabled
                  ? 'assets/images/volume-up.png'
                  : 'assets/images/mute.png',
              width: 24,
              height: 24,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            onPressed: _toggleSound,
            tooltip: _soundEnabled ? 'Turn sound off' : 'Turn sound on',
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: Column(
          children: [
            Expanded(
              child: _isInitializing
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return message['isUser']
                            ? UserMessageBubble(
                                message: message['text'] as String,
                              )
                            : BotMessageBubble(
                                message: message['text'] as String,
                                imagePath: message['image'] as String?,
                                isError: message['isError'] as bool,
                              );
                      },
                    ),
            ),
            _buildInputField(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.black54,
            currentIndex: 2,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/home1.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/home1.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/resource.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/resource.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Resource',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/bubble-chat.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/bubble-chat.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Chat-Bot',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/ideas.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/ideas.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Quiz',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/user.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/user.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                // break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResourcesPage()),
                  );
                  break;
                case 2:
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const ChatbotPage()),
                  // );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QuizzesPage()),
                  );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Ask science questions...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8.0),
          CircleAvatar(
            backgroundColor: Colors.teal[800],
            child: IconButton(
              icon: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.send, color: Colors.white),
              onPressed: _isLoading ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class UserMessageBubble extends StatelessWidget {
  final String message;

  const UserMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.teal[600],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class BotMessageBubble extends StatelessWidget {
  final String message;
  final String? imagePath;
  final bool isError;

  const BotMessageBubble({
    super.key,
    required this.message,
    this.imagePath,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            margin: const EdgeInsets.only(bottom: 8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isError ? Colors.red[100] : Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isError ? Colors.red[800] : Colors.black87,
              ),
            ),
          ),
          if (imagePath != null && imagePath!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/$imagePath',
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
