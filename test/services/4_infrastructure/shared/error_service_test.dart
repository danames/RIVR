import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:rivr/services/4_infrastructure/shared/error_service.dart';

void main() {
  group('ErrorService', () {
    group('getAuthRecoverySuggestion', () {
      test('returns suggestion for wrong-password', () {
        final suggestion = ErrorService.getAuthRecoverySuggestion('wrong-password');
        expect(suggestion, isNotNull);
        expect(suggestion, contains('Forgot Password'));
      });

      test('returns suggestion for user-not-found', () {
        final suggestion = ErrorService.getAuthRecoverySuggestion('user-not-found');
        expect(suggestion, isNotNull);
        expect(suggestion, contains('email'));
      });

      test('returns suggestion for too-many-requests', () {
        final suggestion = ErrorService.getAuthRecoverySuggestion('too-many-requests');
        expect(suggestion, isNotNull);
        expect(suggestion, contains('Wait'));
      });

      test('returns suggestion for network-request-failed', () {
        final suggestion = ErrorService.getAuthRecoverySuggestion('network-request-failed');
        expect(suggestion, isNotNull);
        expect(suggestion, contains('internet'));
      });

      test('returns suggestion for weak-password', () {
        final suggestion = ErrorService.getAuthRecoverySuggestion('weak-password');
        expect(suggestion, isNotNull);
      });

      test('returns suggestion for requires-recent-login', () {
        final suggestion = ErrorService.getAuthRecoverySuggestion('requires-recent-login');
        expect(suggestion, isNotNull);
        expect(suggestion, contains('Sign out'));
      });

      test('returns null for unknown error codes', () {
        expect(ErrorService.getAuthRecoverySuggestion('some-unknown-code'), isNull);
      });
    });

    group('mapNetworkError', () {
      test('maps PlatformException with network_error code', () {
        final error = PlatformException(code: 'network_error');
        final message = ErrorService.mapNetworkError(error);
        expect(message, contains('Network'));
      });

      test('maps PlatformException with timeout code', () {
        final error = PlatformException(code: 'timeout');
        final message = ErrorService.mapNetworkError(error);
        expect(message, contains('timed out'));
      });

      test('maps PlatformException with cancelled code', () {
        final error = PlatformException(code: 'cancelled');
        final message = ErrorService.mapNetworkError(error);
        expect(message, contains('cancelled'));
      });

      test('maps socket exception pattern', () {
        final message = ErrorService.mapNetworkError(
          Exception('SocketException: network is unreachable'),
        );
        expect(message, contains('No internet'));
      });

      test('maps timeout pattern', () {
        final message = ErrorService.mapNetworkError(
          Exception('Connection timeout after 30s'),
        );
        expect(message, contains('timed out'));
      });

      test('maps host lookup failed', () {
        final message = ErrorService.mapNetworkError(
          Exception('Failed host lookup: api.example.com'),
        );
        expect(message, contains('Unable to connect'));
      });

      test('maps connection refused', () {
        final message = ErrorService.mapNetworkError(
          Exception('Connection refused on port 443'),
        );
        expect(message, contains('Unable to connect'));
      });

      test('maps SSL/certificate errors', () {
        final message = ErrorService.mapNetworkError(
          Exception('SSL certificate verify failed'),
        );
        expect(message, contains('certificate'));
      });

      test('returns generic message for unknown errors', () {
        final message = ErrorService.mapNetworkError(
          Exception('Something completely unknown'),
        );
        expect(message, contains('Network error'));
      });
    });

    group('handleError', () {
      test('handles FormatException', () {
        final message = ErrorService.handleError(const FormatException('bad'));
        expect(message, contains('Invalid data format'));
      });

      test('handles TimeoutException string', () {
        final message = ErrorService.handleError(
          Exception('TimeoutException after 0:00:30'),
        );
        expect(message, contains('timed out'));
      });

      test('handles generic errors', () {
        final message = ErrorService.handleError(Exception('something went wrong'));
        expect(message, contains('error occurred'));
      });
    });

    group('getRetrySuggestion', () {
      test('returns suggestion for network errors', () {
        final suggestion = ErrorService.getRetrySuggestion(
          Exception('network error occurred'),
        );
        expect(suggestion, contains('internet'));
      });

      test('returns suggestion for permission errors', () {
        final suggestion = ErrorService.getRetrySuggestion(
          Exception('permission denied'),
        );
        expect(suggestion, contains('permissions'));
      });

      test('returns suggestion for rate limit errors', () {
        final suggestion = ErrorService.getRetrySuggestion(
          Exception('too many requests'),
        );
        expect(suggestion, contains('wait'));
      });

      test('returns generic suggestion for unknown errors', () {
        final suggestion = ErrorService.getRetrySuggestion(
          Exception('unknown error'),
        );
        expect(suggestion, contains('try again'));
      });
    });

    group('isNetworkError', () {
      test('true for network-related strings', () {
        expect(ErrorService.isNetworkError(Exception('network error')), true);
        expect(ErrorService.isNetworkError(Exception('timeout')), true);
        expect(ErrorService.isNetworkError(Exception('connection refused')), true);
        expect(ErrorService.isNetworkError(Exception('unreachable')), true);
        expect(ErrorService.isNetworkError(Exception('host lookup failed')), true);
      });

      test('false for non-network errors', () {
        expect(ErrorService.isNetworkError(Exception('format error')), false);
        expect(ErrorService.isNetworkError(Exception('null reference')), false);
      });
    });

    group('isRetryableError', () {
      test('true for network errors', () {
        expect(
          ErrorService.isRetryableError(Exception('network error')),
          true,
        );
      });

      test('false for non-retryable errors', () {
        expect(
          ErrorService.isRetryableError(const FormatException('bad data')),
          false,
        );
      });
    });

    group('requiresUserAction', () {
      test('false for generic errors', () {
        expect(
          ErrorService.requiresUserAction(Exception('something')),
          false,
        );
      });
    });
  });
}
