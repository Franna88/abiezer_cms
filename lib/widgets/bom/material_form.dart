import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../models/material_model.dart';
import '../../services/bom_service.dart';
import '../../utils/currency_formatter.dart';

class MaterialForm extends StatefulWidget {
  final MaterialModel? material;
  final Function(MaterialModel) onSubmit;
  final VoidCallback onClose;
  final bool isLoading;

  const MaterialForm({
    super.key,
    this.material,
    required this.onSubmit,
    required this.onClose,
    this.isLoading = false,
  });

  @override
  State<MaterialForm> createState() => _MaterialFormState();
}

class _MaterialFormState extends State<MaterialForm> {
  final _formKey = GlobalKey<FormState>();
  final _bomService = BoMService();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _unitController;
  late TextEditingController _costController;
  late TextEditingController _supplierController;
  late TextEditingController _initialStockController;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.material?.name);
    _categoryController = TextEditingController(
      text: widget.material?.category,
    );
    _unitController = TextEditingController(text: widget.material?.unit);
    _costController = TextEditingController(
      text:
          widget.material?.cost != null
              ? CurrencyFormatter.formatWithoutSymbol(widget.material!.cost)
              : '',
    );
    _supplierController = TextEditingController(
      text: widget.material?.supplier,
    );
    _initialStockController = TextEditingController(
      text: widget.material?.initialStock.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _unitController.dispose();
    _costController.dispose();
    _supplierController.dispose();
    _initialStockController.dispose();
    super.dispose();
  }

  Future<void> _showDeleteConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Material'),
          content: Text(
            'Are you sure you want to delete "${widget.material?.name}"? This action cannot be undone and will remove all history and project allocations.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _handleDelete();
              },
              child: Text('Delete', style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleDelete() async {
    if (widget.material == null) return;

    setState(() => _isDeleting = true);
    try {
      await _bomService.deleteMaterial(widget.material!.id);
      if (mounted) {
        widget.onClose();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Material deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting material: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final material = MaterialModel(
        id: widget.material?.id ?? '',
        name: _nameController.text,
        category: _categoryController.text,
        unit: _unitController.text,
        cost: double.parse(_costController.text),
        supplier: _supplierController.text,
        initialStock: double.parse(_initialStockController.text),
        createdAt: widget.material?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      widget.onSubmit(material);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.material != null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEditing ? 'Edit Material' : 'Add New Material',
                style: AppTextStyles.heading2,
              ),
              Row(
                children: [
                  if (isEditing)
                    TextButton.icon(
                      icon: Icon(Icons.delete, color: AppColors.error),
                      label: Text(
                        'Delete',
                        style: TextStyle(color: AppColors.error),
                      ),
                      onPressed: _isDeleting ? null : _showDeleteConfirmation,
                    ),
                  SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Material Name*',
              hintText: 'Enter material name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter material name';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(
              labelText: 'Category*',
              hintText: 'Enter category',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter category';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _unitController,
                  decoration: const InputDecoration(
                    labelText: 'Unit*',
                    hintText: 'e.g., kg, pieces',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter unit';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _costController,
                  decoration: const InputDecoration(
                    labelText: 'Cost per Unit*',
                    hintText: 'Enter cost',
                    prefixText: 'R',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cost';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _supplierController,
            decoration: const InputDecoration(
              labelText: 'Supplier*',
              hintText: 'Enter supplier name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter supplier';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _initialStockController,
            decoration: InputDecoration(
              labelText: 'Initial Stock*',
              hintText: 'Enter initial stock',
              suffixText: _unitController.text,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter initial stock';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              if (double.parse(value) < 0) {
                return 'Initial stock cannot be negative';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: AppSpacing.minButtonHeight,
            child: ElevatedButton(
              onPressed: (widget.isLoading || _isDeleting) ? null : _submitForm,
              child:
                  widget.isLoading || _isDeleting
                      ? const CircularProgressIndicator()
                      : Text(
                        isEditing ? 'Update Material' : 'Add Material',
                        style: AppTextStyles.button,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
