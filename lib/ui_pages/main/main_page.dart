import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../cubit/konsultasi_page_cubit.dart';
import '../../cubit/page_cubit.dart';
import '../../shared/theme.dart';

import '../keuangan/keuangan_page.dart';
import 'konsultasi_page.dart';
import 'data_ternak_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
    
  @override
  Widget build(BuildContext context) {
    Widget buildContent(int currentIndex) {
      switch (currentIndex) {
        case 0:
          return HomePage();
        case 1:
          return DataTernakPage();
        case 2:
          return BlocBuilder<KonsultasiPageCubit, int>(
            builder: (context, subIndex) {
              return subIndex == 1 ? KeuanganPage() : KonsultasiPage();
            },
          );
        case 3:
          return ProfilePage();
        default:
          return HomePage();
      }
    }

    Widget customBottomNavigation(int currentIndex) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;

          // Ukuran dinamis berdasarkan lebar layar
          final double navbarHeight = (screenWidth * 0.18).clamp(60.0, 80.0);
          final double iconSize = (screenWidth * 0.07).clamp(24.0, 32.0);
          final double fontSize = (screenWidth * 0.03).clamp(10.0, 14.0);
          final double aiButtonSize = (screenWidth * 0.18).clamp(50.0, 68.0);
          final double aiIconSize = aiButtonSize * 0.55;

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: navbarHeight,
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.1 * 255).toInt()),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _NavBarItem(
                        index: 0,
                        currentIndex: currentIndex,
                        label: "Beranda",
                        iconSize: iconSize,
                        fontSize: fontSize,
                        activeAsset: "assets/navbar_assets/active/1.png",
                        inactiveAsset: "assets/navbar_assets/inactive/1.png",
                        onTap: () => context.read<PageCubit>().setPage(0),
                      ),
                      _NavBarItem(
                        index: 1,
                        currentIndex: currentIndex,
                        label: "Data Ternak",
                        iconSize: iconSize,
                        fontSize: fontSize,
                        activeAsset: "assets/navbar_assets/active/2.png",
                        inactiveAsset: "assets/navbar_assets/inactive/2.png",
                        onTap: () => context.read<PageCubit>().setPage(1),
                      ),
                      SizedBox(width: aiButtonSize + 12),
                      _NavBarItem(
                        index: 2,
                        currentIndex: currentIndex,
                        label: "Konsultasi",
                        iconSize: iconSize,
                        fontSize: fontSize,
                        activeAsset: "assets/navbar_assets/active/3.png",
                        inactiveAsset: "assets/navbar_assets/inactive/3.png",
                        onTap: () {
                          context.read<KonsultasiPageCubit>().setKonsultasiPage(0);
                          context.read<PageCubit>().setPage(2);
                        } 
                      ),
                      _NavBarItem(
                        index: 3,
                        currentIndex: currentIndex,
                        label: "Profil",
                        iconSize: iconSize,
                        fontSize: fontSize,
                        activeAsset: "assets/navbar_assets/active/4.png",
                        inactiveAsset: "assets/navbar_assets/inactive/4.png",
                        onTap: () => context.read<PageCubit>().setPage(3),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: navbarHeight - (aiButtonSize / 1.3),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext modalContext) {
                            return const _VoiceToTextModal();
                          },
                        );
                      },
                      child: Container(
                        width: aiButtonSize,
                        height: aiButtonSize,
                        decoration: BoxDecoration(
                          color: AppColors.green01,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha((0.1 * 255).toInt()),
                              blurRadius: 18,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/navbar_assets/ic_ai_voice.png",
                            width: aiIconSize,
                            height: aiIconSize,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Asisten AI",
                      style: AppTextStyle.semiBold.copyWith(
                        color: AppColors.grey2,
                        fontSize: fontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }


    return BlocBuilder<PageCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          backgroundColor: AppColors.bgLight,
          body: Stack(
            children: [
              buildContent(currentIndex),
              customBottomNavigation(currentIndex),
            ],
          ),
        );
      },
    );
  }
}

// Widget untuk item navbar
class _NavBarItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final String label;
  final String activeAsset;
  final String inactiveAsset;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;

  const _NavBarItem({
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.activeAsset,
    required this.inactiveAsset,
    required this.onTap,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == currentIndex;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 8),
            Image.asset(
              isActive ? activeAsset : inactiveAsset,
              width: iconSize,
              height: iconSize,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyle.semiBold.copyWith(
                color: isActive ? AppColors.green01 : AppColors.grey2,
                fontSize: fontSize,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// Modal untuk voice to text (dummy UI, ganti dengan plugin voice to text jika perlu)
class _VoiceToTextModal extends StatefulWidget {
  const _VoiceToTextModal();

  @override
  State<_VoiceToTextModal> createState() => _VoiceToTextModalState();
}


class _VoiceToTextModalState extends State<_VoiceToTextModal> with SingleTickerProviderStateMixin {
  String _text = "Mendengarkan...";
  bool _isRecording = false;
  stt.SpeechToText? _speech;
  bool _speechAvailable = false;
  bool _initTried = false;
  String? _errorMsg;
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  Future<void> _initSpeech() async {
    try {
      _speech = stt.SpeechToText();
      _speechAvailable = await _speech!.initialize(
        onStatus: (status) {
          if (status == "done" || status == "notListening") {
            setState(() {
              _isRecording = false;
            });
          }
        },
        onError: (error) {
          setState(() {
            _isRecording = false;
            _errorMsg = "Error: ${error.errorMsg}";
          });
        },
      );
      if (_speechAvailable) {
        _startListening();
      }
    } catch (e) {
      setState(() {
        _speechAvailable = false;
        _errorMsg = "Speech to text tidak tersedia: $e";
      });
    }
    setState(() {
      _initTried = true;
    });
  }

  void _startListening() async {
    if (_speechAvailable && _speech != null && !_isRecording) {
      setState(() {
        _isRecording = true;
        _text = "Mendengarkan...";
      });
      try {
        await _speech!.listen(
          onResult: (result) {
            if (result.recognizedWords.isNotEmpty) {
              setState(() {
                _text = result.recognizedWords;
              });
            }
          },
          localeId: "id_ID",
        );
        _timeoutTimer = Timer(const Duration(seconds: 10), () {
          if (_isRecording) {
            _speech?.stop();
          }
        });
      } catch (e) {
        setState(() {
          _errorMsg = "Gagal mendengarkan: $e";
          _isRecording = false;
        });
      }
    }
  }

  void _navigateToAsistenVirtual() {
    if (_text != "Mendengarkan..." && _text.trim().isNotEmpty) {
      Navigator.pushNamed(
        context,
        '/asisten-virtual',
        arguments: {
          'initialText': _text,
          'externalInput': true,
        },
      ).then((value) {
      }).catchError((e) {
      });
    } else {
      Navigator.pushNamed(
        context,
        '/main',
      ); // Tutup modal jika teks tidak valid
    }
  }

  @override
  void dispose() {
    _speech?.stop();
    _timeoutTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 8),
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_errorMsg != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    _errorMsg!,
                    style: AppTextStyle.regular.copyWith(color: AppColors.primaryRed),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (!_initTried)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: CircularProgressIndicator(),
                )
              else if (_speechAvailable)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xFF00C4B4), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildBar(0, _animation.value),
                                const SizedBox(width: 4),
                                _buildBar(1, _animation.value),
                                const SizedBox(width: 4),
                                _buildBar(2, _animation.value),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        SizedText(_text),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "Speech to text tidak tersedia di perangkat ini.",
                    style: AppTextStyle.regular.copyWith(color: AppColors.primaryRed),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
        // Tombol di pojok kanan atas
        Positioned(
  top: 0,
  right: 5,
  child: Container(
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      gradient: AppColors.gradasi01,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Transform.rotate(
      angle: -0.5236, // 30 derajat dalam radian (searah jarum jam)
      child: IconButton(
        icon: Icon(Icons.send, color: AppColors.primaryWhite),
        onPressed: _navigateToAsistenVirtual,
        tooltip: "Kirim ke Asisten Virtual",
      ),
    ),
  ),
),
      ],
    );
  }

  Widget _buildBar(int index, double value) {
    return Container(
      width: 6,
      height: 20 + (index == 1 ? 10 * value : 0),
      decoration: BoxDecoration(
        color: Color(0xFF00C4B4),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class SizedText extends StatelessWidget {
  final String text;

  const SizedText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyle.regular.copyWith(
        fontSize: 16,
        color: Color(0xFF00C4B4),
      ),
      textAlign: TextAlign.center,
    );
  }
}