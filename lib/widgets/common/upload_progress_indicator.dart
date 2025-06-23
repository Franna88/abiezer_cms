import 'package:flutter/material.dart';

class UploadProgressIndicator extends StatelessWidget {
  final double progress;
  final VoidCallback? onCancel;
  final String? statusText;
  final bool showPercentage;

  const UploadProgressIndicator({
    Key? key,
    required this.progress,
    this.onCancel,
    this.statusText,
    this.showPercentage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressPercentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress header
          Row(
            children: [
              Icon(
                Icons.cloud_upload,
                color: theme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  statusText ?? 'Uploading image...',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (onCancel != null)
                IconButton(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close),
                  tooltip: 'Cancel upload',
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar
          Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.dividerColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.primaryColor,
                ),
                minHeight: 6,
              ),

              const SizedBox(height: 8),

              // Progress text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (showPercentage)
                    Text(
                      '$progressPercentage%',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  Text(
                    _getProgressText(progress),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getProgressText(double progress) {
    if (progress < 0.1) {
      return 'Starting upload...';
    } else if (progress < 0.9) {
      return 'Uploading...';
    } else if (progress < 1.0) {
      return 'Finalizing...';
    } else {
      return 'Complete!';
    }
  }
}
