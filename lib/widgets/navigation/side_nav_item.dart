import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive.dart';

class SideNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isExtended;

  const SideNavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isExtended = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: isExtended ? 250 : 72,
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisAlignment:
              isExtended ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: isExtended ? 16.0 : 0,
                right: 12.0,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                size: 24,
              ),
            ),
            if (isExtended)
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color:
                        isSelected ? Colors.white : AppTheme.textPrimaryColor,
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
