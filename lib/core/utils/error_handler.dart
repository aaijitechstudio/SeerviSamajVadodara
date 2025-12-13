import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:http/http.dart' as http;
import '../errors/app_exceptions.dart';
import '../errors/failure.dart';

/// Centralized error handler utility
/// Converts various error types to app-specific exceptions and failures
class ErrorHandler {
  // Private constructor to prevent instantiation
  ErrorHandler._();

  /// Handle Firebase Auth exceptions
  static AppException handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return AuthenticationException(
          'This email is already registered. Please sign in instead.',
          code: e.code,
          originalError: e,
        );
      case 'weak-password':
        return ValidationException(
          'Password is too weak. Please use a stronger password.',
          code: e.code,
          originalError: e,
        );
      case 'invalid-email':
        return ValidationException(
          'Invalid email address. Please check and try again.',
          code: e.code,
          originalError: e,
        );
      case 'user-not-found':
        return NotFoundException(
          'No account found with this email. Please sign up first.',
          code: e.code,
          originalError: e,
        );
      case 'wrong-password':
        return AuthenticationException(
          'Incorrect password. Please try again.',
          code: e.code,
          originalError: e,
        );
      case 'user-disabled':
        return AuthorizationException(
          'This account has been disabled. Please contact support.',
          code: e.code,
          originalError: e,
        );
      case 'too-many-requests':
        return NetworkException(
          'Too many failed attempts. Please try again later.',
          code: e.code,
          originalError: e,
        );
      case 'operation-not-allowed':
        return ConfigurationException(
          'This operation is not allowed. Please contact support.',
          code: e.code,
          originalError: e,
        );
      case 'network-request-failed':
        return NetworkException(
          'Network request failed. Please check your internet connection.',
          code: e.code,
          originalError: e,
        );
      default:
        return AppFirebaseException(
          e.message ?? 'An authentication error occurred',
          code: e.code,
          originalError: e,
        );
    }
  }

  /// Handle Firestore exceptions
  static AppException handleFirestoreException(firestore.FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return AuthorizationException(
          'Permission denied. You do not have access to this resource.',
          code: e.code,
          originalError: e,
        );
      case 'unavailable':
        return NetworkException(
          'Service is temporarily unavailable. Please try again later.',
          code: e.code,
          originalError: e,
        );
      case 'not-found':
        return NotFoundException(
          'The requested resource was not found.',
          code: e.code,
          originalError: e,
        );
      case 'already-exists':
        return ValidationException(
          'This resource already exists.',
          code: e.code,
          originalError: e,
        );
      case 'deadline-exceeded':
        return TimeoutException(
          'The operation timed out. Please try again.',
          code: e.code,
          originalError: e,
        );
      case 'resource-exhausted':
        return NetworkException(
          'Too many requests. Please try again later.',
          code: e.code,
          originalError: e,
        );
      default:
        return AppFirebaseException(
          e.message ?? 'A Firestore error occurred',
          code: e.code,
          originalError: e,
        );
    }
  }

  /// Handle HTTP exceptions
  static AppException handleHttpException(http.Response? response) {
    if (response == null) {
      return NetworkException(
        'No response received from server.',
      );
    }

    switch (response.statusCode) {
      case 400:
        return ValidationException(
          'Invalid request. Please check your input.',
          code: '400',
        );
      case 401:
        return AuthenticationException(
          'Authentication failed. Please sign in again.',
          code: '401',
        );
      case 403:
        return AuthorizationException(
          'Access denied. You do not have permission.',
          code: '403',
        );
      case 404:
        return NotFoundException(
          'The requested resource was not found.',
          code: '404',
        );
      case 408:
        return TimeoutException(
          'Request timed out. Please try again.',
          code: '408',
        );
      case 429:
        return NetworkException(
          'Too many requests. Please try again later.',
          code: '429',
        );
      case 500:
      case 502:
      case 503:
        return NetworkException(
          'Server error. Please try again later.',
          code: response.statusCode.toString(),
        );
      default:
        return NetworkException(
          'An error occurred: ${response.statusCode}',
          code: response.statusCode.toString(),
        );
    }
  }

  /// Handle generic exceptions
  static AppException handleException(dynamic error) {
    if (error is FirebaseAuthException) {
      return handleFirebaseAuthException(error);
    } else if (error is firestore.FirebaseException) {
      return handleFirestoreException(error);
    } else if (error is AppException) {
      return error;
    } else if (error is Exception) {
      return UnknownException(
        error.toString(),
        originalError: error,
      );
    } else {
      return UnknownException(
        'An unknown error occurred',
        originalError: error,
      );
    }
  }

  /// Get user-friendly error message
  static String getUserFriendlyMessage(AppException exception) {
    return exception.message;
  }

  /// Get user-friendly error message from failure
  static String getUserFriendlyMessageFromFailure(Failure failure) {
    return failure.message;
  }

  /// Convert exception to failure
  static Failure exceptionToFailure(AppException exception) {
    return Failure.fromException(exception);
  }

  /// Convert error to failure
  static Failure errorToFailure(dynamic error) {
    if (error is AppException) {
      return Failure.fromException(error);
    }
    return Failure.fromError(error);
  }
}
