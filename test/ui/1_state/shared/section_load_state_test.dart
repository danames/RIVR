import 'package:flutter_test/flutter_test.dart';
import 'package:rivr/ui/1_state/shared/section_load_state.dart';

void main() {
  group('SectionLoadState', () {
    test('idle is initial state with correct flags', () {
      const state = SectionLoadState.idle;
      expect(state.isIdle, true);
      expect(state.isLoading, false);
      expect(state.isLoaded, false);
      expect(state.isEmpty, false);
      expect(state.isError, false);
      expect(state.isUnavailable, false);
      expect(state.hasData, false);
      expect(state.isDone, false);
    });

    test('loading has correct flags', () {
      const state = SectionLoadState.loading;
      expect(state.isIdle, false);
      expect(state.isLoading, true);
      expect(state.hasData, false);
      expect(state.isDone, false);
    });

    test('loaded has correct flags', () {
      const state = SectionLoadState.loaded;
      expect(state.isLoaded, true);
      expect(state.hasData, true);
      expect(state.isDone, true);
      expect(state.isLoading, false);
      expect(state.isEmpty, false);
    });

    test('empty has correct flags', () {
      const state = SectionLoadState.empty;
      expect(state.isEmpty, true);
      expect(state.hasData, false);
      expect(state.isDone, true);
      expect(state.isLoading, false);
      expect(state.isLoaded, false);
    });

    test('error has correct flags', () {
      const state = SectionLoadState.error;
      expect(state.isError, true);
      expect(state.hasData, false);
      expect(state.isDone, true);
      expect(state.isLoading, false);
    });

    test('unavailable has correct flags', () {
      const state = SectionLoadState.unavailable;
      expect(state.isUnavailable, true);
      expect(state.hasData, false);
      expect(state.isDone, true);
      expect(state.isLoading, false);
    });

    test('all states are distinct', () {
      final states = SectionLoadState.values;
      expect(states.length, 6);
      expect(states.toSet().length, 6);
    });
  });
}
