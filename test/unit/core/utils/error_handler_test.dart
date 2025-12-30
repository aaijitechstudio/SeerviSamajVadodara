import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seervi_kshatriya_samaj_vadodara/core/utils/error_handler.dart';
import 'package:seervi_kshatriya_samaj_vadodara/core/errors/app_exceptions.dart';

void main() {
  group('ErrorHandler', () {
    group('Firebase Auth exceptions', () {
      test('handles email-already-in-use', () {
        final exception = FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Email already in use',
        );
        final result = ErrorHandler.handleFirebaseAuthException(exception);
        expect(result, isA<AuthenticationException>());
        expect(result.message, contains('already registered'));
      });

      test('handles weak-password', () {
        final exception = FirebaseAuthException(
          code: 'weak-password',
          message: 'Password is too weak',
        );
        final result = ErrorHandler.handleFirebaseAuthException(exception);
        expect(result, isA<ValidationException>());
        expect(result.message, contains('too weak'));
      });

      test('handles user-not-found', () {
        final exception = FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found',
        );
        final result = ErrorHandler.handleFirebaseAuthException(exception);
        expect(result, isA<NotFoundException>());
        expect(result.message, contains('No account found'));
      });

      test('handles wrong-password', () {
        final exception = FirebaseAuthException(
          code: 'wrong-password',
          message: 'Wrong password',
        );
        final result = ErrorHandler.handleFirebaseAuthException(exception);
        expect(result, isA<AuthenticationException>());
        expect(result.message, contains('Incorrect password'));
      });

      test('handles network-request-failed', () {
        final exception = FirebaseAuthException(
          code: 'network-request-failed',
          message: 'Network error',
        );
        final result = ErrorHandler.handleFirebaseAuthException(exception);
        expect(result, isA<NetworkException>());
        expect(result.message, contains('Network request failed'));
      });
    });

    group('Firestore exceptions', () {
      test('handles permission-denied', () {
        final exception = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Permission denied',
        );
        final result = ErrorHandler.handleFirestoreException(exception);
        expect(result, isA<AuthorizationException>());
        expect(result.message, contains('Permission denied'));
      });

      test('handles unavailable', () {
        final exception = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'unavailable',
          message: 'Service unavailable',
        );
        final result = ErrorHandler.handleFirestoreException(exception);
        expect(result, isA<NetworkException>());
        expect(result.message, contains('temporarily unavailable'));
      });

      test('handles not-found', () {
        final exception = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'not-found',
          message: 'Not found',
        );
        final result = ErrorHandler.handleFirestoreException(exception);
        expect(result, isA<NotFoundException>());
        expect(result.message, contains('not found'));
      });
    });

    group('Exception conversion', () {
      test('converts AppException to Failure', () {
        const exception = NetworkException('Network error');
        final failure = ErrorHandler.exceptionToFailure(exception);
        expect(failure, isNotNull);
        expect(failure.message, 'Network error');
      });

      test('handles unknown exceptions', () {
        final exception = Exception('Unknown error');
        final result = ErrorHandler.handleException(exception);
        expect(result, isA<UnknownException>());
      });
    });
  });
}
