import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../providers/project_provider.dart';
import '../../../models/bom_item_model.dart';
import '../../../utils/app_theme.dart';
import '../../../services/storage_service.dart';

class UsageLogForm extends StatefulWidget {
  const UsageLogForm({Key? key}) : super(key: key);

  @override
  State<UsageLogForm> createState() => _UsageLogFormState();
}

class _UsageLogFormState extends State<UsageLogForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMaterialId;
  final _quantityController = TextEditingController();
  final _noteController = TextEditingController();
  XFile? _photo;
  bool _isLoading = false;

  @override
  void dispose() {
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() => _photo = photo);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error taking photo: $e')));
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedMaterialId == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final projectProvider = Provider.of<ProjectProvider>(
        context,
        listen: false,
      );
      final projectId = projectProvider.selectedProject!.id;

      // Upload photo if taken
      String? photoUrl;
      if (_photo != null) {
        photoUrl = await StorageService.uploadUsagePhoto(
          projectId: projectId,
          materialId: _selectedMaterialId!,
          file: _photo!,
        );
      }

      // Log usage in Firestore
      await projectProvider.logMaterialUsage(
        projectId: projectId,
        materialId: _selectedMaterialId!,
        quantity: int.parse(_quantityController.text),
        note: _noteController.text,
        photoUrl: photoUrl,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usage logged successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error logging usage: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final bomStream = projectProvider.selectedProjectBoMStream;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Log Material Usage',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Material Dropdown
                  StreamBuilder<List<BoMItemModel>>(
                    stream: bomStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final items = snapshot.data!;
                      return DropdownButtonFormField<String>(
                        value: _selectedMaterialId,
                        decoration: const InputDecoration(
                          labelText: 'Material',
                          border: OutlineInputBorder(),
                        ),
                        items: items.map((item) {
                          return DropdownMenuItem(
                            value: item.id,
                            child: Text(item.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedMaterialId = value);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a material';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Quantity Field
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity Used',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Note Field
                  TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: 'Note (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Photo Button
                  OutlinedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(_photo == null ? 'Take Photo' : 'Retake Photo'),
                  ),
                  if (_photo != null) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Photo captured',
                      style: TextStyle(color: AppTheme.successColor),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
