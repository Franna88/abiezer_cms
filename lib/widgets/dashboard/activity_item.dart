import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class ActivityItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const ActivityItem({
    Key? key,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    this.color = AppTheme.primaryColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textLightColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Description
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
