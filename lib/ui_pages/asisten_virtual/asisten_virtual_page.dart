import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:ternak_pro/shared/custom_loading.dart';
import '../../services/chat_service.dart';
import '../../shared/theme.dart';

class AsistenVirtualPage extends StatefulWidget {
  final String? initialText;
  final bool? externalInput;
  const AsistenVirtualPage({super.key, this.initialText, this.externalInput = false});

  @override
  State<AsistenVirtualPage> createState() => _AsistenVirtualPageState();
}

class _AsistenVirtualPageState extends State<AsistenVirtualPage> {
  List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isTyping = false;
  bool isListening = false;
  bool isLoadingAI = false;
  late stt.SpeechToText _speech;
  Duration _recordDuration = Duration.zero;
  late Ticker _ticker;
  late ChatService _chatService;
  String? _currentUserId;
  int? _currentConversationId;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _chatService = ChatService();
    _ticker = Ticker((elapsed) {
      if (mounted) {
        setState(() => _recordDuration = elapsed);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
      _unfocusKeyboard();

      if (widget.initialText != null &&
          widget.initialText!.trim().isNotEmpty &&
          widget.externalInput == true) {
        _handleSendMessage(widget.initialText!);
      }
    });
  }

  // Load data user dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getString('user_id');
    });

    if (_currentUserId != null) {
      await _loadOrCreateConversation();
    } else {
      // Jika tidak ada user ID, gunakan mode guest atau handle error
      setState(() {
        messages = [
          {'ai': "Halo! 👋 Saya adalah asisten virtual TernakPro."},
          {'ai': "Silakan login untuk menggunakan fitur penuh."},
        ];
      });
    }
  }

  Future<void> _loadOrCreateConversation() async {
    try {
      final conversations = await _chatService.getConversations(_currentUserId!);
      if (conversations.isNotEmpty) {
        // Ambil percakapan terbaru (asumsikan sorted descending by date)
        final latestConversation = conversations.first;
        _currentConversationId = latestConversation['id'];
        
        // Load messages dari percakapan ini
        await _loadConversationMessages();
      } else {
        // Buat percakapan baru jika tidak ada
        final newConv = await _chatService.startNewConversation(_currentUserId!);
        _currentConversationId = newConv['conversation_id'];
        
        // Tambahkan pesan pembuka dari AI (bisa dari server atau local)
        setState(() {
          messages.add({'ai': "Halo! 👋 Saya adalah asisten virtual TernakPro."});
          messages.add({'ai': "Saya siap membantu Anda dengan segala pertanyaan tentang peternakan."});
        });
        
        // Opsional: Kirim pesan pembuka ke server jika diperlukan
      }
      
      // Scroll ke bawah setelah load
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    } catch (e) {
      print('Error loading/creating conversation: $e');
      setState(() {
        messages.add({'ai': 'Maaf, gagal memuat percakapan. Silakan coba lagi.'});
      });
    }
  }

  Future<void> _loadConversationMessages() async {
    try {
      final conversationData = await _chatService.getConversation(
        _currentUserId!, 
        _currentConversationId!
      );
      
      final serverMessages = conversationData['messages'] ?? [];
      setState(() {
        messages = serverMessages.map<Map<String, String>>((msg) {
          return msg['role'] == 'user' ? {'user': msg['content']} : {'ai': msg['content']};
        }).toList();
      });
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  void _unfocusKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _clearInputText() {
    controller.clear();
    setState(() {
      isTyping = false;
    });
  }

  // Handler untuk mengirim pesan
  Future<void> _handleSendMessage(String text) async {
    if (text.isEmpty || isLoadingAI) return; // Cegah kirim jika sedang loading
    
    _clearInputText();
    _unfocusKeyboard();
    
    // Tambahkan pesan user ke UI
    setState(() {
      messages.add({'user': text});
      isLoadingAI = true;
    });
    
    // Scroll ke bawah
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

    try {
      // Kirim ke API
      final response = await _chatService.sendMessage(
        userId: _currentUserId ?? 'default-user',
        message: text,
        conversationId: _currentConversationId,
      );

      // Update conversation ID jika baru
      if (_currentConversationId == null) {
        _currentConversationId = response['conversation_id'];
      }

      // Tambahkan response AI ke UI
      setState(() {
        messages.add({'ai': response['response']});
        isLoadingAI = false;
      });
      
      // Scroll ke bawah lagi
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      
    } catch (e) {
      // Handle error
      setState(() {
        messages.add({'ai': 'Maaf, terjadi kesalahan. Silakan coba lagi.'});
        isLoadingAI = false;
      });
      print('Error sending message: $e');
    }
  }

  void _startListening() async {
    if (isLoadingAI) return; // Cegah jika sedang loading
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        isListening = true;
        _recordDuration = Duration.zero;
      });
      _ticker.start();
      _speech.listen(
        onResult: (val) {
          controller.text = val.recognizedWords;
          setState(() => isTyping = val.recognizedWords.isNotEmpty);
        },
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.dictation,
        ),
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    _ticker.stop();
    _unfocusKeyboard();
    setState(() => isListening = false);
  }

  void _showSlashMenu() {
    if (isLoadingAI) return; // Cegah jika sedang loading
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('/start'),
              onTap: () {
                Navigator.pop(context);
                _handleSendMessage('/start');
              },
            ),
            ListTile(
              title: Text('/kabar-ternak'),
              onTap: () {
                Navigator.pop(context);
                _handleSendMessage('/kabar-ternak');
              },
            ),
            ListTile(
              title: Text('/bantuan'),
              onTap: () {
                Navigator.pop(context);
                _handleSendMessage('/bantuan');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearChatHistory() async {
    if (_currentUserId == null || _currentConversationId == null) {
      setState(() {
        messages.clear();
      });
      return;
    }

    try {
      await _chatService.deleteConversation(_currentUserId!, _currentConversationId!);
      // Buat percakapan baru setelah delete
      await _loadOrCreateConversation();
    } catch (e) {
      print('Error clearing history: $e');
      setState(() {
        messages.add({'ai': 'Gagal membersihkan riwayat. Silakan coba lagi.'});
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _speech.stop();
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( 
      onTap: _unfocusKeyboard,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.gradasiAIchat,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/ai_chat_assets/images/img_background.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: messages.length + (isLoadingAI ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < messages.length) {
                        final msg = messages[index];
                        return msg.containsKey('user')
                            ? _userChat(msg['user']!)
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _botChat(msg['ai']!),
                              );
                      } else {
                        return _buildLoadingAI();
                      }
                    },
                  ),
                ),
                _buildChatInput(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk loading AI
  Widget _buildLoadingAI() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset('assets/ai_chat_assets/icons/ic_ternakbot.png', width: 36),
        const SizedBox(width: 8),
        Flexible(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: TernakProBoxLoading(),
                    ),
                    SizedBox(width: 8),
                    Text('AI sedang mengetik...', 
                         style: AppTextStyle.medium.copyWith(color: AppColors.blackText, fontSize: 14)),
                  ],
                ),
              ),
              Positioned(
                left: -6,
                bottom: 20,
                child: Transform.rotate(
                  angle: 0.785,
                  child: Container(width: 12, height: 12, color: AppColors.primaryWhite),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.bgLight,
          boxShadow: [
            BoxShadow(
              color: AppColors.black100.withAlpha(17),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/main'),
              child: Image.asset('assets/auth_assets/icons/ic_back.png', color: AppColors.black100),
            ),
            const SizedBox(width: 12),
            Image.asset('assets/ai_chat_assets/icons/ic_ternakbot.png', width: 57, height: 57),
            const SizedBox(width: 8),
            Text("SITERNAK", style: AppTextStyle.semiBold.copyWith(fontSize: 16, color: AppColors.blackText)),
            const Spacer(),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (sheetContext) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.delete_forever),
                        title: Text("Bersihkan riwayat chat"),
                        onTap: () async {
                          await _clearChatHistory();
                          if (sheetContext.mounted) {
                            Navigator.of(sheetContext).pop();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Image.asset('assets/ai_chat_assets/icons/ic_more.png', height: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: AbsorbPointer(
        absorbing: isLoadingAI, // Disable input saat loading
        child: Opacity(
          opacity: isLoadingAI ? 0.5 : 1.0, // Visual feedback
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _showSlashMenu,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.bgLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset('assets/ai_chat_assets/icons/ic_slash.png', width: 32),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 120),
                      child: Scrollbar(
                        child: TextField(
                          controller: controller,
                          onChanged: (val) => setState(() => isTyping = val.trim().isNotEmpty),
                          maxLines: null,
                          onSubmitted: (val) {
                            if (val.trim().isNotEmpty) {
                              _stopListening(); 
                              _handleSendMessage(val.trim());
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Tulis pertanyaan...",
                            hintStyle: AppTextStyle.regular.copyWith(color: AppColors.grey2, fontSize: 14),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  isTyping
                      ? GestureDetector(
                          onTap: () { 
                            _stopListening();
                            _handleSendMessage(controller.text.trim());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: AppColors.gradasi01,
                              borderRadius: BorderRadius.circular(80),
                              border: Border.all(color: AppColors.grey20),
                            ),
                            child: Image.asset('assets/ai_chat_assets/icons/ic_send.png', width: 25),
                          ),
                        )
                      : GestureDetector(
                          onTap: isListening ? _stopListening : _startListening,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.bgLight,
                              borderRadius: BorderRadius.circular(80),
                              border: Border.all(color: AppColors.grey20),
                            ),
                            child: Image.asset('assets/ai_chat_assets/icons/ic_mic.png', width: 25),
                          ),
                        ),
                ],
              ),
              if (isListening)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "⏱ ${_recordDuration.inMinutes.toString().padLeft(2, '0')}:${(_recordDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                        style: TextStyle(color: Colors.red),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              controller.clear();
                              _stopListening();
                              _clearInputText();      
                              _unfocusKeyboard();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botChat(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset('assets/ai_chat_assets/icons/ic_ternakbot.png', width: 36),
        const SizedBox(width: 8),
        Flexible(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(text, style: AppTextStyle.medium.copyWith(color: AppColors.blackText, fontSize: 14)),
              ),
              Positioned(
                left: -6,
                bottom: 20,
                child: Transform.rotate(
                  angle: 0.785,
                  child: Container(width: 12, height: 12, color: AppColors.primaryWhite),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _userChat(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.green01,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(text, style: AppTextStyle.medium.copyWith(color: Colors.white, fontSize: 14)),
              ),
              Positioned(
                right: -6,
                bottom: 20,
                child: Transform.rotate(
                  angle: 0.785,
                  child: Container(width: 12, height: 12, color: AppColors.green01),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Image.asset('assets/ai_chat_assets/icons/ic_farmer.png', width: 36),
      ],
    );
  }
}