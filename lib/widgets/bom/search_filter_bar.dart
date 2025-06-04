import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SearchFilterBar extends StatefulWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;
  final String? selectedCategory;
  final List<String> categories;
  final Function(String?) onCategoryChanged;

  const SearchFilterBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
  });

  @override
  _SearchFilterBarState createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search materials...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            DropdownButton<String>(
              value: widget.selectedCategory,
              hint: const Text('All Categories'),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Categories'),
                ),
                ...widget.categories.map(
                  (category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ),
                ),
              ],
              onChanged: widget.onCategoryChanged,
            ),
          ],
        ),
      ),
    );
  }
}
