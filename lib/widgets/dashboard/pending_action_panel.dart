import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class PendingActionPanel extends StatefulWidget {
  final String title;
  final int count;
  final IconData icon;
  final List<String> items;
  final VoidCallback onReview;

  const PendingActionPanel({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
    required this.items,
    required this.onReview,
  }) : super(key: key);

  @override
  State<PendingActionPanel> createState() => _PendingActionPanelState();
}

class _PendingActionPanelState extends State<PendingActionPanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  Icon(widget.icon, color: AppTheme.primaryColor, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.count > 0)
                          Text(
                            '${widget.count} pending',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  widget.count > 0
                                      ? AppTheme.accentColor
                                      : AppTheme.textSecondaryColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.count > 0) ...[
                    TextButton(
                      onPressed: widget.onReview,
                      child: const Text('Review'),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppTheme.textLightColor,
                  ),
                ],
              ),
            ),
          ),
          // Expanded content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height:
                _isExpanded && widget.items.isNotEmpty
                    ? (widget.items.length * 48.0)
                    : 0,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.dividerColor),
                    ),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text(
                      widget.items[index],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    onTap: widget.onReview,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
