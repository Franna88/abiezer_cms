import 'package:flutter/material.dart';
import '../../../core/models/bill_of_materials_model.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';

class MarkUsedDialog extends StatefulWidget {
  final BomItemModel item;

  const MarkUsedDialog({super.key, required this.item});

  @override
  State<MarkUsedDialog> createState() => _MarkUsedDialogState();
}

class _MarkUsedDialogState extends State<MarkUsedDialog> {
  late TextEditingController _quantityController;
  double _quantity = 0;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _validateQuantity(String value) {
    setState(() {
      _hasError = false;
      _errorMessage = '';

      if (value.isEmpty) {
        _hasError = true;
        _errorMessage = 'Please enter a quantity';
        return;
      }

      try {
        _quantity = double.parse(value);

        if (_quantity <= 0) {
          _hasError = true;
          _errorMessage = 'Quantity must be greater than zero';
        } else if (_quantity > widget.item.remainingQuantity) {
          _hasError = true;
          _errorMessage =
              'Quantity cannot exceed remaining quantity (${widget.item.remainingQuantity.toStringAsFixed(2)})';
        }
      } catch (e) {
        _hasError = true;
        _errorMessage = 'Please enter a valid number';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final material = widget.item.material;

    return AlertDialog(
      title: Text('Mark ${material.name} as Used'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Material info
          Text(
            'Available: ${widget.item.remainingQuantity.toStringAsFixed(2)} ${material.unitOfMeasure}',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),

          // Quantity input
          TextField(
            controller: _quantityController,
            decoration: InputDecoration(
              labelText: 'Quantity Used',
              hintText: 'Enter amount used',
              errorText: _hasError ? _errorMessage : null,
              border: const OutlineInputBorder(),
              suffixText: material.unitOfMeasure,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: _validateQuantity,
          ),

          // Cost calculation
          const SizedBox(height: 16),
          if (!_hasError && _quantity > 0)
            Text(
              'Cost: ${Utils.formatCurrency(_quantity * material.unitPrice)}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              _hasError || _quantity <= 0
                  ? null
                  : () => Navigator.pop(context, _quantity),
          child: const Text('Mark as Used'),
        ),
      ],
    );
  }
}
