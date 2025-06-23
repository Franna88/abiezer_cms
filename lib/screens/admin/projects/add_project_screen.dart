import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../providers/projects_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/responsive.dart';
import '../../../services/user_service.dart';
import '../../../services/storage_service.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();
  final _storageService = StorageService();
  final _imagePicker = ImagePicker();

  // Step management
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Project Details Controllers
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _status = 'Active';
  final List<String> _selectedProjectManagers = [];

  // Client Details Controllers
  final _clientNameController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _clientEmailController = TextEditingController();
  final _clientCompanyController = TextEditingController();
  bool _isCommercial = false;

  // Budget Estimate Controllers
  final _budgetController = TextEditingController();
  String _budgetCurrency = 'ZAR';

  // Project Documents & Images
  XFile? _projectImage;
  final List<File> _selectedDocuments = [];

  // State variables
  bool _isLoading = false;
  List<Map<String, dynamic>> _projectManagers = [];
  bool _isLoadingManagers = false;
  bool _skipClientDetails = false;
  bool _skipBudgetEstimate = false;

  @override
  void initState() {
    super.initState();
    _loadProjectManagers();
  }

  Future<void> _loadProjectManagers() async {
    setState(() => _isLoadingManagers = true);
    try {
      final managers = await _userService.getProjectManagers();
      setState(() {
        _projectManagers = managers;
        _isLoadingManagers = false;
      });
    } catch (e) {
      setState(() => _isLoadingManagers = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading project managers: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _clientEmailController.dispose();
    _clientCompanyController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickProjectImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _projectImage = image;
      });
    }
  }

  void _removeProjectImage() {
    setState(() {
      _projectImage = null;
    });
  }

  Future<void> _pickDocuments() async {
    final List<XFile> images = await _imagePicker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedDocuments.addAll(images.map((image) => File(image.path)));
      });
    }
  }

  void _removeDocument(int index) {
    setState(() {
      _selectedDocuments.removeAt(index);
    });
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _skipStep() {
    switch (_currentStep) {
      case 1: // Client Details
        setState(() {
          _skipClientDetails = true;
          _currentStep++;
        });
        break;
      case 2: // Budget Estimate
        setState(() {
          _skipBudgetEstimate = true;
          _currentStep++;
        });
        break;
    }
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0: // Project Details
        return _nameController.text.isNotEmpty &&
            _locationController.text.isNotEmpty &&
            _descriptionController.text.isNotEmpty &&
            _startDate != null &&
            _endDate != null &&
            _selectedProjectManagers.isNotEmpty;
      case 1: // Client Details
        if (_skipClientDetails) return true;
        final basicDetailsValid = _clientNameController.text.isNotEmpty &&
            _clientPhoneController.text.isNotEmpty &&
            _clientEmailController.text.isNotEmpty;
        if (_isCommercial) {
          return basicDetailsValid && _clientCompanyController.text.isNotEmpty;
        }
        return basicDetailsValid;
      case 2: // Budget Estimate
        if (_skipBudgetEstimate) return true;
        if (_budgetController.text.isEmpty) return true;
        final cleanString = _budgetController.text.replaceAll(',', '');
        final budgetValue = double.tryParse(cleanString);
        return budgetValue != null && budgetValue >= 0;
      case 3: // Project Documents
        return true; // Always can proceed, documents are optional
      default:
        return false;
    }
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        if (userProvider.user == null) {
          throw Exception('You must be logged in to create a project');
        }

        final projectsProvider =
            Provider.of<ProjectsProvider>(context, listen: false);

        // Upload documents if any
        List<String> documentUrls = [];
        if (_selectedDocuments.isNotEmpty) {
          for (final document in _selectedDocuments) {
            final url = await _storageService.uploadProjectDocument(
              document,
              _nameController.text,
            );
            documentUrls.add(url);
          }
        }

        // Upload project images
        String? imageUrl;
        if (_projectImage != null) {
          final url = await _storageService.uploadProjectImage(
            _projectImage!,
            _nameController.text,
          );
          imageUrl = url;
        }

        // Create project with all the data
        await projectsProvider.createProject(
          name: _nameController.text,
          location: _locationController.text,
          description: _descriptionController.text,
          startDate: _startDate!,
          endDate: _endDate!,
          status: _status,
          projectManagerIds: _selectedProjectManagers,
          createdBy: userProvider.user?.id ?? '',
          projectImageUrl: imageUrl,
          // Additional fields (you may need to update your model and provider)
          clientName: _skipClientDetails ? null : _clientNameController.text,
          clientPhone: _skipClientDetails ? null : _clientPhoneController.text,
          clientEmail: _skipClientDetails ? null : _clientEmailController.text,
          clientCompany:
              _skipClientDetails ? null : _clientCompanyController.text,
          isCommercial: _skipClientDetails ? null : _isCommercial,
          budget: _skipBudgetEstimate
              ? null
              : (_budgetController.text.isNotEmpty
                  ? double.parse(_budgetController.text.replaceAll(',', ''))
                  : null),
          documentUrls: documentUrls,
        );

        if (mounted) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Project created successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Error creating project';
          if (e.toString().contains('must be logged in')) {
            errorMessage = 'You must be logged in to create a project';
          } else {
            errorMessage = 'Error creating project: ${e.toString()}';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentStep + 1} of $_totalSteps',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                '${((_currentStep + 1) / _totalSteps * 100).round()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            minHeight: 8,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStepIndicator(0, 'Project Details', Icons.work),
              _buildStepIndicator(1, 'Client Details', Icons.person),
              _buildStepIndicator(2, 'Budget', Icons.attach_money),
              _buildStepIndicator(3, 'Documents', Icons.folder),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String label, IconData icon) {
    final isActive = _currentStep == stepIndex;
    final isCompleted = _currentStep > stepIndex;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppTheme.primaryColor
                  : isActive
                      ? AppTheme.primaryColor.withOpacity(0.2)
                      : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : icon,
              color: isCompleted
                  ? Colors.white
                  : isActive
                      ? AppTheme.primaryColor
                      : Colors.grey.shade600,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? AppTheme.primaryColor : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildProjectDetailsStep();
      case 1:
        return _buildClientDetailsStep();
      case 2:
        return _buildBudgetEstimateStep();
      case 3:
        return _buildProjectDocumentsStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildProjectDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Information',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Fill in the basic details for your new project',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
        ),
        const SizedBox(height: 32),

        // Project Name
        TextFormField(
          controller: _nameController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'Project Name *',
            hintText: 'Enter project name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.work),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a project name';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),

        // Location
        TextFormField(
          controller: _locationController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'Location *',
            hintText: 'Enter project location',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a location';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),

        // Description
        TextFormField(
          controller: _descriptionController,
          onChanged: (_) => setState(() {}),
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Description *',
            hintText: 'Enter project description',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description),
            alignLabelWithHint: true,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),

        // Project Image
        _buildImagePicker(),
        const SizedBox(height: 24),

        // Date Selection
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context, true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Start Date *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDate(_startDate)),
                      const Icon(Icons.arrow_drop_down, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context, false),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'End Date *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDate(_endDate)),
                      const Icon(Icons.arrow_drop_down, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Status
        DropdownButtonFormField<String>(
          value: _status,
          onChanged: (value) {
            if (value != null) {
              setState(() => _status = value);
            }
          },
          decoration: const InputDecoration(
            labelText: 'Status',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.flag),
          ),
          items: <String>[
            'Active',
            'Pending',
            'On Hold',
            'Completed',
            'Cancelled'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),

        // Project Managers Section
        Text(
          'Project Managers *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select one or more project managers for this project',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
        ),
        const SizedBox(height: 16),

        if (_isLoadingManagers)
          const Center(child: CircularProgressIndicator())
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._projectManagers.map((manager) {
                  final isSelected =
                      _selectedProjectManagers.contains(manager['id']);
                  return FilterChip(
                    label: Text(manager['name']),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryColor,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedProjectManagers.add(manager['id']);
                        } else {
                          _selectedProjectManagers.remove(manager['id']);
                        }
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),

        if (_projectManagers.isEmpty && !_isLoadingManagers)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  'No project managers available',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Image',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Center(
          child: _projectImage == null
              ? InkWell(
                  onTap: _pickProjectImage,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border:
                          Border.all(color: Colors.grey.shade400, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add Project Image',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb
                            ? Image.network(
                                _projectImage!.path,
                                fit: BoxFit.contain,
                                height: 150,
                                width: double.infinity,
                              )
                            : Image.file(
                                File(_projectImage!.path),
                                fit: BoxFit.contain,
                                height: 150,
                                width: double.infinity,
                              ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: _removeProjectImage,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildClientDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Client Information',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Enter client details (optional)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
        ),
        const SizedBox(height: 32),

        // Client Name
        TextFormField(
          controller: _clientNameController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'Client Name',
            hintText: 'Enter client name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 24),

        // Client Phone
        TextFormField(
          controller: _clientPhoneController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter phone number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        const SizedBox(height: 24),

        // Client Email
        TextFormField(
          controller: _clientEmailController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter email address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 24),

        // Commercial Project Checkbox
        CheckboxListTile(
          title: const Text('Commercial Project'),
          subtitle: const Text('Check if this is a commercial project'),
          value: _isCommercial,
          onChanged: (value) {
            setState(() {
              _isCommercial = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 16),

        // Client Company (only show if commercial)
        if (_isCommercial) ...[
          TextFormField(
            controller: _clientCompanyController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Company Name *',
              hintText: 'Enter company name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.business),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildBudgetEstimateStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Budget Estimate',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Set an initial budget for the project (optional)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
        ),
        const SizedBox(height: 32),
        TextFormField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
          inputFormatters: <TextInputFormatter>[
            ThousandsSeparatorInputFormatter(),
          ],
          decoration: const InputDecoration(
            labelText: 'Budget Amount',
            hintText: 'Enter budget amount',
            border: OutlineInputBorder(),
            prefixText: 'R ',
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This budget will help guide material and purchase decisions throughout the project lifecycle.',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Project Documents',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Upload initial project documents (optional)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
        ),
        const SizedBox(height: 32),

        // Upload Button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            border: Border.all(
                color: AppTheme.dividerColor, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          child: Column(
            children: [
              Icon(
                Icons.cloud_upload,
                size: 48,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Upload Documents',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload blueprints, contracts, permits, or other project documents',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickDocuments,
                icon: const Icon(Icons.add),
                label: const Text('Select Files'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Selected Documents List
        if (_selectedDocuments.isNotEmpty) ...[
          Text(
            'Selected Documents (${_selectedDocuments.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          ..._selectedDocuments.asMap().entries.map((entry) {
            final index = entry.key;
            final document = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(document.path.split('/').last),
                subtitle: Text(
                    '${(document.lengthSync() / 1024).toStringAsFixed(1)} KB'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeDocument(index),
                ),
              ),
            );
          }).toList(),
        ],
      ],
    );
  }

  Widget _buildNavigationButtons() {
    final bool isSkippable = _currentStep == 1 || _currentStep == 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous Button
        if (_currentStep > 0)
          TextButton.icon(
            onPressed: _previousStep,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Previous'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          )
        else
          const SizedBox.shrink(),

        // Action Buttons (Right side)
        Row(
          children: [
            // Skip Button
            if (isSkippable)
              TextButton(
                onPressed: _skipStep,
                child: const Text('Skip'),
              ),
            if (isSkippable) const SizedBox(width: 8),

            // Next/Create Button
            ElevatedButton.icon(
              onPressed: _canProceedToNextStep()
                  ? (_currentStep == _totalSteps - 1
                      ? _handleSubmit
                      : _nextStep)
                  : null,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(_currentStep == _totalSteps - 1
                      ? Icons.check
                      : Icons.arrow_forward),
              label: Text(
                  _currentStep == _totalSteps - 1 ? 'Create Project' : 'Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Project'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    Responsive.getResponsiveValue(
                      context: context,
                      mobile: 16.0,
                      tablet: 24.0,
                      desktop: 32.0,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: _buildStepContent(),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: MediaQuery.of(context).padding.bottom > 0 ? 8 : 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: _buildNavigationButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    final String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    final number = int.parse(digitsOnly);
    final String newString = NumberFormat('#,###').format(number);
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
