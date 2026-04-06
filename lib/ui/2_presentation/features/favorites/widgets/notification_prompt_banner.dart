import 'package:flutter/cupertino.dart';
import 'package:rivr/ui/2_presentation/routing/app_router.dart';

/// Banner prompting users to enable flood alert notifications.
/// Shown on the favorites page when user has favorites but notifications disabled.
class NotificationPromptBanner extends StatelessWidget {
  final VoidCallback onDismiss;

  const NotificationPromptBanner({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemBlue.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                CupertinoIcons.bell_fill,
                color: CupertinoColors.systemBlue,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enable Flood Alerts',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label.resolveFrom(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get notified when your rivers exceed flood thresholds.',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel
                            .resolveFrom(context),
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: const Size.square(24),
                onPressed: onDismiss,
                child: Icon(
                  CupertinoIcons.xmark,
                  size: 16,
                  color:
                      CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: CupertinoColors.systemBlue,
              borderRadius: BorderRadius.circular(8),
              minimumSize: Size.zero,
              onPressed: () => AppRouter.pushNotificationsSettings(context),
              child: const Text(
                'Set Up Notifications',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
