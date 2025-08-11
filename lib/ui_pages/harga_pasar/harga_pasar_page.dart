import 'package:flutter/material.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/harga_pasar/custom_app_bar.dart';
import '../../shared/widgets/harga_pasar/harga_filter.dart';
import '../../shared/widgets/harga_pasar/harga_pasar_list.dart';
import '../../shared/widgets/harga_pasar/search_section.dart';

class HargaPasarPage extends StatefulWidget {
  const HargaPasarPage({super.key});

  @override
  HargaPasarPageState createState() => HargaPasarPageState();
}

class HargaPasarPageState extends State<HargaPasarPage> {
  bool _isSearchSectionVisible = true;

  // ---- state untuk search & filter ----
  String _query = '';
  HargaFilter _filter = HargaFilter.semua;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar('Harga Pasar'),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification &&
              scrollNotification.metrics.axis == Axis.vertical &&
              scrollNotification.scrollDelta != null) {
            final dy = scrollNotification.scrollDelta!;
            // hide saat scroll turun, show saat scroll naik
            if (dy > 0 && _isSearchSectionVisible) {
              setState(() => _isSearchSectionVisible = false);
            } else if (dy < 0 && !_isSearchSectionVisible) {
              setState(() => _isSearchSectionVisible = true);
            }
          }
          return false; // biar notifikasi tetap bubble up
        },
        child: Column(
          children: [
            if (_isSearchSectionVisible)
              SearchSection(
                onQueryChanged: (q) => setState(() => _query = q),
                onFilterChanged: (f) => setState(() => _filter = f),
                initialFilter: _filter,
              ),
            Expanded(
              child: HargaPasarList(
                searchQuery: _query,
                filter: _filter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
