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
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline line and icon
            Column(
              children: [
                Container(
                  width: 2,
                  height: index == 0 ? 24 : 12,
                  color: index == 0 ? Colors.transparent : Colors.grey[300],
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: activity.color.withOpacity(0.12),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: activity.color.withOpacity(0.08),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    activity.icon,
                    color: activity.color,
                    size: 24,
                  ),
                ),
                Container(
                  width: 2,
                  height: index == activities.length - 1 ? 24 : 36,
                  color: index == activities.length - 1
                      ? Colors.transparent
                      : Colors.grey[300],
                ),
              ],
            ),
            const SizedBox(width: 18),
            // Activity content
            Expanded(
              child: Card(
                elevation: 1,
                margin: EdgeInsets.only(bottom: 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
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
