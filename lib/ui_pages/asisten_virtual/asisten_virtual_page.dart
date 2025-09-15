import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
  List<Map<String, dynamic>> messages = []; // Ubah ke dynamic untuk menyimpan metadata
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
  int _lastRequestId = 0; // Untuk melacak request terakhir
  bool _isInitialized = false;

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

    // Panggil load data dan auto-send setelah frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadUserData();  // Tunggu full load selesai (conversation + messages)
      _unfocusKeyboard();
      
      // SEKARANG auto-send initialText jika ada
      if (widget.initialText != null &&
          widget.initialText!.trim().isNotEmpty &&
          widget.externalInput == true &&
          _isInitialized &&  // Double-check
          _currentUserId != null &&
          _currentConversationId != null) {  // Pastikan conversation siap
        print('Auto-sending initialText: ${widget.initialText}');  // Debug log
        await _handleSendMessage(widget.initialText!.trim());
      } else {
        print('Skipping auto-send: initialText=${widget.initialText}, initialized=$_isInitialized, convId=$_currentConversationId');
      }
    });
  }

  // Load data user dari SharedPreferences
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _currentUserId = prefs.getString('user_id');
      });

      if (_currentUserId != null) {
        await _loadOrCreateConversation();
        
        // Setelah load selesai, baru proses initial text jika ada
        if (widget.initialText != null &&
            widget.initialText!.trim().isNotEmpty &&
            widget.externalInput == true) {// Langsung kirim pesan
            await _handleSendMessage(widget.initialText!.trim());
        }
      } else {
        // Jika tidak ada user ID, gunakan mode guest
        setState(() {
          messages = [
            {'role': 'ai', 'content': "Halo! 👋 Saya adalah asisten virtual TernakPro.", 'timestamp': DateTime.now()},
            {'role': 'ai', 'content': "Silakan login untuk menggunakan fitur penuh.", 'timestamp': DateTime.now()},
          ];
        });
      }
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        messages = [
          {'role': 'ai', 'content': "Terjadi kesalahan saat memuat data. Silakan coba lagi.", 'timestamp': DateTime.now()},
        ];
        _isInitialized = true;
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
        
        // Tambahkan pesan pembuka dari AI
        // setState(() {
        //   messages.add({'role': 'ai', 'content': "Halo! 👋 Saya adalah asisten virtual TernakPro.", 'timestamp': DateTime.now()});
        //   messages.add({'role': 'ai', 'content': "Saya siap membantu Anda dengan segala pertanyaan tentang peternakan.", 'timestamp': DateTime.now()});
        // });
      }
      
      // Scroll ke bawah setelah load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        }
      });
    } catch (e) {
      print('Error loading/creating conversation: $e');
      setState(() {
        messages.add({'role': 'ai', 'content': 'Maaf, gagal memuat percakapan. Silakan coba lagi.', 'timestamp': DateTime.now()});
      });
    }
  }

  // Pastikan chat yang dimuat sesuai dengan percakapan terakhir
  Future<void> _loadConversationMessages() async {
  try {
    if (_currentConversationId == null) return;
    
    final conversationData = await _chatService.getConversation(
      _currentUserId!, 
      _currentConversationId!
    );
    
    final serverMessages = conversationData['messages'] ?? [];
    setState(() {
      messages = serverMessages
          .map<Map<String, dynamic>>((msg) {
            DateTime parsedTime;
            try {
              // Coba parse timestamp dari server
              parsedTime = DateTime.parse(msg['timestamp'] ?? DateTime.now().toString());
            } catch (parseError) {
              // Fallback jika format invalid
              print('Warning: Invalid timestamp "${msg['timestamp']}", using now: $parseError');
              parsedTime = DateTime.now();
            }
            return {
              'role': msg['role'] == 'user' ? 'user' : 'ai',
              'content': msg['content'] ?? '', // Tambah null safety
              'timestamp': parsedTime,
              'id': msg['id']
            };
          })
          .toList()
        ..sort((Map<String, dynamic> a, Map<String, dynamic> b) => (a['timestamp'] as DateTime).compareTo(b['timestamp'] as DateTime))
        ..reversed.toList(); // Reverse: baru di awal (index 0)
    });
  } catch (e) {
    print('Error loading messages: $e'); // Ini tetap untuk log error besar (misal network)
    setState(() {
      messages.add({'role': 'ai', 'content': 'Gagal memuat riwayat percakapan.', 'timestamp': DateTime.now()});
    });
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

  // Handler untuk mengirim pesan dengan request tracking
  Future<void> _handleSendMessage(String text) async {
    if (text.isEmpty || isLoadingAI) return;
    
    _clearInputText();
    _unfocusKeyboard();
    
    final currentRequestId = ++_lastRequestId;
    
    // Tambahkan pesan user ke AWAL list (insert(0, ...))
    final userMessage = {
      'role': 'user', 
      'content': text, 
      'timestamp': DateTime.now(),
      'requestId': currentRequestId
    };
    
    setState(() {
      messages.insert(0, userMessage); // Insert ke awal
      // Tambahkan loading sebagai item sementara di index 0 (sebelum AI response)
      messages.insert(0, {
        'role': 'loading',  // Role khusus untuk loading
        'content': '', 
        'timestamp': DateTime.now().add(const Duration(milliseconds: 1)),  // Timestamp sedikit di masa depan agar urut
        'requestId': currentRequestId
      });
      isLoadingAI = true;
    });
    
    // Scroll ke bawah (maxScrollExtent)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      }
    });

    try {
      final response = await _chatService.sendMessage(
        userId: _currentUserId ?? 'default-user',
        message: text,
        conversationId: _currentConversationId,
      );

      if (currentRequestId != _lastRequestId) {
        print('Ignoring response for outdated request');
        // Hapus loading jika request outdated
        _removeLoadingIfNeeded(currentRequestId);
        return;
      }

      if (_currentConversationId == null) {
        _currentConversationId = response['conversation_id'];
      }

      // Hapus item loading berdasarkan requestId
      _removeLoadingIfNeeded(currentRequestId);

      // Tambahkan response AI ke AWAL list
      setState(() {
        messages.insert(0, { // Insert ke awal
          'role': 'ai', 
          'content': response['response'], 
          'timestamp': DateTime.now(),
          'requestId': currentRequestId
        });
        isLoadingAI = false;
      });
      
      // Scroll ke bawah lagi
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        }
      });
      
    } catch (e) {
      if (currentRequestId != _lastRequestId) {
        _removeLoadingIfNeeded(currentRequestId);
        return;
      }

      // Hapus loading dan tambahkan error
      _removeLoadingIfNeeded(currentRequestId);
      
      setState(() {
        messages.insert(0, { // Insert ke awal
          'role': 'ai', 
          'content': 'Maaf, terjadi kesalahan. Silakan coba lagi.', 
          'timestamp': DateTime.now(),
          'requestId': currentRequestId,
          'isError': true
        });
        isLoadingAI = false;
      });
      print('Error sending message: $e');
    }
  }

  void _removeLoadingIfNeeded(int requestId) {
    setState(() {
      messages.removeWhere((msg) => 
        msg['role'] == 'loading' && msg['requestId'] == requestId
      );
    });
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
      // Di akhir _clearChatHistory(), tambahkan:
      setState(() {
        messages.removeWhere((msg) => msg['role'] == 'loading');
      });
      // Buat percakapan baru setelah delete
      await _loadOrCreateConversation();
    } catch (e) {
      print('Error clearing history: $e');
      setState(() {
        messages.add({'role': 'ai', 'content': 'Gagal membersihkan riwayat. Silakan coba lagi.', 'timestamp': DateTime.now()});
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
    if (!_isInitialized) {
      return Scaffold(
        body: Center(
          child: TernakProBoxLoading(),
        ),
      );
    }

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
                      reverse: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: messages.length,  // Hilangkan + (isLoadingAI ? 1 : 0)
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final role = msg['role'] as String?;
                        
                        if (role == 'user') {
                          return _userChat(msg['content']!);
                        } else if (role == 'loading') {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildLoadingAI(),  // Gunakan widget loading yang sama
                          );
                        } else {
                          // AI atau error
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _botChat(msg['content']!, isError: msg['isError'] ?? false),
                          );
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

  // Menampilkan animasi loading saat AI memproses pesan
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
    return Container(
      color: AppColors.bgLight,
      child: SafeArea(
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

  // Widget untuk bot chat dengan penanganan error
  Widget _botChat(String text, {bool isError = false}) {
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
                  color: isError ? Colors.red[100] : AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: MarkdownBody(  // Ganti Text dengan MarkdownBody
                  data: text,  // Ini akan parse Markdown
                  styleSheet: MarkdownStyleSheet(
                    p: AppTextStyle.medium.copyWith(  // Style default untuk paragraf
                      color: isError ? Colors.red : AppColors.blackText,
                      fontSize: 14,
                    ),
                    strong: AppTextStyle.semiBold.copyWith(  // Style bold (untuk **text**)
                      color: isError ? Colors.red : AppColors.blackText,
                      fontSize: 14,
                    ),
                    em: AppTextStyle.italic.copyWith(  // Style italic (untuk *text*)
                      color: isError ? Colors.red : AppColors.blackText,
                      fontSize: 14,
                    ),
                    // Tambah style lain jika perlu, misal list atau code
                  ),
                  shrinkWrap: true,  // Biar fit di container
                  selectable: true,  // Bisa select text
                ),
              ),
              Positioned(
                left: -6,
                bottom: 20,
                child: Transform.rotate(
                  angle: 0.785,
                  child: Container(width: 12, height: 12, 
                    color: isError ? Colors.red[100]! : AppColors.primaryWhite),
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