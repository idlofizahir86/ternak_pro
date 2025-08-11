import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
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
  late stt.SpeechToText _speech;
  Duration _recordDuration = Duration.zero;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    

    _ticker = Ticker((elapsed) {
      if (mounted) {
        setState(() => _recordDuration = elapsed);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMessages();
      if (!mounted) return;

      // Jangan panggil _unfocusKeyboard di awal initState
      FocusScope.of(context).unfocus();

      if (widget.initialText != null &&
          widget.initialText!.trim().isNotEmpty &&
          widget.externalInput == true) {
        // Gunakan versi yang tidak memanggil unfocus di awal
        setState(() {
          messages.add({'user': widget.initialText!});
          messages.add({'ai': 'Ini jawaban bot untuk: ${widget.initialText!}'});
          isTyping = false;
        });
        _saveMessages();
      }
    });
  }

  Future<void> _loadMessages() async {
  final prefs = await SharedPreferences.getInstance();
  final savedMessages = prefs.getStringList('chatMessages') ?? [];

  if (savedMessages.isEmpty) {
    // Jika kosong, isi pesan pembuka dan simpan ke SharedPreferences
    messages = [
      {'ai': "Halo Adam👋, Kenalin Aku Siternak Asisten Ternak Pribadimu !"},
      {'ai': "Bagaimana Aku Bisa Membantumu ☺️ ?"},
    ];

    // Simpan ke local storage
    final saved = messages.map((msg) =>
      msg.containsKey('user') ? 'user:${msg['user']}' : 'ai:${msg['ai']}').toList();
    await prefs.setStringList('chatMessages', saved);

    setState(() {});
  } else {
    // Jika ada pesan tersimpan, load ke state
    setState(() {
      messages = savedMessages
          .map((msg) => msg.startsWith('user:')
              ? {'user': msg.substring(5)}
              : {'ai': msg.substring(3)})
          .toList();
    });
  }
}


  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = messages.map((msg) =>
        msg.containsKey('user') ? 'user:${msg['user']}' : 'ai:${msg['ai']}').toList();
    await prefs.setStringList('chatMessages', saved);
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


  void _addUserMessage(String text) {
    if (text.isEmpty) return;
    _clearInputText();
    _unfocusKeyboard();
    setState(() {
      messages.add({'user': text});
      messages.add({'ai': 'Ini jawaban bot untuk: $text'});
      controller.clear();
      isTyping = false;
    });
    _saveMessages();
    Future.delayed(Duration(milliseconds: 300), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
  }

  void _startListening() async {
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
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('/start'),
            onTap: () {
              Navigator.pop(context);
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _unfocusKeyboard(); // unfocus setelah bottomsheet ditutup
              });
              _addUserMessage('/start');
            },
          ),
          ListTile(
            title: Text('/kabar-ternak'),
            onTap: () {
              Navigator.pop(context);
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _unfocusKeyboard(); // unfocus setelah bottomsheet ditutup
              });
              _addUserMessage('/kabar-ternak');
            },
          ),
          ListTile(
            title: Text('/bantuan'),
            onTap: () {
              Navigator.pop(context);
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _unfocusKeyboard(); // unfocus setelah bottomsheet ditutup
              });
              _addUserMessage('/bantuan');
            },
          ),
        ],
      ),
    ),
  );
}


  @override
  void dispose() {
    controller.dispose();
    _speech.stop();
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
              height: MediaQuery.of(context).size.height * 0.8,
              child: Opacity(
                opacity: 0.6,
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/ai_chat_assets/images/img_background.png',
                    fit: BoxFit.contain,
                  ),
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
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return msg.containsKey('user')
                          ? _userChat(msg['user']!)
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _botChat(msg['ai']!),
                            );
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
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('chatMessages');

                          // 2) Pastikan widget masih ter-mount
                          if (!mounted) return; // kalau di State class; atau if (!context.mounted) return;

                          setState(() {
                            messages.clear();
                            messages.add({'ai': "Halo Adam👋, Kenalin Aku Siternak Asisten Ternak Pribadimu !"});
                            messages.add({'ai': "Bagaimana Aku Bisa Membantumu ☺️ ?"});
                          });

                          if (!sheetContext.mounted) return;
                          Navigator.of(context).pop();
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
                    // textInputAction: TextInputAction.done,
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        _stopListening(); 
                        _addUserMessage(val.trim());
                        _clearInputText();
                        _unfocusKeyboard();
                      }
                    },
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.deny(RegExp(r'^\s*\n')), // mencegah enter tanpa isi
                    // ],
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
                      _addUserMessage(controller.text.trim());
                      _clearInputText();
                      _unfocusKeyboard(); 
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

        // Tambahkan ini setelah Row di atas
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
