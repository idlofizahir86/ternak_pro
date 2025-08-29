import 'package:flutter/material.dart';


class SearchSection extends StatefulWidget {
  const SearchSection({
    super.key,
    required this.onQueryChanged,
  });

  final ValueChanged<String> onQueryChanged;

  @override
  SearchSectionState createState() => SearchSectionState();
}

class SearchSectionState extends State<SearchSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
            margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
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
        
      ],
    );
  }
}
