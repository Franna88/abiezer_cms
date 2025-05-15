import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/responsive_layout.dart';

class MaterialFilterBar extends StatelessWidget {
  final Function(String) onSearch;
  final Function(String) onCategoryChanged;
  final Function(String) onSortChanged;
  final VoidCallback onToggleLowStockOnly;
  final VoidCallback onToggleLeftoverOnly;
  final String selectedCategory;
  final String sortBy;
  final bool showLowStockOnly;
  final bool showLeftoverOnly;
  final List<String> categories;

  const MaterialFilterBar({
    super.key,
    required this.onSearch,
    required this.onCategoryChanged,
    required this.onSortChanged,
    required this.onToggleLowStockOnly,
    required this.onToggleLeftoverOnly,
    required this.selectedCategory,
    required this.sortBy,
    required this.showLowStockOnly,
    required this.showLeftoverOnly,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchField(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildCategoryDropdown()),
              const SizedBox(width: 12),
              Expanded(child: _buildSortDropdown()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildLowStockToggle()),
              const SizedBox(width: 12),
              Expanded(child: _buildLeftoverToggle()),
            ],
          ),
        ],
      ),
      tablet: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(flex: 2, child: _buildSearchField()),
              const SizedBox(width: 12),
              Expanded(child: _buildCategoryDropdown()),
              const SizedBox(width: 12),
              Expanded(child: _buildSortDropdown()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLowStockToggle(),
              const SizedBox(width: 12),
              _buildLeftoverToggle(),
            ],
          ),
        ],
      ),
      desktop: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(flex: 2, child: _buildSearchField()),
              const SizedBox(width: 12),
              Expanded(child: _buildCategoryDropdown()),
              const SizedBox(width: 12),
              Expanded(child: _buildSortDropdown()),
              const SizedBox(width: 12),
              _buildLowStockToggle(),
              const SizedBox(width: 12),
              _buildLeftoverToggle(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search materials...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
      ),
      onChanged: onSearch,
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: selectedCategory,
            isExpanded: true,
            hint: const Text('Category'),
            icon: const Icon(Icons.keyboard_arrow_down),
            borderRadius: BorderRadius.circular(8),
            items: [
              const DropdownMenuItem(
                value: 'All Categories',
                child: Text('All Categories'),
              ),
              ...categories.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ],
            onChanged: (String? value) {
              if (value != null) {
                onCategoryChanged(value);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: sortBy,
            isExpanded: true,
            hint: const Text('Sort By'),
            icon: const Icon(Icons.keyboard_arrow_down),
            borderRadius: BorderRadius.circular(8),
            items: const [
              DropdownMenuItem(value: 'Name', child: Text('Name')),
              DropdownMenuItem(value: 'Category', child: Text('Category')),
              DropdownMenuItem(
                value: 'Quantity (High to Low)',
                child: Text('Quantity (High to Low)'),
              ),
              DropdownMenuItem(
                value: 'Quantity (Low to High)',
                child: Text('Quantity (Low to High)'),
              ),
              DropdownMenuItem(
                value: 'Price (High to Low)',
                child: Text('Price (High to Low)'),
              ),
              DropdownMenuItem(
                value: 'Price (Low to High)',
                child: Text('Price (Low to High)'),
              ),
            ],
            onChanged: (String? value) {
              if (value != null) {
                onSortChanged(value);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLowStockToggle() {
    return FilterChip(
      label: const Text('Low Stock Only'),
      labelStyle: TextStyle(
        color: showLowStockOnly ? Colors.white : AppColors.textPrimary,
        fontWeight: showLowStockOnly ? FontWeight.bold : FontWeight.normal,
      ),
      selected: showLowStockOnly,
      onSelected: (_) => onToggleLowStockOnly(),
      backgroundColor: Colors.white,
      selectedColor: AppColors.lowStock,
      checkmarkColor: Colors.white,
      avatar: Icon(
        Icons.warning_amber_outlined,
        color: showLowStockOnly ? Colors.white : AppColors.lowStock,
        size: 18,
      ),
    );
  }

  Widget _buildLeftoverToggle() {
    return FilterChip(
      label: const Text('Leftover Materials'),
      labelStyle: TextStyle(
        color: showLeftoverOnly ? Colors.white : AppColors.textPrimary,
        fontWeight: showLeftoverOnly ? FontWeight.bold : FontWeight.normal,
      ),
      selected: showLeftoverOnly,
      onSelected: (_) => onToggleLeftoverOnly(),
      backgroundColor: Colors.white,
      selectedColor: AppColors.accent,
      checkmarkColor: Colors.white,
      avatar: Icon(
        Icons.recycling_outlined,
        color: showLeftoverOnly ? Colors.white : AppColors.accent,
        size: 18,
      ),
    );
  }
}
