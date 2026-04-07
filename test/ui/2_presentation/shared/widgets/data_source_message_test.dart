import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivr/ui/1_state/shared/section_load_state.dart';
import 'package:rivr/ui/2_presentation/shared/widgets/data_source_message.dart';

void main() {
  Widget buildApp(Widget child) {
    return CupertinoApp(home: CupertinoPageScaffold(child: child));
  }

  group('DataSourceMessage — full layout', () {
    testWidgets('loading state shows spinner message', (tester) async {
      await tester.pumpWidget(buildApp(
        const DataSourceMessage(
          state: SectionLoadState.loading,
          forecastType: 'short_range',
        ),
      ));

      expect(find.text('Loading Forecast'), findsOneWidget);
      expect(
        find.text(
          'Fetching short-range forecast from NOAA National Water Model...',
        ),
        findsOneWidget,
      );
      // No retry button when loading
      expect(find.text('Try Again'), findsNothing);
    });

    testWidgets('loaded state shows attribution', (tester) async {
      await tester.pumpWidget(buildApp(
        const DataSourceMessage(
          state: SectionLoadState.loaded,
          forecastType: 'medium_range',
        ),
      ));

      expect(find.text('Forecast Loaded'), findsOneWidget);
      expect(find.text('Data: NOAA National Water Model'), findsOneWidget);
    });

    testWidgets('empty state shows transient message with retry',
        (tester) async {
      var retryTapped = false;
      await tester.pumpWidget(buildApp(
        DataSourceMessage(
          state: SectionLoadState.empty,
          forecastType: 'medium_range',
          onRetry: () => retryTapped = true,
        ),
      ));

      expect(
        find.text('Forecast Temporarily Unavailable'),
        findsOneWidget,
      );
      expect(
        find.textContaining('temporarily unavailable'),
        findsOneWidget,
      );
      expect(
        find.textContaining('try refreshing in a few minutes'),
        findsOneWidget,
      );

      // Retry button is shown
      expect(find.text('Try Again'), findsOneWidget);
      await tester.tap(find.text('Try Again'));
      expect(retryTapped, true);
    });

    testWidgets('error state shows error message with retry', (tester) async {
      var retryTapped = false;
      await tester.pumpWidget(buildApp(
        DataSourceMessage(
          state: SectionLoadState.error,
          forecastType: 'long_range',
          onRetry: () => retryTapped = true,
        ),
      ));

      expect(find.text('Unable to Load Forecast'), findsOneWidget);
      expect(
        find.textContaining('Something went wrong'),
        findsOneWidget,
      );

      await tester.tap(find.text('Try Again'));
      expect(retryTapped, true);
    });

    testWidgets('unavailable state shows no-coverage message', (tester) async {
      await tester.pumpWidget(buildApp(
        const DataSourceMessage(
          state: SectionLoadState.unavailable,
          forecastType: 'long_range',
          onRetry: null,
        ),
      ));

      expect(find.text('No Long-range Coverage'), findsOneWidget);
      expect(
        find.textContaining('does not have long-range coverage'),
        findsOneWidget,
      );
      // No retry for permanent unavailability
      expect(find.text('Try Again'), findsNothing);
    });

    testWidgets('idle state shows waiting message', (tester) async {
      await tester.pumpWidget(buildApp(
        const DataSourceMessage(
          state: SectionLoadState.idle,
          forecastType: 'short_range',
        ),
      ));

      expect(find.text('Waiting to Load'), findsOneWidget);
      expect(
        find.textContaining('Waiting to load short-range forecast'),
        findsOneWidget,
      );
    });

    testWidgets('no retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(buildApp(
        const DataSourceMessage(
          state: SectionLoadState.error,
          forecastType: 'short_range',
          onRetry: null,
        ),
      ));

      expect(find.text('Try Again'), findsNothing);
    });
  });

  group('DataSourceMessage — compact layout', () {
    testWidgets('compact empty shows inline message', (tester) async {
      await tester.pumpWidget(buildApp(
        const DataSourceMessage(
          state: SectionLoadState.empty,
          forecastType: 'medium_range',
          compact: true,
        ),
      ));

      // Compact layout shows the message text but no title
      expect(find.text('Forecast Temporarily Unavailable'), findsNothing);
      expect(
        find.textContaining('temporarily unavailable'),
        findsOneWidget,
      );
    });

    testWidgets('compact loaded shows attribution', (tester) async {
      await tester.pumpWidget(buildApp(
        const DataSourceMessage(
          state: SectionLoadState.loaded,
          forecastType: 'short_range',
          compact: true,
        ),
      ));

      expect(find.text('Data: NOAA National Water Model'), findsOneWidget);
    });
  });

  group('DataSourceAttribution', () {
    testWidgets('shows NOAA attribution text', (tester) async {
      await tester.pumpWidget(buildApp(
        const DataSourceAttribution(),
      ));

      expect(find.text('Data: NOAA National Water Model'), findsOneWidget);
    });
  });

  group('Forecast type labels', () {
    testWidgets('short_range renders as short-range', (tester) async {
      await tester.pumpWidget(buildApp(
        const DataSourceMessage(
          state: SectionLoadState.loading,
          forecastType: 'short_range',
        ),
      ));

      expect(find.textContaining('short-range'), findsOneWidget);
    });

    testWidgets('medium_range renders as medium-range', (tester) async {
      await tester.pumpWidget(buildApp(
        const DataSourceMessage(
          state: SectionLoadState.loading,
          forecastType: 'medium_range',
        ),
      ));

      expect(find.textContaining('medium-range'), findsOneWidget);
    });

    testWidgets('long_range renders as long-range', (tester) async {
      await tester.pumpWidget(buildApp(
        const DataSourceMessage(
          state: SectionLoadState.loading,
          forecastType: 'long_range',
        ),
      ));

      expect(find.textContaining('long-range'), findsOneWidget);
    });
  });
}
