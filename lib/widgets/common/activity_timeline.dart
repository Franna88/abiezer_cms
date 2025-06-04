import 'package:flutter/material.dart';

class ActivityTimeline extends StatelessWidget {
  final List<ActivityItem> activities;

  const ActivityTimeline({
    Key? key,
    required this.activities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (context, index) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: activity.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                activity.icon,
                color: activity.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ActivityItem {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const ActivityItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
    this.onTap,
  });
}
