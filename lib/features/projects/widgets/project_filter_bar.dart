import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';

class ProjectFilterBar extends StatefulWidget {
  final Function(String) onSearch;
  final Function(String) onStatusFilterChanged;
  final Function(String) onSortChanged;
  final bool showMyProjectsToggle;
  final bool myProjectsOnly;
  final Function() onMyProjectsToggled;

  const ProjectFilterBar({
    super.key,
    required this.onSearch,
    required this.onStatusFilterChanged,
    required this.onSortChanged,
    required this.showMyProjectsToggle,
    required this.myProjectsOnly,
    required this.onMyProjectsToggled,
  });

  @override
  State<ProjectFilterBar> createState() => _ProjectFilterBarState();
}

class _ProjectFilterBarState extends State<ProjectFilterBar> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';
  String _selectedSort = 'Created Date';

  final List<String> _statusOptions = [
    'All',
    'Active',
    'Pending',
    'Completed',
    'Canceled',
  ];

  final List<String> _sortOptions = [
    'Created Date',
    'Name',
    'Location',
    'Status',
    'Start Date',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveFilterBar(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchField(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatusDropdown()),
              const SizedBox(width: 12),
              Expanded(child: _buildSortDropdown()),
            ],
          ),
          if (widget.showMyProjectsToggle) ...[
            const SizedBox(height: 12),
            _buildMyProjectsToggle(),
          ],
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: _buildSearchField()),
          const SizedBox(width: 16),
          Expanded(child: _buildStatusDropdown()),
          const SizedBox(width: 16),
          Expanded(child: _buildSortDropdown()),
          if (widget.showMyProjectsToggle) ...[
            const SizedBox(width: 16),
            _buildMyProjectsToggle(),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: _buildSearchField()),
          const SizedBox(width: 24),
          Expanded(child: _buildStatusDropdown()),
          const SizedBox(width: 24),
          Expanded(child: _buildSortDropdown()),
          if (widget.showMyProjectsToggle) ...[
            const SizedBox(width: 24),
            _buildMyProjectsToggle(),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search projects...',
        prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      onChanged: widget.onSearch,
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
          ),
          items:
              _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedStatus = newValue;
              });
              widget.onStatusFilterChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSort,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
          ),
          items:
              _sortOptions.map((String sort) {
                return DropdownMenuItem<String>(value: sort, child: Text(sort));
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedSort = newValue;
              });
              widget.onSortChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMyProjectsToggle() {
    return Row(
      children: [
        Text('My Projects Only', style: AppTextStyles.bodyMedium),
        const SizedBox(width: 8),
        Switch(
          value: widget.myProjectsOnly,
          onChanged: (_) => widget.onMyProjectsToggled(),
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}

class ResponsiveFilterBar extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveFilterBar({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (Utils.isMobile(context)) {
      return mobile;
    } else if (Utils.isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }
}
