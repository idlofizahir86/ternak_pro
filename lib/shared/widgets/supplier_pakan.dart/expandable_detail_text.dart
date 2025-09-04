import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class ExpandableDetailText extends StatefulWidget {
  final String text;
  final int trimLines;

  const ExpandableDetailText({
    super.key,
    required this.text,
    this.trimLines = 3,
  });

  @override
  State<ExpandableDetailText> createState() => _ExpandableDetailTextState();
}

class _ExpandableDetailTextState extends State<ExpandableDetailText> {
  bool _expanded = false;

  TextStyle get _detailStyle => AppTextStyle.medium.copyWith(
        fontSize: 14,
        color: AppColors.black100,
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_expanded) {
          return Text(
            widget.text,
            style: _detailStyle,
            textAlign: TextAlign.justify,
          );
        }

        // Cek apakah overflow jika 3 baris
        final full = TextSpan(text: widget.text, style: _detailStyle);
        final tp = TextPainter(
          text: full,
          textDirection: TextDirection.ltr,
          maxLines: widget.trimLines,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflow = tp.didExceedMaxLines;
        if (!isOverflow) {
          // Tidak overflow → tampil apa adanya
          return Text(
            widget.text,
            style: _detailStyle,
            textAlign: TextAlign.justify,
          );
        }

        // Kita siapkan suffix klik
        const spacer = ' ';
        final suffixText = '$spacer Lihat Selengkapnya';
        final suffixSpan = TextSpan(
          text: suffixText,
          style: _detailStyle.copyWith(
            color: AppColors.red600,
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => setState(() => _expanded = true),
        );

        // Cari index potong agar … + suffix muat di 3 baris:
        // Binary search untuk index substring maksimum yang masih muat jika ditambah suffix
        int min = 0;
        int max = widget.text.length;
        int best = 0;

        while (min <= max) {
          final mid = (min + max) >> 1;
          final trySpan = TextSpan(
            children: [
              TextSpan(text: widget.text.substring(0, mid), style: _detailStyle),
              // tambahkan tiga titik + spasi agar natural
              TextSpan(text: '…', style: _detailStyle),
              suffixSpan,
            ],
          );
          final tryPainter = TextPainter(
            text: trySpan,
            textDirection: TextDirection.ltr,
            maxLines: widget.trimLines,
          )..layout(maxWidth: constraints.maxWidth);

          if (!tryPainter.didExceedMaxLines) {
            best = mid;        // masih muat → coba lebih panjang
            min = mid + 1;
          } else {
            max = mid - 1;     // kepanjangan → pendekkan
          }
        }

        // Bangun tampilan dengan potongan + "… Lihat Selengkapnya"
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.text.substring(0, best),
                style: _detailStyle,
              ),
              TextSpan(text: '…', style: _detailStyle),
              suffixSpan,
            ],
          ),
          textAlign: TextAlign.justify,
        );
      },
    );
  }
}
