import 'package:flutter/material.dart';
import '../../core/theme/color_theme.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utilities/utilities.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final bool isExpanded;
  final bool isRequired;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isExpanded = true,
    this.isRequired = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(label, style: AppTextStyles.inputLabel),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: AppTextStyles.inputLabel.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: isExpanded,
          validator: validator,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.textSecondary,
          ),
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            errorText: errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Utils.borderRadiusMD),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Utils.borderRadiusMD),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Utils.borderRadiusMD),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Utils.borderRadiusMD),
              borderSide: BorderSide(color: AppColors.error),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(Utils.borderRadiusMD),
        ),
      ],
    );
  }
}
