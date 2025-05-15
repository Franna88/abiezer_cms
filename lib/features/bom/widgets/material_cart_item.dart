import 'package:flutter/material.dart';
import '../../../core/models/bill_of_materials_model.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';

class MaterialCartItem extends StatefulWidget {
  final BomItemModel item;
  final Function(String) onRemove;
  final Function(String, double) onUpdateQuantity;

  const MaterialCartItem({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
  });

  @override
  State<MaterialCartItem> createState() => _MaterialCartItemState();
}

class _MaterialCartItemState extends State<MaterialCartItem> {
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );
  }

  @override
  void didUpdateWidget(MaterialCartItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.quantity != widget.item.quantity) {
      _quantityController.text = widget.item.quantity.toString();
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _handleQuantityChanged(String value) {
    try {
      final quantity = double.parse(value);
      if (quantity > 0) {
        widget.onUpdateQuantity(widget.item.id, quantity);
      }
    } catch (e) {
      // Invalid number, ignore
    }
  }

  void _incrementQuantity() {
    final newQuantity = widget.item.quantity + 1;
    _quantityController.text = newQuantity.toString();
    widget.onUpdateQuantity(widget.item.id, newQuantity);
  }

  void _decrementQuantity() {
    if (widget.item.quantity > 1) {
      final newQuantity = widget.item.quantity - 1;
      _quantityController.text = newQuantity.toString();
      widget.onUpdateQuantity(widget.item.id, newQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final material = widget.item.material;
    final itemCost = widget.item.quantity * material.unitPrice;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    material.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                  onPressed: () => widget.onRemove(widget.item.id),
                  tooltip: 'Remove',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${material.unitOfMeasure} - ${Utils.formatCurrency(material.unitPrice)}',
                  style: AppTextStyles.bodyMedium,
                ),
                if (material.isLeftover)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Leftover',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Quantity:'),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _decrementQuantity,
                  tooltip: 'Decrease',
                ),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _handleQuantityChanged,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _incrementQuantity,
                  tooltip: 'Increase',
                ),
                const Spacer(),
                Text(
                  Utils.formatCurrency(itemCost),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
