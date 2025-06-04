import 'package:flutter/material.dart';
import '../../../utils/responsive_helper.dart';

class AuditTrailModal extends StatelessWidget {
  const AuditTrailModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveLayout.isMobile(context) ? double.infinity : 600,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Audit Trail',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildAuditEntry(
                      action: 'Added user Mark Brown',
                      user: 'Admin Alice',
                      timestamp: '2025-05-19 02:55 PM',
                    ),
                    _buildAuditEntry(
                      action: 'Assigned John Doe to Project Z',
                      user: 'Admin Alice',
                      timestamp: '2025-05-19 02:56 PM',
                    ),
                    _buildAuditEntry(
                      action: 'Updated permissions for Jane Smith',
                      user: 'Admin Alice',
                      timestamp: '2025-05-19 03:00 PM',
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditEntry({
    required String action,
    required String user,
    required String timestamp,
  }) {
    return Card(
      child: ListTile(
        title: Text(action),
        subtitle: Text('By $user'),
        trailing: Text(
          timestamp,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
