import 'package:flutter_test/flutter_test.dart';
import '../../../lib/core/utils/connected_ago_formatter.dart'; // Update path as needed

void main() {
  group('getConnectionTime Tests', () {
    test('should return "seconds ago" for recent connections', () {
      String result = getConnectionTime(
        DateTime.now().subtract(Duration(seconds: 30)).toIso8601String(),
      );
      expect(result, '30 seconds ago');
    });

    test(
      'should return "minutes ago" for connections within the last hour',
      () {
        String result = getConnectionTime(
          DateTime.now().subtract(Duration(minutes: 10)).toIso8601String(),
        );
        expect(result, '10 minutes ago');
      },
    );

    test(
      'should return "hours ago" for connections within the last 24 hours',
      () {
        String result = getConnectionTime(
          DateTime.now().subtract(Duration(hours: 5)).toIso8601String(),
        );
        expect(result, '5 hours ago');
      },
    );

    test('should return "days ago" for connections within the last week', () {
      String result = getConnectionTime(
        DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
      );
      expect(result, '3 days ago');
    });

    test('should return "weeks ago" for connections within the last month', () {
      String result = getConnectionTime(
        DateTime.now().subtract(Duration(days: 14)).toIso8601String(),
      );
      expect(result, '2 weeks ago');
    });

    test('should return "months ago" for connections within the last year', () {
      String result = getConnectionTime(
        DateTime.now().subtract(Duration(days: 90)).toIso8601String(),
      );
      expect(result, '3 months ago');
    });

    test('should return "years ago" for connections older than a year', () {
      String result = getConnectionTime(
        DateTime.now().subtract(Duration(days: 800)).toIso8601String(),
      );
      expect(result, '2 years ago');
    });
  });
}
