import 'package:flutter/material.dart';

import 'harga_filter.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({
    super.key,
    required this.onQueryChanged,
    required this.onFilterChanged,
    this.initialFilter = HargaFilter.semua,
  });

  final ValueChanged<String> onQueryChanged;
  final ValueChanged<HargaFilter> onFilterChanged;
  final HargaFilter initialFilter;

  @override
  SearchSectionState createState() => SearchSectionState();
}

class SearchSectionState extends State<SearchSection> {
  final TextEditingController _searchController = TextEditingController();
  late HargaFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }
  

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withAlpha(26)),
              borderRadius: BorderRadius.circular(28),
            ),
            margin: const EdgeInsets.only(left: 23),
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Row(
              children: [
                Image.asset("assets/harga_pasar_assets/icons/ic_search.png", width: 20),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onChanged: widget.onQueryChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 5, right: 23),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.black.withAlpha(26)),
          ),
          child: PopupMenuButton<HargaFilter>(
            initialValue: _filter,
            onSelected: (f) {
              setState(() => _filter = f);
              widget.onFilterChanged(f);
            },
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: HargaFilter.semua, child: Text('Semua')),
              PopupMenuItem(value: HargaFilter.naik, child: Text('Harga Naik')),
              PopupMenuItem(value: HargaFilter.turun, child: Text('Harga Turun')),
              PopupMenuItem(value: HargaFilter.stabil, child: Text('Harga Stabil')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Image.asset("assets/harga_pasar_assets/icons/ic_filter.png", width: 20),
                  const SizedBox(width: 6),
                  Text('Filter'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
