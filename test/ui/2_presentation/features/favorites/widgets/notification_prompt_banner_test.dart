import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivr/ui/2_presentation/features/favorites/widgets/notification_prompt_banner.dart';

void main() {
  group('NotificationPromptBanner', () {
    testWidgets('renders title and description', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoPageScaffold(
            child: NotificationPromptBanner(onDismiss: () {}),
          ),
        ),
      );

      expect(find.text('Enable Flood Alerts'), findsOneWidget);
      expect(
        find.text('Get notified when your rivers exceed flood thresholds.'),
        findsOneWidget,
      );
    });

    testWidgets('renders bell icon', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoPageScaffold(
            child: NotificationPromptBanner(onDismiss: () {}),
          ),
        ),
      );

      expect(find.byIcon(CupertinoIcons.bell_fill), findsOneWidget);
    });

    testWidgets('renders dismiss button with xmark icon', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoPageScaffold(
            child: NotificationPromptBanner(onDismiss: () {}),
          ),
        ),
      );

      expect(find.byIcon(CupertinoIcons.xmark), findsOneWidget);
    });

    testWidgets('renders CTA button', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoPageScaffold(
            child: NotificationPromptBanner(onDismiss: () {}),
          ),
        ),
      );

      expect(find.text('Set Up Notifications'), findsOneWidget);
    });

    testWidgets('dismiss button calls onDismiss callback', (tester) async {
      var dismissed = false;

      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoPageScaffold(
            child: NotificationPromptBanner(
              onDismiss: () => dismissed = true,
            ),
          ),
        ),
      );

      // Tap the dismiss (X) button
      await tester.tap(find.byIcon(CupertinoIcons.xmark));
      await tester.pumpAndSettle();

      expect(dismissed, isTrue);
    });

    testWidgets('CTA button navigates to notifications settings',
        (tester) async {
      String? pushedRoute;

      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoPageScaffold(
            child: NotificationPromptBanner(onDismiss: () {}),
          ),
          onGenerateRoute: (settings) {
            pushedRoute = settings.name;
            return CupertinoPageRoute(
              builder: (_) => const CupertinoPageScaffold(
                child: Text('Settings'),
              ),
            );
          },
        ),
      );

      await tester.tap(find.text('Set Up Notifications'));
      await tester.pumpAndSettle();

      expect(pushedRoute, '/notifications-settings');
    });
  });
}
