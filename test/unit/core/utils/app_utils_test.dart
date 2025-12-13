import 'package:flutter_test/flutter_test.dart';
import 'package:seervi_kshatriya_samaj_vadodara/core/utils/app_utils.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  group('AppUtils', () {
    group('Date formatting', () {
      test('formatDate formats date correctly', () {
        final date = TestHelpers.createMockDate(
          year: 2024,
          month: 3,
          day: 15,
        );
        final formatted = AppUtils.formatDate(date);
        expect(formatted, '15 Mar 2024');
      });

      test('formatDateTime formats date and time correctly', () {
        final dateTime = TestHelpers.createMockDate(
          year: 2024,
          month: 3,
          day: 15,
          hour: 14,
          minute: 30,
        );
        final formatted = AppUtils.formatDateTime(dateTime);
        expect(formatted, contains('15 Mar 2024'));
        expect(formatted, contains('02:30 PM'));
      });

      test('formatTime formats time correctly', () {
        final time = TestHelpers.createMockDate(
          hour: 14,
          minute: 30,
        );
        final formatted = AppUtils.formatTime(time);
        expect(formatted, '02:30 PM');
      });
    });

    group('Validation', () {
      test('isValidEmail returns true for valid emails', () {
        expect(AppUtils.isValidEmail('test@example.com'), isTrue);
        expect(AppUtils.isValidEmail('user.name@domain.co.uk'), isTrue);
      });

      test('isValidEmail returns false for invalid emails', () {
        expect(AppUtils.isValidEmail('invalid-email'), isFalse);
        expect(AppUtils.isValidEmail('@example.com'), isFalse);
        expect(AppUtils.isValidEmail('test@'), isFalse);
      });

      test('isValidPhone returns true for valid phone numbers', () {
        expect(AppUtils.isValidPhone('1234567890'), isTrue);
        expect(AppUtils.isValidPhone('+911234567890'), isTrue);
        expect(AppUtils.isValidPhone('9876543210'), isTrue);
      });

      test('isValidPhone returns false for invalid phone numbers', () {
        expect(AppUtils.isValidPhone('12345'), isFalse);
        expect(AppUtils.isValidPhone('abc123'), isFalse);
        expect(AppUtils.isValidPhone(''), isFalse);
      });
    });

    group('String utilities', () {
      test('capitalize capitalizes first letter', () {
        expect(AppUtils.capitalize('hello'), 'Hello');
        expect(AppUtils.capitalize('WORLD'), 'World');
        expect(AppUtils.capitalize('test'), 'Test');
      });

      test('capitalize handles empty string', () {
        expect(AppUtils.capitalize(''), '');
      });

      test('truncateText truncates long text', () {
        const longText = 'This is a very long text that needs to be truncated';
        expect(AppUtils.truncateText(longText, 20), 'This is a very long ...');
      });

      test('truncateText returns original text if shorter than maxLength', () {
        const shortText = 'Short';
        expect(AppUtils.truncateText(shortText, 20), 'Short');
      });
    });
  });
}
