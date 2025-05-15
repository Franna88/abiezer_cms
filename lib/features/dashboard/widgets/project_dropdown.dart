import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';

class ProjectDropdown extends StatefulWidget {
  final Function(String)? onProjectSelected;

  const ProjectDropdown({super.key, this.onProjectSelected});

  @override
  State<ProjectDropdown> createState() => _ProjectDropdownState();
}

class _ProjectDropdownState extends State<ProjectDropdown> {
  String? _selectedProject;

  // This would be replaced with real data from a backend
  final List<_ProjectItem> _projects = [
    _ProjectItem(id: '1', name: 'Project Alpha', location: 'Cape Town'),
    _ProjectItem(id: '2', name: 'Project Beta', location: 'Johannesburg'),
    _ProjectItem(id: '3', name: 'Project Gamma', location: 'Durban'),
    _ProjectItem(id: '4', name: 'Project Delta', location: 'Pretoria'),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with the first project
    if (_projects.isNotEmpty) {
      _selectedProject = _projects.first.id;
      // Notify parent of initial selection
      if (widget.onProjectSelected != null) {
        widget.onProjectSelected!(_selectedProject!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_projects.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedProjectItem = _projects.firstWhere(
      (project) => project.id == _selectedProject,
      orElse: () => _projects.first,
    );

    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      child: PopupMenuButton<String>(
        initialValue: _selectedProject,
        onSelected: (String projectId) {
          setState(() {
            _selectedProject = projectId;
          });
          if (widget.onProjectSelected != null) {
            widget.onProjectSelected!(projectId);
          }
        },
        offset: const Offset(0, 40),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.business, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  selectedProjectItem.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
        itemBuilder: (BuildContext context) {
          return _projects.map((project) {
            return PopupMenuItem<String>(
              value: project.id,
              child: Row(
                children: [
                  Icon(
                    Icons.business,
                    color:
                        _selectedProject == project.id
                            ? AppColors.primary
                            : AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          project.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight:
                                _selectedProject == project.id
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color:
                                _selectedProject == project.id
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          project.location,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_selectedProject == project.id)
                    Icon(Icons.check, color: AppColors.primary, size: 20),
                ],
              ),
            );
          }).toList();
        },
      ),
    );
  }
}

class _ProjectItem {
  final String id;
  final String name;
  final String location;

  _ProjectItem({required this.id, required this.name, required this.location});
}
