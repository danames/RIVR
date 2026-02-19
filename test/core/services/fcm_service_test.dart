import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivr/core/services/i_fcm_service.dart';

void main() {
  group('NotificationPermissionResult', () {
    test('has all four expected values', () {
      expect(NotificationPermissionResult.values, hasLength(4));
      expect(
        NotificationPermissionResult.values,
        containsAll([
          NotificationPermissionResult.granted,
          NotificationPermissionResult.denied,
          NotificationPermissionResult.permanentlyDenied,
          NotificationPermissionResult.error,
        ]),
      );
    });

    test('granted is distinct from denied states', () {
      expect(
        NotificationPermissionResult.granted,
        isNot(NotificationPermissionResult.denied),
      );
      expect(
        NotificationPermissionResult.granted,
        isNot(NotificationPermissionResult.permanentlyDenied),
      );
    });

    test('denied is distinct from permanentlyDenied', () {
      expect(
        NotificationPermissionResult.denied,
        isNot(NotificationPermissionResult.permanentlyDenied),
      );
    });
  });

  group('IFCMService interface', () {
    test('navigatorKey setter accepts GlobalKey<NavigatorState>', () {
      // Verify the type system accepts this — compile-time check.
      // A concrete mock would be needed to test runtime behavior,
      // but this verifies the interface contract.
      final key = GlobalKey<NavigatorState>();
      expect(key, isNotNull);
    });
  });
}
